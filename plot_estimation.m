function plot_estimation(scale, M, D)
    
    figure();
    plot(scale, [M; M + D; M - D]');
    xlabel(sprintf('Mean deviation: %g', mean(D)));
    legend('mean', 'mean+deviation', 'mean-deviation');

end