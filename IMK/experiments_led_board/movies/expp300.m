function expp300(version,nTargets,nCycles,duration,patternName)

version = str2double(version);
nTargets = str2double(nTargets);
nCycles = str2double(nCycles);
duration = str2double(duration);
nStimuli = 4;

frameRate = nCycles*nStimuli/duration;
if version == 1
    frameRate = frameRate*2;
end
frameRate = 1000/round(1000/frameRate); % период кратен 1 мс
assert(~rem(nTargets,4))
targets = blocksequence(4,nTargets/4);
stimuli = blocksequence(4,nCycles*nTargets);
movie = zeros(8,8,0);

for t = 1:nTargets
    len = round(frameRate);
    sel = ones(2);
    sel(targets(t)) = 3;
    movie(:,:,end+1:end+len) = pattern(patternName,sel,len);
    movie(:,:,end+1:end+len) = pattern(patternName,ones(2),len);
    for c = 1:nCycles*4
        digit = stimuli(c+(t-1)*nCycles*4);
        sel = ones(2);
        sel(digit) = 2;
        movie(:,:,end+1) = pattern(patternName,sel); %#ok<*AGROW>
        if version == 1
            movie(:,:,end+1) = pattern(patternName,ones(2));
        end
    end
    if version == 1
        movie(:,:,end+1) = pattern(patternName,ones(2));
        movie(:,:,end+1) = pattern(patternName,ones(2));
    else
        movie(:,:,end+1:end+len) = pattern(patternName,ones(2),len);
    end
end

params.fileName = sprintf('p300-v%i-%ix%i-%gs-%s',version,nTargets,nCycles,duration,patternName);
params.type = 'p300';
params.version = version;
params.patternName = patternName;
params.prestimulus = len*2;
params.targets = targets;
params.stimuli = stimuli;
params.nTargets = nTargets;
params.nCycles = nCycles;
params.duration = duration;
params.nStimuli = nStimuli;
params.epochPoints = 15;
params.epochDuration = 0.6;
params.frameRate = frameRate;
save([params.fileName '.mat'],'movie','frameRate','params')
fprintf('Сохранен\t%.1f Hz\t\t%s\n',frameRate,params.fileName);

return
