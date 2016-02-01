% result    номер детектированого стимула или 0
% learn     если проводилось обучение, то количество сэмплов, или 0
% successRes проценты правильных детектирований (после второго обучения)
% falseRes   проценты ложных детектирований (после второго обучения)
function [result,learn,successRes,falseRes] = p300process(eegData,params)
global stepNo showTarget
persistent mdl buffer successPerf falsePerf prevShowTarget

% вычисление фич
features = zeros(size(eegData,1),params.nEpochPoints,'single');
l = size(eegData,2)/params.nEpochPoints;
for n = 1:size(eegData,1)
    for m = 1:params.nEpochPoints
        features(n,m) = mean(single(eegData(n,(m-1)*l+(1:l))));
    end
end
features = bsxfun(@minus,features,mean(features,2));
features = features(:);

% счетчик шагов
if isempty(stepNo) || stepNo == 0 || isempty(falsePerf) || isempty(successPerf)
    stepNo = single(0);
    successPerf = single(0);
    falsePerf = single(0);
    showTarget = int8(-1);
    prevShowTarget = int8(-1);
    buffer = zeros([numel(features),params.nStimuli,params.nCycles],'single');
    if params.version <= 100
        mdl = fishertrain(numel(features));
    else
        tau = params.nTargets*params.nCycles*params.nStimuli/10;
        mdl = fisheradapt([numel(features),tau,params.nStimuli]);
    end
end
stepNo = stepNo + 1;
state = p300state(stepNo-params.nEpochSteps,params);

if params.version <= 100
    % сбор данных для обучения
    if state.target && state.stimul
        fishertrain(features,state.target==state.stimul);
    end
else
    % адаптивное обучение
    if state.target
        mdl = fisheradapt(mdl,features,state.stimul==state.target);
    end
end

% добавление данных в кольцевой буффер
if state.stimul
    subStep = 1+rem(fix((stepNo-params.nEpochSteps-1)/params.nStimuli),params.nCycles);
    buffer(:,state.stimul,subStep) = features;
end

% классификация
result = int8(-1);
type = false;
if state.validate || state.detect
    if params.version <= 100 && isempty(coder.target())
        [mdl.threshold,type] = controlthreshold;
    end
    values = mdl.weights*mean(buffer,3);
    [val,ind] = max(values);
    result = int8(ind);
    if val <= mdl.threshold
        result = int8(0); % если ни один не определился
    elseif sum(single(values>mdl.threshold)) > 1 && ~type
        result = int8(params.nStimuli+1); % если определилось слишком много
    end
    if state.detect
        prevShowTarget = showTarget;
        showTarget = result;
        if params.version > 100 && prevShowTarget == showTarget
            % дообучение
            for n = 1:params.nStimuli
                mdl = fisheradapt(mdl,buffer(:,n,subStep),n==showTarget);
            end
        end
    end
end

% валидация
if state.validate && result >= 1 && result <= params.nStimuli
    if result == state.target
        successPerf = successPerf + 100/(params.nTargets-params.nTrainTargets);
    else
        falsePerf = falsePerf + 100/(params.nTargets-params.nTrainTargets);
    end
end

if params.version <= 100
    % вычисление модели
    learn = int32((stepNo-1)*params.nStepSamples*state.learn);
    if state.learn
        mdl = fishertrain(params.nCycles,params.nStimuli);
        if isempty(coder.target())
            controlthreshold(mdl.threshold,mdl.mu);
        end
    end
else
    learn = int32(0);
end

successRes = successPerf;
falseRes = falsePerf;

return
