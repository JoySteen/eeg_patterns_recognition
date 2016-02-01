% ��������� ����������, ������������ �������� � ������� �����������
function params = p300settings(version)
sampleRate = single(250);               % ������� �������������
nEpochSteps = single(4);                % ����� �� �����
nStimuli = single(4);                   % ���������� �������� � ����� �����
nTargets = single(40);                  % ���������� ����� ��� ��������
nPrestimulusCycles = single(5);         % ������������ �������������� ��������� ��� ��������
if ischar(version), version = str2double(version); end
switch mod(version,100)
    case 4
        stepDuration = single(0.144);           % ������������ ����
        nCycles = single(5);                    % ���������� ������ ��� �������������� 
        params.nEpochPoints = single(12);       % ���������� ����� ������� � �����
        params.checksum = 38029;
    case 5
        stepDuration = single(0.128);           % ������������ ����
        nCycles = single(6);                    % ���������� ������ ��� �������������� 
        params.nEpochPoints = single(16);       % ���������� ����� ������� � �����
        params.checksum = 29673;
    case 6
        stepDuration = single(0.128);           % ������������ ����
        nCycles = single(12);                   % ���������� ������ ��� �������������� 
        params.nEpochPoints = single(16);       % ���������� ����� ������� � �����
        params.checksum = 39118;
    otherwise
        error('�������� ����� ������')
end
params.targets = uint8(blocksequence(nStimuli,nTargets/nStimuli));
params.stimuli = uint8(blocksequence(nStimuli,nCycles*nTargets));
params.nTrainTargets = round(nTargets*2/3);
params.nTargetSteps = (nCycles+nPrestimulusCycles)*nStimuli;
params.nStimuli = nStimuli;
params.nCycles = nCycles;
params.nTargets = nTargets;
params.type = 'p300';
params.sampleRate = sampleRate;
params.version = single(version);
params.stepDuration = stepDuration;
params.frameRate = 1/stepDuration;
params.epochDuration = stepDuration*nEpochSteps;
params.nEpochSteps = nEpochSteps;
params.stepDuration = stepDuration;
params.nPrestimulusCycles = nPrestimulusCycles;
params.prestimulus = nPrestimulusCycles*nStimuli;
params.fileName = sprintf('dev-p300-v%i',version);
% ��������� ���������, ��������� �� sampleRate
nStepSamples = stepDuration*sampleRate;
params.nStepSamples = nStepSamples;
params.nFrameSamples = nStepSamples;
params.nEpochSamples = stepDuration*nEpochSteps*sampleRate;
params.nSamples = nTargets*(nCycles+nPrestimulusCycles)*nStimuli*nStepSamples+(nEpochSteps-1)*nStepSamples;
return
