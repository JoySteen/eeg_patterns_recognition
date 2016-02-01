% result    ����� ��������������� ������� ��� 0
% learn     ���� ����������� ��������, �� ���������� �������, ��� 0
% successRes �������� ���������� �������������� (����� ������� ��������)
% falseRes   �������� ������ �������������� (����� ������� ��������)
function [result,learn,successRes,falseRes] = cvepprocess(eegData,params)
global stepNo showTarget
persistent mdl buffer successPerf falsePerf prevShowTarget

% ���������� ���
eegData = single(eegData);
features = zeros(size(eegData,1)*length(params.frequencies)*2,params.nStimuli,'single');
for o = 1:params.nStimuli
    offset = (stepNo-1)*params.nStepSamples-params.offsets(o)*params.sampleRate/params.frameRate;
    features(:,o) = cvepfeatures(offset,eegData,params);
end

% ������� �����
if isempty(stepNo) || stepNo == 0 || isempty(falsePerf) || isempty(successPerf)
    stepNo = single(0);
    successPerf = single(0);
    falsePerf = single(0);
    showTarget = int8(-1);
    prevShowTarget = int8(-1);
    buffer = zeros([size(features),params.nSteps],'single');
    if params.version <= 100
        mdl = fishertrain(size(features,1));
    else
        tau = params.nTargets*params.nSteps*params.nStimuli/10;
        mdl = fisheradapt([size(features,1),tau,params.nStimuli]);
    end
end
stepNo = stepNo + 1;
state = cvepstate(stepNo,params);

if params.version <= 100
    % ���� ������ ��� ��������
    if state.target ~= 0
        for n = 1:params.nStimuli
            fishertrain(features(:,n),n==state.target);
        end
    end
else
    % ���������� ��������
    if state.target ~= 0
        for n = 1:params.nStimuli
            mdl = fisheradapt(mdl,features(:,n),n==state.target);
        end
    end
end

% ���������� ������ � ��������� ������
buffer(:,:,1+rem(stepNo,params.nSteps)) = features;

% ��������������
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
        result = int8(0); % ���� �� ���� �� �����������
    elseif sum(single(values>mdl.threshold)) > 1 && ~type
        result = int8(params.nStimuli+1); % ���� ������������ ������� �����
    end
    if state.detect
        prevShowTarget = showTarget;
        showTarget = result;
        if params.version > 100 && prevShowTarget == showTarget
            % ����������
            for n = 1:params.nStimuli
                mdl = fisheradapt(mdl,features(:,n),n==showTarget);
            end
        end
    end
end

% ���������
if state.validate && result >= 1 && result <= params.nStimuli
    if result == state.target
        successPerf = successPerf + 100/(params.nTargets-params.nTrainTargets);
    else
        falsePerf = falsePerf + 100/(params.nTargets-params.nTrainTargets);
    end
end

if params.version <= 100
    % ���������� ������
    learn = int32((stepNo-1)*params.nStepSamples*state.learn);
    if state.learn
        mdl = fishertrain(params.nSteps,params.nStimuli);
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
