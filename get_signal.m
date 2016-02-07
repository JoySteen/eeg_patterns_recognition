function [signal, params] = get_signal(type)

    if ~exist('type', 'var')
        type = 'r';
    else
        validateattributes(type, {'char'}, {});
    end
    
    params = struct();
    switch type
        case 'r'
            raw = load('218.mat');
            signal = [raw.data(:, 2:6) zeros(size(raw.data, 1), 3)]';
            
            params.Fs = raw.params.sampleRate;
            params.epoch_duration = raw.params.epochDuration;
            params.start_time = 0.3;
            params.flick_time = raw.params.stepDuration;
            params.idle_time = raw.params.stepDuration;
            
            clear raw;
        case 'm'
            signal = channels;
            
            params.Fs = 250;
            params.epoch_duration = 0.6;
            params.start_time = 0.3;
            params.flick_time = 0.15;
            params.idle_time = 0.15;
        otherwise
            clear params;
            error('Signal may only be (r)eal or (m)odel');
    end
    
    params.signal_length = size(signal, 2);
    params.epoch_length = params.epoch_duration * params.Fs;

end