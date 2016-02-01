function eeg = selectelectrodes(eeg)
global selectedElectrodes referenceElectrode noiseLevel

% очистка глобальных переменных
if ischar(eeg) && strcmp(eeg,'clear')
    selectedElectrodes = [];
    referenceElectrode = [];
    noiseLevel = [];
    clear eeg
    return
end

% добавление шума
if ~isempty(noiseLevel)
    eeg = eeg + randn(size(eeg))*noiseLevel;
end

% изменение референтного электрода
if ~isempty(referenceElectrode)
    eeg = bsxfun(@minus,eeg,eeg(:,referenceElectrode));
end

% выбор электродов
if ~isempty(selectedElectrodes)
    eeg = eeg(:,selectedElectrodes);
end

return
