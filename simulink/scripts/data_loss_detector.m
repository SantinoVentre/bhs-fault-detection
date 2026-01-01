function alarm = data_loss_detector(signal, timeout, sample_time)
    % Detects intermittent signal loss or communication dropout
    persistent last_valid_time invalid_counter;
    
    if isempty(last_valid_time)
        last_valid_time = 0;
        invalid_counter = 0;
    end
    
    if ~isnan(signal) && ~isinf(signal) && signal >= 0
        last_valid_time = 0;
        invalid_counter = 0;
        alarm = 0;
    else
        invalid_counter = invalid_counter + 1;
        time_without_signal = invalid_counter * sample_time;
        
        if time_without_signal > timeout
            alarm = 1;
        else
            alarm = 0;
        end
    end
end