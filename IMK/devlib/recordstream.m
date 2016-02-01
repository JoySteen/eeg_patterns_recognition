% ��������� ������ � ���������� � ���������� �� ����� ��������
function recordstream(port,type,version,fileName,subject,outPort) %#ok<INUSL>

if ischar(version)
    version = str2double(version);
end

if nargin>=4 && ( exist(fileName,'file') || exist([fileName,'.mat'],'file') )
    error('���� ��� ����������')
end

devinit;

[params,~,run] = devsettings(type,version);

s = niopen(port);
%fread(s,11);    % ������ ������� ������ ����� ��������

data = zeros(0,8,'int32');
t = 0;
count = 0;
lastCommand = 0;
while 1
    drawnow
    [block,vars] = nistream(s);
    if any(block(:,1)~=(size(data,1)+(1:size(block,1))'))
        fprintf(2,'�������� ������ ��������!\n');
    end
    data = [ data; block ]; %#ok<AGROW>
    while size(data,1) >= t + params.nStepSamples
        [result,~,successPerf,falsePerf] = run(data(t+(1:params.nStepSamples),:)',params);
        t = t + params.nStepSamples;
        %disp([learn,successPerf,size(data,1)-t])
        if t == params.nSamples
            fprintf('������� �� Matlab: %.0f%% ����������, %.0f%% ������, �������� %i\n',successPerf,falsePerf,checksum);
        end
        if t == params.nSamples+params.nStepSamples
            % ���������� �� ��� ������, ��� nSamples.
            % ��� ���������� ������, ��� ���������� ���������� ����������
            % ������� �� ��� �����, ��� ������� ���� ���������.
            % ����� ���������, ��� � ���������� data ��������� ������
            % ������, � �� ����� ��������� ��� ������ � ����.
            if size(data,1)-t ~= 0 % ���� �� ���������� ������ ���, �� �������� ���������� �� ���������
                vars.checksum = NaN;
            end
            fprintf('���������� ����������: %.0f%% ����������, %.0f%% ������, �������� %i\n',vars.successPerf,vars.falsePerf,vars.checksum);
            if nargin >= 5
                today = date(); %#ok<NASGU>
                pdata = data;
                data = data(1:params.nSamples+params.nStepSamples,:); %#ok<NASGU>
                save(fileName,'data','vars','subject','params','today')
                data = pdata;
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

