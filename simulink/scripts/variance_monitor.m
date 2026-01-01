function alarm = variance_monitor(signal, window_size, max_variance)
    % Detects excessive noise by monitoring signal variance
    persistent buffer buffer_index;
    
    if isempty(buffer)
        buffer = zeros(window_size, 1);
        buffer_index = 1;
    end
    
    buffer(buffer_index) = signal;
    buffer_index = mod(buffer_index, window_size) + 1;
    
    current_variance = var(buffer);
    
    if current_variance > max_variance
        alarm = 1;
    else
        alarm = 0;
    end
end