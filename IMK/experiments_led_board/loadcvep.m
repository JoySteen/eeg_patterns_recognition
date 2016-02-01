function [epochs, params] = loadcvep(fileName)

load(fileName,'params','subject')

if isempty(who('movie','-file',fileName))
    % запись с микроконтроллера
    params = devsettings(params.type,params.version); %#ok<NODEF>
    load(fileName,'data')
    eeg = single(data(:,3:7)); %#ok<NODEF>
    onsets = 0:params.nFrameSamples:params.nSamples;
    onsets = onsets(1:end-1);
else
    % загрузка данных EDF
    load(fileName,'movie','frameRate')
    [eeg,sampleRate,onsets] = loadedf(fileName);
    if length(onsets)==size(movie,3)+1 % идеальное соответствие
        onsets = onsets(1:end-1);
    elseif length(onsets)==size(movie,3)+2 % один отсчет лишний
        [~,ind] = min(onsets(2:end)-onsets(1:end-1));
        onsets = onsets([1:ind-1,ind+1:end-1]);
        if str2double(fileName) > 200
            fprintf(2,'Лишний отсчет\n');
        end
    elseif length(onsets)<=size(movie,3)
        if str2double(fileName) > 220
            fprintf(2,'%i отсчета пропали\n',size(movie,3)-length(onsets)+1);
        end
        onsets(end+1:end+size(movie,3)-length(onsets)) = onsets(end);
    else
        error('Не соответствует количество отсчетов')
    end
    params.frameRate = frameRate;
    params.sampleRate = sampleRate;
    params.nStimuli = 4;
    params.nEpochSteps = 2;
    
    % параметры алгоритма, зависимые от sampleRate
    params.nEpochSamples = params.sampleRate/params.frameRate*params.period;
    params.nStepSamples = params.nEpochSamples/params.nEpochSteps;
    params.nSteps = (params.nCycles-1)*params.nEpochSteps+1;
    params.nWindowSamples = 2^nextpow2(params.nEpochSamples);
    params.window = [ hann(fix(params.nEpochSamples))', zeros(1,params.nWindowSamples-fix(params.nEpochSamples)) ];
    params.nFrequencies = round((params.period-1)/2*params.nWindowSamples/params.nEpochSamples);
    params.frequencies = 1+(1:params.nFrequencies);
    params.nFrameSamples = nan; % не используется
    
    % некорректное количество фреймов в старых данных
    if str2double(fileName) <= 166 && str2double(fileName) >= 150
        onsets = onsets(1:end-1);
    end
end

% Выбор рабочих электродов
eeg = selectelectrodes(eeg);

% выбор фактических начал стимулов
switch mod(params.version,100)
    case 4
        assert(length(onsets)==params.nTargets*params.period*(params.nCycles+params.nPrestimulusCycles))
        onsets = reshape(onsets,[length(onsets)/params.nTargets,params.nTargets]);
        onsets = onsets(params.prestimulus+1:end,:);
    case 3
        assert(length(onsets)==params.nTargets*params.period*params.nCycles)
        onsets = reshape(onsets,[length(onsets)/params.nTargets,params.nTargets]);
    case {1,2}
        onsets = reshape(onsets,[length(onsets)/params.nTargets,params.nTargets]);
        onsets = onsets(params.prestimulus+1:end,:);
        assert(size(onsets,1)==params.period*params.nCycles)
end

% разбиение на эпохи
len = ceil(params.period*params.nCycles/params.frameRate*params.sampleRate);
epochs = zeros(size(eeg,2),len,params.nTargets);
for t = 1:params.nTargets
    epoch = eeg(onsets(1,t)+(1:len),:)';
    epochs(:,:,t) = epoch;
end

return

