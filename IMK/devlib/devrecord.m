% ��������� ������ � ���������� � ���������� �� ����� ��������
%
% devrecord(fileName) ��������� ���������� ������ �� �����.
%
% devrecord(fileName,type,version[,subject]) ���������� ������ � �������
% devgenerate, ��������� ���������� � �����.
%
% devrecord(fileName,type,version,subject,inPort[,outPort]) ���������
% ������ � ����������, ��������� ���������� � ����.
%
% outPort - ��� ���� ���������� ZigBee
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
        error('���� ��� ����������')
    end
    [params,generate,run] = devsettings(type,version);
end

devinit;

if nargin >= 5
    s = niopen(inPort);
    %fread(s,11);    % ������ ������� ������ ����� ��������
end

data = zeros(0,8,'int32');
checksum = crc([]);
t = 0;
count = 0;
lastCommand = 0;
while 1
    drawnow
    if nargin == 1
        % ���������� �� �����
        if size(data,1)+params.nStepSamples > size(source,1)
            break
        end
        block = source(size(data,1)+(1:params.nStepSamples),:);
    elseif nargin >= 5
        % ���������� � ����������
        try
            [block,vars] = nistream(s);
            if any(block(:,1)~=(size(data,1)+(1:size(block,1))'))
                fprintf(2,'�������� ������ ��������');
                break
            end
        catch
            break
        end
    else
        % ��������� �������� ������
        block = zeros(params.nStepSamples,8,'int32');
        for k = 1:params.nStepSamples
            block(k,3:7) = generate(int32(size(data,1)+k),params)';
        end
    end
    data = [ data; block ]; %#ok<AGROW>
    % ��������� ������
    while size(data,1) >= t + params.nStepSamples
        eegData = data(t+(1:params.nStepSamples),:)';
        [result,~,successPerf,falsePerf] = run(eegData,params);
        checksum = crc(int32(sum(eegData(3:7,:),1)),checksum);
        t = t + params.nStepSamples;
        if t == params.nSamples
            fprintf('������� �� Matlab: %.0f%% ����������, %.0f%% ������\n',successPerf,falsePerf);
            if checksum == params.checksum
                fprintf('�������� %i (������������� �����)\n',checksum);
            else
                fprintf('�������� %i\n',checksum);
            end
        end
        if t == params.nSamples+params.nStepSamples
            % ���������� �� ��� ������, ��� nSamples.
            % ��� ���������� ������, ��� ���������� ���������� ����������
            % ������� �� ��� �����, ��� ������� ���� ���������.
            % ����� ���������, ��� � ���������� data ��������� ������
            % ������, � �� ����� ��������� ��� ������ � ����.
            if nargin >= 5
                fprintf('���������� ����������: %.0f%% ����������, %.0f%% ������\n',vars.successPerf,vars.falsePerf);
            else
                vars = [];
            end
            if nargin > 1
                today = date(); %#ok<NASGU>
                pdata = data;
                data = data(1:params.nSamples+params.nStepSamples,:); %#ok<NASGU>
                save(fileName,'data','vars','subject','params','today')
                data = pdata;
                fprintf('�������� %s\n',fileName);
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
    fprintf('���������� %s\n',fileName);
end
