function processnoisy(fileName)
global noiseLevel
selectelectrodes clear

if ~nargin
    processnoisy 122|129|136|141|144|146|148
    processnoisy 124|132|137|142|145|147|149
    return
end

% вызов с несколькими агументами
fileName = strsplit(fileName,'|');
if numel(fileName) > 1
    figure
    for k = 1:numel(fileName)
        processnoisy(fileName{k});
    end
    xlabel('uV')
    ylabel('%')
    return
else
    fileName = fileName{1};
end

load(fileName,'params','subject')

% записи с микроконтроллера
assert(~isempty(who('movie','-file',fileName)))

% деление целей на три части
part1 = 1:round(params.nTargets/3);
part2 = part1(end)+1:round(params.nTargets*2/3);
part3 = part2(end)+1:params.nTargets;

res = [];
for level = 0:20
    noiseLevel = level; %#ok<NASGU>
    
    % валидация
    results = [];
    targets = [];
    results = [ results, run(params,fileName,[part1,part2],part3) ]; %#ok<*AGROW>
    targets = [ targets, params.targets(part3) ];
    results = [ results, run(params,fileName,[part1,part3],part2) ];
    targets = [ targets, params.targets(part2) ];
    results = [ results, run(params,fileName,[part2,part3],part1) ];
    targets = [ targets, params.targets(part1) ];
    
    % печать результатов
    perf = sum(results==targets)/length(targets);
    err = sum(results~=0&results~=targets)/length(targets);
    fprintf('%.0f uV\t%s\t%s\t%.0f\t%.0f\t%s\n',level,fileName,subject,...
        perf*100,err*100,params.fileName);
    res = [ res; level perf*100 ];
end
noiseLevel = [];

hold all
plot(res(:,1),res(:,2))
drawnow

return

function results = run(params,fileName,trainInds,testInds)
switch params.type
    case 'cvep'
        results = processcvep(fileName,trainInds,testInds);
    case 'p300'
        results = processp300(fileName,trainInds,testInds);
end
return
