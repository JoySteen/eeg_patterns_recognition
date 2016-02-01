function runtest1

devinit;

fileName = '131';
[epochs, params] = loadcvep(fileName);
params.nTrainTargets = round(params.nTargets*2/3);
params.nTargetSteps = params.nCycles*params.nEpochSteps;

nFrameSamples = params.sampleRate/params.frameRate;
nEpochSamples = nFrameSamples*params.period;
nStepSamples = nEpochSamples/params.nEpochSteps;
fprintf('nFrameSamples: %g\n',nFrameSamples);
fprintf('nEpochSamples: %g\n',nEpochSamples);
fprintf('nStepSamples: %g\n',nStepSamples);
assert(rem(nFrameSamples,1)==0&&rem(nEpochSamples,1)==0&&rem(nStepSamples,1)==0)

results = zeros(params.nSteps,size(epochs,3));
emptyEegData = nan(5,params.nEpochSamples);
cvepprocess(emptyEegData,params);
for n = 1:size(epochs,3)
    for k = 1:params.nTargetSteps
        if k < params.nEpochSteps
            [results(k,n),~,successPerf,falsePerf] = cvepprocess(emptyEegData,params);
        else
            eegData = epochs(:,(1:params.nEpochSamples)+(k-params.nEpochSteps)*params.nStepSamples,n);
            [results(k,n),~,successPerf,falsePerf] = cvepprocess(int32(eegData*1000),params);
        end
    end
end

cvepprocess(emptyEegData,params);
cvepprocess(emptyEegData,params);
cvepprocess(emptyEegData,params);
cvepprocess(emptyEegData,params);
cvepprocess(emptyEegData,params);
cvepprocess(emptyEegData,params);

results
disp([successPerf falsePerf])

return
