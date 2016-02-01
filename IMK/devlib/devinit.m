% инициализирует счетчик
%
function success = devinit(learn,params)
global stepNo
success = true;
if ~nargin || learn
    stepNo = single(0);
else
    if stepNo*params.nStepSamples < params.nSamples
        success = false;
    else
        stepNo = params.nTargets*params.nTargetSteps;
    end
end
return
