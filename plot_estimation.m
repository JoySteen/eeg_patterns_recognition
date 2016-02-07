function plot_estimation(scale, M, D)
    
    figure();
    plot(scale, [M; M + D; M - D]');
    legend('mean', 'mean+dispersion', 'mean-dispersion');

end