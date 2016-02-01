function params = cvepsettings(version)
if ischar(version), version = str2double(version); end
assert(mod(version,100)==4)
nStimuli = single(4);       % количество стимулов
nTargets = single(40);      % количество целей в режиме обучения
frameRate = single(31.25);  % частота кадров
sampleRate = single(250);   % частота сэмплов
period = single(16);        % количество кадров в периоде
nCycles = single(6);        % количество периодов для детектирования одной цели
nEpochSteps = single(2);    % количество шагов в эпохе (одном периоде)
nPrestimulusCycles = single(2); % количество циклов для индикации зеленой цели
params.offsets = single([0 3 8 13]);    % смещения цикла разных стимулов
params.nTrainTargets = round(nTargets*2/3);
params.targets = uint8(blocksequence(nStimuli,nTargets/nStimuli)); % цели
params.checksum = 41220;
sequences = int8([ % последовательности вспыхивания стимулов
    1 1 1 0 0 1 1 0 1 1 0 1 0 0 0 0
    0 0 0 1 1 1 0 0 1 1 0 1 1 0 1 0
    1 1 0 1 0 0 0 0 1 1 1 0 0 1 1 0
    0 0 1 1 0 1 1 0 1 0 0 0 0 1 1 1
    ]);
params.nTargets = nTargets;
params.patternName = 'symbols';
params.period = period;
params.nCycles = nCycles;
params.frameRate = frameRate;
params.sampleRate = sampleRate;
params.sequences = uint8(sequences);
params.nStimuli = nStimuli;
params.nEpochSteps = nEpochSteps;
params.nTargetSteps = (nCycles+nPrestimulusCycles)*nEpochSteps;
params.version = single(version);
params.type = 'cvep';
params.nPrestimulusCycles = nPrestimulusCycles;
params.prestimulus = nPrestimulusCycles*period;
params.fileName = sprintf('dev-cvep-v%i',version);
% параметры алгоритма, зависимые от sampleRate
nFrameSamples = sampleRate/frameRate;
nEpochSamples = nFrameSamples*period;
nStepSamples = nEpochSamples/nEpochSteps;
nWindowSamples = 2^nextpow2(nEpochSamples);
window = single([ hann(nEpochSamples)', zeros(1,nWindowSamples-nEpochSamples) ]);
nFrequencies = round((period-1)/2*nWindowSamples/nEpochSamples);
frequencies = 1+(1:nFrequencies);
params.nFrameSamples = nFrameSamples;
params.nEpochSamples = nEpochSamples;
params.nStepSamples = nStepSamples;
params.nSteps = (nCycles-1)*nEpochSteps+1;
params.nWindowSamples = nWindowSamples;
params.window = window;
params.nFrequencies = nFrequencies;
params.frequencies = frequencies;
params.nSamples = nTargets*(nCycles+nPrestimulusCycles)*nEpochSamples;
params.nTargetSamples = (nCycles+nPrestimulusCycles)*nEpochSamples;
return
