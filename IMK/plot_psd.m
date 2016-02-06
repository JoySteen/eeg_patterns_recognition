function plot_psd(signal, Fs, filters, name)
    validateattributes(signal, {'numeric'}, {'vector'});
    validateattributes(Fs, {'numeric'}, {'scalar'});
    if ~exist('name', 'var')
        name = 'Spectrum';
    else
        validateattributes(name, {'char'}, {});
    end
    
    N = size(signal, 1);
    magnitude = pwelch(signal, N);

%     [pxx, f] = pwelch(signal, N);
%     f = f*Fs/(2*pi);
%     plot(f, pxx);
    
    fig = figure('Name', name, 'Visible', 'off');
    Nf = size(filters, 2);
    for i = 1:Nf
        subplot(1, Nf, i);
        f0 = filters{i}.f0;
        f1 = filters{i}.f1;
        plot(f0:f1, magnitude(f0:f1));
        xlim([f0 f1]);
        power = bandpower(signal, Fs, [f0 f1]);
        xlabel(power);
    end
    
    print(strcat(name, '.png'), '-dpng');
    close(fig);
end