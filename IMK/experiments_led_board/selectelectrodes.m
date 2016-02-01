function eeg = selectelectrodes(eeg)
global selectedElectrodes referenceElectrode noiseLevel

% ������� ���������� ����������
if ischar(eeg) && strcmp(eeg,'clear')
    selectedElectrodes = [];
    referenceElectrode = [];
    noiseLevel = [];
    clear eeg
    return
end

% ���������� ����
if ~isempty(noiseLevel)
    eeg = eeg + randn(size(eeg))*noiseLevel;
end

% ��������� ������������ ���������
if ~isempty(referenceElectrode)
    eeg = bsxfun(@minus,eeg,eeg(:,referenceElectrode));
end

% ����� ����������
if ~isempty(selectedElectrodes)
    eeg = eeg(:,selectedElectrodes);
end

return
