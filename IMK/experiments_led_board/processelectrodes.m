function processelectrodes(fileName)
global selectedElectrodes referenceElectrode
selectelectrodes clear

if ~nargin
    processelectrodes 122|129|136|141|144|146|148
    processelectrodes 124|132|137|142|145|147|149
    return
end

warning off MATLAB:singularMatrix

% вызов с несколькими агументами
fileName = strsplit(fileName,'|');
if numel(fileName) > 1
    for k = 1:numel(fileName)
        processelectrodes(fileName{k});
    end
    return
else
    fileName = fileName{1};
end

load(fileName,'params','subject')

% деление целей на три части
part1 = 1:round(params.nTargets/3);
part2 = part1(end)+1:round(params.nTargets*2/3);
part3 = part2(end)+1:params.nTargets;

sets = [
%     1 0 0 0 0
%     0 1 0 0 0
%     0 0 1 0 0
%     0 0 0 1 0
%     0 0 0 0 1
%     1 0 1 1 1
%     1 1 1 1 1

    2 1 1 1 1
    1 2 1 1 1
    1 1 2 1 1
    1 1 1 2 1
    1 1 1 1 2
    ];

for elec = 1:size(sets,1)
    selectedElectrodes = find(sets(elec,:)==1); %#ok<*NASGU>
    referenceElectrode = find(sets(elec,:)==2);
    
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
    descr = sprintf('%i',sets(elec,:));
    fprintf('%s\t%s\t%s\t%.0f\t%.0f\t%s\n',descr,fileName,subject,...
        perf*100,err*100,params.fileName);
end
selectedElectrodes = [];
referenceElectrode = [];

warning on MATLAB:singularMatrix

return

function results = run(params,fileName,trainInds,testInds)
switch params.type
    case 'cvep'
        results = processcvep(fileName,trainInds,testInds);
    case 'p300'
        results = processp300(fileName,trainInds,testInds);
end
return
