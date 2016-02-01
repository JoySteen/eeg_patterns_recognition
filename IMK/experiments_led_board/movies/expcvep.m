% Таблица приблизительных частот сэмплирования
%   frameRate: nCycles x period
%   10 Hz: 1x31 2x15 4x7
%   15 Hz: 3x15 6x7
%   20 Hz: 1x63 2x31 4x15
%   30 Hz: 3x31 6x15 12x7
function expcvep(version,nTargets,nCycles,period,duration,patternName)

version = str2double(version);
nTargets = str2double(nTargets);
nCycles = str2double(nCycles);
period = str2double(period);
duration = str2double(duration);
nStimuli = 4;

assert(~rem(nTargets,nStimuli))
targets = blocksequence(nStimuli,nTargets/nStimuli);
[stimuli,offsets,sequences] = cvep(patternName,period,version);
frameRate = nCycles*period/duration;
frameRate = 500/round(500/frameRate); % период кратен 2 мс
stimuli = repmat(stimuli,[1,1,nCycles]);

movie = zeros(8,8,0);
prestimulus = fix(frameRate/2)*2;
for t = 1:nTargets
    sel = ones(2);
    sel(targets(t)) = 3;
    movie(:,:,end+1:end+prestimulus/2) =  pattern(patternName,ones(2),prestimulus/2);
    movie(:,:,end+1:end+prestimulus/2) =  pattern(patternName,sel,prestimulus/2);
    movie(:,:,end+1:end+size(stimuli,3)) = stimuli;
end

params.fileName = sprintf('cvep-v%i-%ix%ix%i-%gs-%s',version,nTargets,nCycles,period,duration,patternName);
params.type = 'cvep';
params.version = version;
params.patternName = patternName;
params.offsets = offsets;
params.targets = targets;
params.nTargets = nTargets;
params.nCycles = nCycles;
params.sequences = sequences;
params.period = period;
params.prestimulus = prestimulus;
params.nStimuli = nStimuli;
params.frameRate = frameRate;
save(params.fileName,'movie','frameRate','params')
fprintf('Сохранен\t%.1f Hz\t\t%s\n',frameRate,params.fileName);

return
