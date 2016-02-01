function [perf,err,type] = process(fileName,varargin)

selectelectrodes clear

% вызов с несколькими агументами
fileName = strsplit(fileName,'|');
if numel(fileName) > 1
    res = [ 0, 0 ];
    for k = 1:numel(fileName)
        [perf,err] = process(fileName{k});
        res = res + [ perf, err ];
    end
    res = res/numel(fileName);
    %fprintf('total: %.1f\t%.1f\n',res(1)*100,res(2)*100);
    clear
    return
else
    fileName = fileName{1};
end

load(fileName,'params','subject','today')

% записи с микроконтроллера
if isempty(who('movie','-file',fileName))
    params = devsettings(params.type,params.version); %#ok<NODEF>
end

% деление целей на три части
part1 = 1:round(params.nTargets/3);
part2 = part1(end)+1:round(params.nTargets*2/3);
part3 = part2(end)+1:params.nTargets;

% валидация
results = [];
targets = [];
results = [ results, run(params,fileName,[part1,part2],part3) ];
targets = [ targets, params.targets(part3) ];
results = [ results, run(params,fileName,[part1,part3],part2) ];
targets = [ targets, params.targets(part2) ];
results = [ results, run(params,fileName,[part2,part3],part1) ];
targets = [ targets, params.targets(part1) ];

% печать результатов
perf = sum(results==targets)/length(targets);
err = sum(results~=0&results~=targets)/length(targets);
%fprintf('%s\t%s\t%s\t%.0f\t%.0f\t%s\n',today,fileName,subject,...
%    perf*100,err*100,params.fileName);
type = params.type;
if ~nargout
    clear
end

return

function results = run(params,fileName,trainInds,testInds)
switch params.type
    case 'cvep'
        results = processcvep(fileName,trainInds,testInds);
    case 'p300'
        results = processp300(fileName,trainInds,testInds);
end
return
