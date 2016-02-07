function [signal] = get_signal(type)
% Returns 8*N matrix of signal - recorded in experiment(type='r') or generated as a model(type='m')
    if ~exist('type', 'var')
        type = 'r';
    else
        validateattributes(type, {'char'}, {});
    end
    
    switch type
        case 'r'
            raw = load('218.mat');
            disp(size(raw.data, 1));
            disp(size(raw.data(:, 2:6), 1));
            signal = [ raw.data(:, 2:6) zeros(size(raw.data, 1), 3)]';
            clear raw;
        case 'm'
            signal = channels;
        otherwise
            error('Signal may only be (r)eal or (m)odel');
    end

end