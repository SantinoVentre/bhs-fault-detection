function alarm = stuck_detector(signal, window_size, min_change)
    % Detects if signal is not changing (stuck/frozen)
    persistent buffer buffer_index;
    
    if isempty(buffer)
        buffer = zeros(window_size, 1);
        buffer_index = 1;
    end
    
    buffer(buffer_index) = signal;
    buffer_index = mod(buffer_index, window_size) + 1;
    
    signal_range = max(buffer) - min(buffer);
    
    if signal_range < min_change
        alarm = 1;
    else
        alarm = 0;
    end
end