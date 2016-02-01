% Генерация тестовых данных
%   t - номер сэмпла тестовой последовательности
%   data - показания 5-ти электродов
function data = p300generate(t,params)

data = zeros(5,1,'int32');

if t < 1
    return
end

t = single(t);
stepNo = 1 + fix((t-1)/params.nStepSamples);
state = p300state(stepNo,params);

if ~state.target
    state.target = uint8(1);
end

if state.stimul && state.target == state.stimul
    t = t - (stepNo-1)*params.nStepSamples - 1;
    for k = 1:5
        data(k) = data(k) + int32(1000*sin(t*2*pi/params.nStepSamples*(k+1)));
    end
end

return
