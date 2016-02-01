% определяет состояние state по номеру шага stepNo
% нулевой момент времени - stepNo == 1
function state = p300state(stepNo,params)

if ~nargin % тестирование
    testprocessstate
    return
end

state.target = uint8(0);            % цель для обучения
state.stimul = uint8(0);            % текущий показываемый стимул
state.learn = false;                % вычислять модель
state.validate = false;             % выполнять валидацию
state.detect = false;               % проводить детектирование

if stepNo < 1
    return
end

targetNo = 1+fix((stepNo-1)/params.nTargetSteps);
stimulNo = single(0);
if targetNo >= 1 && targetNo <= params.nTargets
    state.target = params.targets(targetNo);
    targetStepNo = stepNo - (targetNo-1)*params.nTargetSteps;
    if targetStepNo > params.nPrestimulusCycles*params.nStimuli
        stimulNo = targetStepNo - params.nPrestimulusCycles*params.nStimuli + (targetNo-1)*params.nCycles*params.nStimuli;
        state.stimul = params.stimuli(stimulNo);
    end
else
    stimulNo = 1+rem(stepNo-1-params.nTargets*params.nTargetSteps,length(params.stimuli));
    state.stimul = params.stimuli(stimulNo);
end

if stimulNo && rem(stimulNo,params.nStimuli) == 0 && stepNo > params.nTargets*params.nTargetSteps + (params.nCycles-1)*params.nStimuli
    state.detect = true;
end

if stepNo == params.nTrainTargets*params.nTargetSteps
    state.learn = true;  % для валидации
elseif stepNo == params.nTargets*params.nTargetSteps
    state.learn = true; % основная модель
end

if targetNo <= params.nTargets && targetNo > params.nTrainTargets && stepNo == targetNo*params.nTargetSteps
    state.validate = true;
end

return

function testprocessstate
params.nStimuli = 4;
params.nTargets = 4;
params.nCycles = 3;
params.nEpochSteps = 3;
params.nTrainTargets = 2;
params.targets = blocksequence(params.nStimuli,params.nTargets/params.nStimuli);
params.stimuli = blocksequence(params.nStimuli,params.nCycles*params.nTargets);
params.nPrestimulusCycles = 1;
params.nTargetSteps = (params.nCycles+params.nPrestimulusCycles)*params.nStimuli;
data = [
    1  0 0 0 0 0
    2  0 0 0 0 0
    3  0 0 0 0 0
    4  3 0 0 0 0
    5  3 0 0 0 0
    6  3 0 0 0 0
    7  3 0 0 0 0
    8  3 3 0 0 0
    9  3 1 0 0 0
    10 3 2 0 0 0
    11 3 4 0 0 0
    12 3 1 0 0 0
    13 3 3 0 0 0
    14 3 2 0 0 0
    15 3 4 0 0 0
    16 3 3 0 0 0
    17 3 2 0 0 0
    18 3 4 0 0 0
    19 3 1 0 0 0
    20 1 0 0 0 0
    21 1 0 0 0 0
    22 1 0 0 0 0
    23 1 0 0 0 0
    24 1 2 0 0 0
    25 1 3 0 0 0
    26 1 4 0 0 0
    27 1 1 0 0 0
    28 1 2 0 0 0
    29 1 4 0 0 0
    30 1 1 0 0 0
    31 1 3 0 0 0
    32 1 2 0 0 0
    33 1 4 0 0 0
    34 1 3 0 0 0
    35 1 1 1 0 0
    36 2 0 0 0 0
    37 2 0 0 0 0
    38 2 0 0 0 0
    39 2 0 0 0 0
    40 2 4 0 0 0
    41 2 3 0 0 0
    42 2 1 0 0 0
    43 2 2 0 0 0
    44 2 4 0 0 0
    45 2 1 0 0 0
    46 2 2 0 0 0
    47 2 3 0 0 0
    48 2 4 0 0 0
    49 2 1 0 0 0
    50 2 3 0 0 0
    51 2 2 0 1 0
    52 4 0 0 0 0
    53 4 0 0 0 0
    54 4 0 0 0 0
    55 4 0 0 0 0
    56 4 4 0 0 0
    57 4 3 0 0 0
    58 4 1 0 0 0
    59 4 2 0 0 0
    60 4 3 0 0 0
    61 4 4 0 0 0
    62 4 2 0 0 0
    63 4 1 0 0 0
    64 4 4 0 0 0
    65 4 2 0 0 0
    66 4 1 0 0 0
    67 4 3 1 1 0
    68 0 3 0 0 0
    69 0 1 0 0 0
    70 0 2 0 0 0
    71 0 4 0 0 0
    72 0 1 0 0 0
    73 0 3 0 0 0
    74 0 2 0 0 0
    75 0 4 0 0 0
    76 0 3 0 0 0
    77 0 2 0 0 0
    78 0 4 0 0 0
    79 0 1 0 0 1
    80 0 2 0 0 0
    81 0 3 0 0 0
    82 0 4 0 0 0
    83 0 1 0 0 1
    84 0 2 0 0 0
    85 0 4 0 0 0
    86 0 1 0 0 0
    87 0 3 0 0 1
    88 0 2 0 0 0
    89 0 4 0 0 0
    90 0 3 0 0 0
    91 0 1 0 0 1
    ];
fields = {'target' 'stimul' 'learn' 'validate' 'detect'};
for k = 1:size(data,1)
    state = p300state(data(k,1)-params.nEpochSteps,params);
    for n = 1:length(fields)
        if data(k,n+1) ~= state.(fields{n})
            disp(state)
            error('строка %i, поле %s, значение %i',k,fields{n},state.(fields{n}))
        end
    end
end
fprintf('Тест пройден\n');
return
