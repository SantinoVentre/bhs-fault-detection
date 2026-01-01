function alarm = threshold_detector(signal, mean_expected, std_expected, n_sigma)
    % Detects if signal is outside normal range (mean ± n*std)
    upper_limit = mean_expected + n_sigma * std_expected;
    lower_limit = mean_expected - n_sigma * std_expected;
    
    if signal > upper_limit || signal < lower_limit
        alarm = 1;
    else
        alarm = 0;
    end
end