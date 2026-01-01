function alarm = drift_detector(signal, window_size, drift_threshold)
    % Detects gradual drift by comparing signal to moving average
    persistent buffer buffer_index sum_buffer;
    
    if isempty(buffer)
        buffer = zeros(window_size, 1);
        buffer_index = 1;
        sum_buffer = 0;
    end
    
    sum_buffer = sum_buffer - buffer(buffer_index);
    buffer(buffer_index) = signal;
    sum_buffer = sum_buffer + signal;
    buffer_index = mod(buffer_index, window_size) + 1;
    
    moving_avg = sum_buffer / window_size;
    deviation = abs(signal - moving_avg);
    
    if deviation > drift_threshold
        alarm = 1;
    else
        alarm = 0;
    end
end