% Cz - vector of samples on EEG channel Cz
% N - number of samples
% Fs - sample frequency
% ts - timestamp - vector, ith value of which is time when ith sample
% recorded

load 'Cz.mat';
Fs = 250;
N = size(Cz, 2);
ts = [1 : N] / Fs;
figure('Name', 'Cz signal');
plot(ts, Cz);

plot_spectrum(fft(Cz), Fs);

% windowWidth - width of moving window in real-time emulation
% window - last windowWidth samples
% stepWidth - width of window moving step

windowWidth = 250;
stepWidth = windowWidth * 0.2;
for i = windowWidth-stepWidth+1 : N
    if ~mod(i, stepWidth)
        k = k + 1;
        start = i - windowWidth + 1;
        finish = i;
        window = Cz(start : finish);
        
        plot_spectrum(fft(window), Fs, sprintf('%g - %g', ts(start), ts(finish)));
    end
end