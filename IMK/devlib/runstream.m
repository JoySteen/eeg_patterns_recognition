% Пропускает данные, записанные с устройства, через алгоритм
function runstream(fileName)

load(fileName,'params','data')

[params,~,devrun] = devsettings(params.type,params.version); %#ok<NODEF>

devinit;
for t = 1:params.nStepSamples:size(data,1) %#ok<NODEF>
    [result,learn,successRes,falseRes,checksumRes] = devrun(data(t+(0:params.nStepSamples-1),:)',params); %#ok<ASGLU>
    %disp([result,learn,successRes,falseRes])
    if t+params.nStepSamples-1 == params.nSamples
        disp([successRes,falseRes,checksumRes])
    end
end


return
