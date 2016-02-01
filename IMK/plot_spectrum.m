function plot_spectrum(signal, sampling_frequency, name)
    validateattributes(signal, {'numeric'}, {'vector'});
    validateattributes(sampling_frequency, {'numeric'}, {'scalar'});
    if ~exist('name', 'var')
        name = 'Spectrum';
    end
    
    N = size(signal, 2);
    ss = [1 : N] * sampling_frequency / N;
    figure('Name', name);
    subplot(2, 1, 1); plot(ss, abs(signal)); title('Magnitude');
    subplot(2, 1, 2); plot(ss, angle(signal)); title('Phase');
end