% eegData - массив [8,params.nStepSamples] одного шага данных. Из этого
% массива выбираются строки 3:7. Несколько шагов стыкуются вместе,
% фильтруются и передаются в функцию process.
function [result,learn,successRes,falseRes] = p300run(eegData,params)
global stepNo
persistent epoch A B boundary %#ok<PUSE>
if isempty(epoch) || ~stepNo || isempty(A) || isempty(B)
    [B,A] = devfilter;
    epoch = zeros(5,params.nEpochSamples,'single');
    [~,~,~,~] = p300process(epoch,params);
    boundary = zeros(max(length(A),length(B))-1,5,'single');
end
eegData = single(eegData(3:7,:));
% [eegData,boundary] = filter(B,A,eegData',boundary);
% eegData = eegData';
epoch = circshift(epoch,[0,-params.nStepSamples]);
epoch(:,end-params.nStepSamples+1:end) = eegData;
[result,learn,successRes,falseRes] = p300process(epoch,params);
return
