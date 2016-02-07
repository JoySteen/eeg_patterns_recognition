function [epochs] = identify_epochs(signal, Fs)

    epoch_duration = 0.6;
    start_time = 0.3;
    flick_time = 0.15;
    idle_time = 0.15;
    
    N = Fs * epoch_duration;
    
    epochs = [];
    for i = Fs*start_time+N:N:size(signal, 2)
        epochs = [epochs; signal(:, i-N+1:i)];
    end
    
end