% определяет состояние state по номеру шага stepNo
% нулевой момент времени - stepNo == 1
function state = cvepstate(stepNo,params)

if ~nargin % тестирование
    testprocessstate
    return
end

state.target = uint8(0);            % цель для обучения
state.learn = false;                % вычислять модель
state.validate = false;             % выполнять валидацию
state.detect = false;               % выполнять детектирование

trainTargetNo = single(0);
if stepNo > 1 && stepNo-1 <= params.nTargets*params.nTargetSteps
    trainTargetNo = 1+fix((stepNo-2)/params.nTargetSteps);
    if stepNo-1 >= (trainTargetNo-1)*params.nTargetSteps+...
            (1+params.nPrestimulusCycles)*params.nEpochSteps;
        state.target = params.targets(trainTargetNo);
    end
end

if stepNo-1 == params.nTrainTargets*params.nTargetSteps
    state.learn = true;  % для валидации
elseif stepNo-1 == params.nTargets*params.nTargetSteps
    state.learn = true; % основная модель
end

if trainTargetNo <= params.nTargets && ...
        trainTargetNo > params.nTrainTargets && ...
        stepNo-1 == trainTargetNo*params.nTargetSteps
    state.validate = true;
end

if stepNo-1 >= params.nTargets*params.nTargetSteps+...
        params.nCycles*params.nEpochSteps
    state.detect = true;
end

return

function testprocessstate
params.targets = 1:4;
params.nTargets = 4;
params.nEpochSteps = 2;
params.nCycles = 3;
params.nTrainTargets = 2;
params.nPrestimulusCycles = 1;
params.nTargetSteps = (params.nCycles+params.nPrestimulusCycles)*params.nEpochSteps;
data = [
    1  0 0 0 0
    2  0 0 0 0
    3  0 0 0 0
    4  0 0 0 0
    5  1 0 0 0
    6  1 0 0 0
    7  1 0 0 0
    8  1 0 0 0
    9  1 0 0 0
    10 0 0 0 0
    11 0 0 0 0
    12 0 0 0 0
    13 2 0 0 0
    14 2 0 0 0
    15 2 0 0 0
    16 2 0 0 0
    17 2 1 0 0
    18 0 0 0 0
    19 0 0 0 0
    20 0 0 0 0
    21 3 0 0 0
    22 3 0 0 0
    23 3 0 0 0
    24 3 0 0 0
    25 3 0 1 0
    26 0 0 0 0
    27 0 0 0 0
    28 0 0 0 0
    29 4 0 0 0
    30 4 0 0 0
    31 4 0 0 0
    32 4 0 0 0
    33 4 1 1 0
    34 0 0 0 0
    35 0 0 0 0
    36 0 0 0 0
    37 0 0 0 0
    38 0 0 0 0
    39 0 0 0 1
    40 0 0 0 1
    41 0 0 0 1
    ];
fields = {'target' 'learn' 'validate' 'detect'};
for k = 1:size(data,1)
    state = cvepstate(data(k,1),params);
    for n = 1:length(fields)
        if data(k,n+1) ~= state.(fields{n})
            error('строка %i, поле %s',k,fields{n})
        end
    end
end
fprintf('Тест пройден\n');
return
