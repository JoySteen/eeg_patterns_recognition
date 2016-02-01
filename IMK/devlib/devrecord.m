% Считывает данные с устройства и пропускает их через алгоритм
%
% devrecord(fileName) Считывает записанные данные из файла.
%
% devrecord(fileName,type,version[,subject]) Генерирует данные с помощью
% devgenerate, сохраняет результаты в файле.
%
% devrecord(fileName,type,version,subject,inPort[,outPort]) Считывает
% данные с устройства, сохраняет результаты в файл.
%
% outPort - ком порт устройства ZigBee
%
function devrecord(fileName,type,version,subject,inPort,outPort) %#ok<INUSL>

if nargin == 1
    load(fileName,'params','data')
    source = data; %#ok<NODEF>
    [~,~,run] = devsettings(params.type,params.version); %#ok<NODEF>
    fprintf('Protocol: %s, version %i\n',params.type,params.version)
else
    if nargin < 4
        subject = '--'; %#ok<NASGU>
    end
    if ischar(version)
        version = str2double(version);
    end
    if exist(fileName,'file') || exist([fileName,'.mat'],'file')
        error('Файл уже существует')
    end
    [params,generate,run] = devsettings(type,version);
end

devinit;

if nargin >= 5
    s = niopen(inPort);
    %fread(s,11);    % чтение первого пакета после загрузки
end

data = zeros(0,8,'int32');
checksum = crc([]);
t = 0;
count = 0;
lastCommand = 0;
while 1
    drawnow
    if nargin == 1
        % считывание из файла
        if size(data,1)+params.nStepSamples > size(source,1)
            break
        end
        block = source(size(data,1)+(1:params.nStepSamples),:);
    elseif nargin >= 5
        % считывание с устройства
        try
            [block,vars] = nistream(s);
            if any(block(:,1)~=(size(data,1)+(1:size(block,1))'))
                fprintf(2,'Неверные номера отсчетов');
                break
            end
        catch
            break
        end
    else
        % генерация тестовых данных
        block = zeros(params.nStepSamples,8,'int32');
        for k = 1:params.nStepSamples
            block(k,3:7) = generate(int32(size(data,1)+k),params)';
        end
    end
    data = [ data; block ]; %#ok<AGROW>
    % обработка данных
    while size(data,1) >= t + params.nStepSamples
        eegData = data(t+(1:params.nStepSamples),:)';
        [result,~,successPerf,falsePerf] = run(eegData,params);
        checksum = crc(int32(sum(eegData(3:7,:),1)),checksum);
        t = t + params.nStepSamples;
        if t == params.nSamples
            fprintf('Обучено по Matlab: %.0f%% правильных, %.0f%% ложных\n',successPerf,falsePerf);
            if checksum == params.checksum
                fprintf('Чексумма %i (соответствует тесту)\n',checksum);
            else
                fprintf('Чексумма %i\n',checksum);
            end
        end
        if t == params.nSamples+params.nStepSamples
            % Записываем на шаг больше, чем nSamples.
            % Это необходимо потому, что устройство отправляет результаты
            % команды на шаг позже, чем команда была выполнена.
            % Может оказаться, что в переменной data находится больше
            % данных, и ее нужно укоротить для записи в файл.
            if nargin >= 5
                fprintf('Результаты устройства: %.0f%% правильных, %.0f%% ложных\n',vars.successPerf,vars.falsePerf);
            else
                vars = [];
            end
            if nargin > 1
                today = date(); %#ok<NASGU>
                pdata = data;
                data = data(1:params.nSamples+params.nStepSamples,:); %#ok<NASGU>
                save(fileName,'data','vars','subject','params','today')
                data = pdata;
                fprintf('Сохранен %s\n',fileName);
            end
        end
        if t >= params.nSamples+params.nStepSamples && result >= 0
            if result == params.nStimuli+1
                fprintf('*');
            elseif result == 0
                fprintf('.');
            else
                fprintf('%i',result)
            end
            count = count + 1;
            if ~mod(count,100)
                fprintf('\n')
            end
            if nargin >= 6 && result > 0
                if lastCommand ~= result
                    nizigbee(outPort,result);
                    lastCommand = result;
                end
            end
        end
    end
end
fprintf('\n')

if nargin > 1
    save(fileName,'-append','data')
    fprintf('ДоСохранен %s\n',fileName);
end
