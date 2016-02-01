% t - номер текущего сэмпла
function selection = cvepshow(t,params)
global showTarget
t = single(t);
frameNo = 1 + fix((t-1)/params.nFrameSamples);
selection = params.sequences(:,1+rem(frameNo-1,params.period));
targetNo = 1 + fix((t-1)/params.nTargetSamples);
if targetNo <= params.nTargets
    if t < (targetNo-1)*params.nTargetSamples+params.nPrestimulusCycles*params.nEpochSamples
        selection = zeros(4,1,'uint8');
        target = params.targets(targetNo);
        selection(target) = 2;
    end
else
    if showTarget > 0
        selection(showTarget) = selection(showTarget)*3;
    end
end
return
