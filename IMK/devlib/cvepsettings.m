function params = cvepsettings(version)
if ischar(version), version = str2double(version); end
assert(mod(version,100)==4)
nStimuli = single(4);       % ���������� ��������
nTargets = single(40);      % ���������� ����� � ������ ��������
frameRate = single(31.25);  % ������� ������
sampleRate = single(250);   % ������� �������
period = single(16);        % ���������� ������ � �������
nCycles = single(6);        % ���������� �������� ��� �������������� ����� ����
nEpochSteps = single(2);    % ���������� ����� � ����� (����� �������)
nPrestimulusCycles = single(2); % ���������� ������ ��� ��������� ������� ����
params.offsets = single([0 3 8 13]);    % �������� ����� ������ ��������
params.nTrainTargets = round(nTargets*2/3);
params.targets = uint8(blocksequence(nStimuli,nTargets/nStimuli)); % ����
params.checksum = 41220;
sequences = int8([ % ������������������ ����������� ��������
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
% ��������� ���������, ��������� �� sampleRate
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
