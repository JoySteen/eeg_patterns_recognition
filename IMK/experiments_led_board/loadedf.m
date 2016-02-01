function [eeg,sampleRate,onsets] = loadedf(filename)

% данные устройства Нейрон-Спектр
[data,annotation] = ReadEDF([filename,'.edf']); 
sampleRate = annotation.samplerate(1);
channels = annotation.channels;
eeg = zeros(length(data{1}),channels);
for ch = 1:channels
    eeg(:,ch) = data{ch};
end

% вычитание среднего каждого канала
eeg = eeg - repmat(mean(eeg,1),[size(eeg,1),1]); 

% диод присоединен к последнему каналу
diode = eeg(:,end);
eeg = eeg(:,1:end-1);

% начала эпох
[onsets,diode] = stimuli_onsets(diode);

if ~nargout
    clf reset
    time = (0:size(eeg,1)-1)/sampleRate;
    for n = 1:size(eeg,2)
        subplot(size(eeg,2)+1,1,n)
        a(n) = gca; %#ok<AGROW>
        plot(time,eeg(:,n))
        xlim([time(1) time(end)])
    end
    subplot(size(eeg,2)+1,1,size(eeg,2)+1)
    plot(time,diode)
    hold on
    onsets = onsets(onsets~=0);
    plot(time(onsets),diode(onsets),'.r')
    linkaxes(a,'y')
    linkaxes([a gca],'x')
    fprintf('%i точек\n',length(onsets))
    clear
end

return

% Определяет начала эпох по показаниям диода
function [onsets,diode] = stimuli_onsets(diode)

slope = [ 0; diode(3:end)-diode(1:end-2); 0 ];
slope = abs(slope);
values = sort(slope);
maxval = values(end-100);
%maxval = max(slope);
threshold = maxval/2;
start = find(slope(2:end)>=threshold&slope(1:end-1)<threshold);
stop = find(slope(2:end)<threshold&slope(1:end-1)>=threshold);
onsets = round((start+1+stop)/2);

return
