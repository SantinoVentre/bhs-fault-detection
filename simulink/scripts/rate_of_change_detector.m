function alarm = rate_of_change_detector(signal, max_rate, sample_time)
    % Detects sudden jumps or unrealistic rate of change
    persistent previous_signal;
    
    if isempty(previous_signal)
        previous_signal = signal;
        alarm = 0;
        return;
    end
    
    delta = abs(signal - previous_signal);
    rate = delta / sample_time;
    
    previous_signal = signal;
    
    if rate > max_rate
        alarm = 1;
    else
        alarm = 0;
    end
end