% Генерация тестовых данных
%   t - номер сэмпла тестовой последовательности
%   data - показания 5-ти электродов
function data = cvepgenerate(t,params)

data = zeros(5,1,'int32');

if t < 1
    return
end

t = single(t);
targetNo = 1+fix((t-1)/params.nTargetSamples);
sampleNo = t - targetNo*params.nTargetSamples;
if targetNo <= params.nTargets
    target = params.targets(targetNo);
else
    target = uint8(1);
end

t = sampleNo-1-params.offsets(target)*params.nFrameSamples;
for k = 1:5
    data(k) = data(k) + int32(1000*sin(t*2*pi/params.nEpochSamples*(k+1)));
end

return
