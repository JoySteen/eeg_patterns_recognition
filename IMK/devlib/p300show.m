% t - номер текущего сэмпла
function selection = p300show(t,params)
global showTarget

t = single(t);
stepNo = 1 + fix((t-1)/params.nStepSamples);
state = p300state(stepNo,params);

selection = zeros(4,1,'uint8');
if state.stimul
    selection(state.stimul) = 1;
end

if state.target && ~state.stimul
    targetStepNo = stepNo - fix((stepNo-1)/params.nTargetSteps)*params.nTargetSteps;
    if targetStepNo <= params.prestimulus*2/3 && targetStepNo > params.prestimulus/3
        selection(state.target) = 2;
    else
        selection(state.target) = 0;
    end
end

if showTarget > 0
    selection(showTarget) = selection(showTarget) + 2;
end

return
