% eegData - ������ [8*params.nStepSamples] ������ ���� ������. �� �����
% ������� ���������� ������ 3:7. ��������� ����� ��������� ������ �
% ���������� � ������� process.
function [result,learn,successRes,falseRes] = cveprun(eegData,params)
global stepNo
persistent epoch
if isempty(epoch) || ~stepNo
    epoch = zeros(5,params.nEpochSamples,'single');
    cvepprocess(epoch,params);
end
eegData = single(eegData(3:7,:));
epoch = circshift(epoch,[0,-params.nStepSamples]);
epoch(:,end-params.nStepSamples+1:end) = eegData;
[result,learn,successRes,falseRes] = cvepprocess(epoch,params);
return
