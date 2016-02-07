function [epochs] = identify_epochs(channel, params)
    
    epoch_length = params.Fs * params.epoch_duration;
    N_epochs = round(params.signal_length / epoch_length);
    start_num = params.Fs*params.start_time;
    disp(N_epochs);
    epochs = zeros(N_epochs, epoch_length);

    for i = 1 : N_epochs - 1
        p0 = start_num + (i-1)*epoch_length;
        p1 = p0 + epoch_length - 1;
        epochs(i, :) = channel(p0 : p1);
    end
end