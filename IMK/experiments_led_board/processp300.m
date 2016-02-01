% results = processp300(fileName,trainInds,testInds) выполняет расчет
% processp300(fileName) показывает графики
% X = processp300(fileName) возвращает данные для fisheradapttest
function results = processp300(fileName,trainInds,testInds)

use_filter = 0;

load(fileName,'params','subject')

if isempty(who('movie','-file',fileName))
    % запись с микроконтроллера
    params = devsettings(params.type,params.version); %#ok<NODEF>
    load(fileName,'data')
    eeg = single(data(:,3:7)); %#ok<NODEF>
    onsets = 0:params.nFrameSamples:params.nSamples;
    if use_filter
        [B,A] = devfilter;
        %load devfilter A B
        eeg = bsxfun(@minus,eeg,mean(eeg,1));
        %hold all
        %plot(eeg(:,1))
        eeg = filter(B,A,eeg);
        shift = round(length(B)/2);
        eeg = [ eeg(shift:end,:); ones(shift,1)*eeg(end,:) ];
        %plot(eeg(:,1))
    end
else
    % загрузка данных EDF
    load(fileName,'movie','frameRate')
    [eeg,sampleRate,onsets] = loadedf(fileName);
    onsets = [ onsets(1); onsets(1+find(diff(onsets)>3)) ]; % выкидываем близко лежащие отсчеты
    assert(length(onsets)==size(movie,3)+1)         % необходимо точное соответствие
    params.sampleRate = sampleRate;
    % коррекция параметров
    if ~isfield(params,'nEpochPoints'), params.nEpochPoints = params.epochPoints; end
    params.nEpochSamples = params.epochDuration*sampleRate;
    % некорректное количество фреймов в старых данных
    if ( params.version == 3 || params.version == 4 ) && str2double(fileName) <= 166
        onsets = onsets(1:end-1);
    end
end

% выбор фактических начал стимулов
onsets = onsets(1:end-1);
switch mod(params.version,100)
    case 1
        onsets = reshape(onsets,[length(onsets)/params.nTargets,params.nTargets]);
        onsets = onsets(params.prestimulus+1:2:end-2,:);
    case 2
        onsets = reshape(onsets,[length(onsets)/params.nTargets,params.nTargets]);
        onsets = onsets(params.prestimulus+1:end-params.prestimulus/2,:);
    case 3
        onsets = onsets(1:end-params.nEpochSteps+1);
        onsets = reshape(onsets,[length(onsets)/params.nTargets,params.nTargets]);
    case {4,5,6}
        onsets = onsets(1:end-params.nEpochSteps+1);
        onsets = reshape(onsets,[length(onsets)/params.nTargets,params.nTargets]);
        onsets = onsets(params.prestimulus+1:end,:);
end
assert(size(onsets,1)==params.nStimuli*params.nCycles)
onsets = onsets(:)';

% Выбор рабочих электродов
eeg = selectelectrodes(eeg);

% разбиение на эпохи
epochs = zeros(size(eeg,2),params.nEpochSamples,length(params.stimuli),'single');
for n = 1:length(onsets)
    epoch = eeg(onsets(n)+(1:params.nEpochSamples),:)';
    epochs(:,:,n) = epoch;
end

% показ графиков
if ~nargout
    if isempty(who('movie','-file',fileName))
        %epochs = epochs*2.048/2^23/128; % перевод в мкВ для коэффициента усиления 128
        %epochs = epochs*2.048/2^23/2*4000; % перевод в мкВ для коэффициента усиления 2/4000
    end
    figure
    epochs = bsxfun(@minus,epochs,mean(epochs,2));
    for chan = 1:size(epochs,1)
        targetStimuli = repmat(params.targets,[params.nStimuli*params.nCycles,1]);
        targetStimuli = reshape(targetStimuli,[1,numel(targetStimuli)]);
        isTarget = params.stimuli==targetStimuli;
        for k = 1:4
            x = squeeze(epochs(chan,:,~isTarget));
            x = reshape(x,[size(x,1),params.nCycles*(params.nStimuli-1),size(x,2)/params.nCycles/(params.nStimuli-1)]);
            x = permute(mean(x,2),[1,3,2]);
            y = squeeze(epochs(chan,:,isTarget));
            y = reshape(y,[size(y,1),params.nCycles,size(y,2)/params.nCycles]);
            y = permute(mean(y,2),[1,3,2]);
            t = (0:size(x,1)-1)'/params.sampleRate;
            mx = mean(x,2);
            my = mean(y,2);
            mx = mx - mean(mx);
            my = my - mean(my);
            subplot(3,3,chan)
            hold all
            plot(t,x,'Color',[0.7,0.7,1,0.1])
            plot(t,y,'Color',[1,0.7,0.7,0.1])
            plot(t,mx,'-b')
            plot(t,my,'-r')
        end
    end
    subplot(3,1,3)
    plot((0:size(eeg,1)-1)/params.sampleRate,eeg)
    title(fileName)
    return
end

% децимация
features = reshape(epochs,[size(epochs,1),size(epochs,2)/params.nEpochPoints,params.nEpochPoints,size(epochs,3)]); %#ok<*UNRCH>
features = permute(mean(features,2),[1,3,4,2]);
features = bsxfun(@minus,features,mean(features,2));
%features = bsxfun(@rdivide,features,std(features,[],2)); %!!!
features = reshape(features,[size(features,1)*size(features,2),size(features,3)]);

% вывод данных для fisheradapttest
if nargin == 1
    results = zeros(size(features,1),params.nTargets,params.nCycles,params.nStimuli);
    for n = 0:params.nTargets*params.nCycles*params.nStimuli-1
        i = fix(n/params.nCycles/params.nStimuli);
        j = fix((n-i*params.nCycles*params.nStimuli)/params.nStimuli);
        k = params.stimuli(1+n)-1;
        results(:,1+i,1+j,1+k) = features(:,n+1);
    end
    return
end

% индексы
targetStimuli = repmat(params.targets,[params.nStimuli*params.nCycles,1]);
targetStimuli = reshape(targetStimuli,[1,numel(targetStimuli)]);
len = params.nStimuli*params.nCycles;
inds = repmat((trainInds-1)*len,[len,1]);
inds = inds + repmat((1:len)',[1,size(inds,2)]);
inds = inds(:)';
isTarget = params.stimuli==targetStimuli;

% обучение
fishertrain;
fishertrain(features(:,inds),isTarget(inds));
mdl = fishertrain(params.nCycles,params.nStimuli);

% довычисление порога
% tinds = repmat((testInds-1)*len,[len,1]);
% tinds = tinds + repmat((1:len)',[1,size(tinds,2)]);
% tinds = tinds(:)';
% fishertrain;
% fishertrain(features(:,tinds),isTarget(tinds));
% mdl = fishertrain(params.nCycles,params.nStimuli,mdl);

% обучение по fisheradapt
% tau = params.nTargets*params.nCycles*params.nStimuli/10;
% mdl = fisheradapt([size(features,1),tau,params.nStimuli]);
% mdl = fisheradapt(mdl,features(:,inds),isTarget(inds));
% mdl = fisheradapt(mdl,features(:,inds),isTarget(inds));

% тестирование
labels = zeros(params.nStimuli,length(testInds));
for n = 1:length(testInds)
    len = params.nStimuli*params.nCycles;
    points = (testInds(n)-1)*len+(1:len);
    for k = 1:params.nStimuli
        vects = features(:,points(params.stimuli(points)==k));
        labels(k,n) = mean(mdl.weights*vects) > mdl.threshold;
    end
end
[~,results] = max(labels,[],1);
results(sum(labels,1)~=1) = 0;

return
