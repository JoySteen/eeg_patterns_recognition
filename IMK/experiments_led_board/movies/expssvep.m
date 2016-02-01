function expssvep(nTargets,patternName)

nTargets = str2double(nTargets);

rng default
targets = randi(4,1,nTargets);
[stimuli,frameRate,frequencies] = ssvep(patternName);

movie = zeros(8,8,0);
for t = 1:nTargets
    len = round(frameRate);
    sel = ones(2);
    sel(targets(t)) = 3;
    movie(:,:,end+1:end+len) = pattern(patternName,sel,len);
%    movie(:,:,end+1:end+len) = pattern(patternName,ones(2),len);
    movie(:,:,end+1:end+size(stimuli,3)) = stimuli;
end

params.fileName = sprintf('exp-%i-ssvep-%s',nTargets,patternName);
params.patternName = patternName;
params.type = 'ssvep';
params.prestimulus = len*1;
params.ssFrequencies = frequencies;
params.targets = targets;
params.nStimuli = 4;
params.nTargets = nTargets;
save(params.fileName,'movie','frameRate','params')

return
