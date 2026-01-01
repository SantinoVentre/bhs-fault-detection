function [health_score, status, alarm_details] = health_score_calculator(signal, sensor_type, sensor_params, sample_time)
    % HEALTH_SCORE_CALCULATOR - Calculates overall health score (0-100)
    %
    % Inputs:
    %   signal - Current sensor reading
    %   sensor_type - 'barcode', 'weight', 'position', 'speed', 'distance'
    %   sensor_params - Struct with expected parameters
    %   sample_time - Simulation sample time
    %
    % Outputs:
    %   health_score - 0 (fault) to 100 (perfect)
    %   status - 0=OK (green), 1=WARNING (yellow), 2=FAULT (red)
    %   alarm_details - Struct with individual alarm flags
    %
    % Author: Santino Ventre
    % Date: 2025-12-27

    % Load detection algorithms
    persistent algorithms_loaded;
    if isempty(algorithms_loaded)
        algorithms_loaded = true;
    end

    % Initialize alarm details
    alarm_details = struct();
    alarm_details.threshold = 0;
    alarm_details.drift = 0;
    alarm_details.noise = 0;
    alarm_details.stuck = 0;
    alarm_details.data_loss = 0;
    alarm_details.rate = 0;

    % Get sensor parameters
    switch lower(sensor_type)
        case 'barcode'
            mean_expected = 0.5; % Average between 0 and 1
            std_expected = 0.5;
            drift_threshold = 0.3;
            max_variance = 0.5;
            min_change = 0.1;
            max_rate = 10; % Max 10 changes per second

        case 'weight'
            mean_expected = sensor_params.weight_mean;
            std_expected = sensor_params.weight_std;
            drift_threshold = 8.0; % 5kg drift
            max_variance = sensor_params.weight_std^2*10; % 10x normal variance
            min_change = 0.5; % Must vary by at least 1kg
            max_rate = 100; % Max 50 kg/s change

        case 'position'
            mean_expected = 0.5;
            std_expected = 0.5;
            drift_threshold = 0.3;
            max_variance = 0.5;
            min_change = 0.1;
            max_rate = 10;

        case 'speed'
            mean_expected = sensor_params.belt_speed_nominal;
            std_expected = sensor_params.speed_noise_std;
            drift_threshold = 0.5; % 0.5 m/s drift
            max_variance = sensor_params.speed_noise_std^2 * 100; % 100x normal
            min_change = 0.01; % Must vary by at least 0.01 m/s
            max_rate = 5; % Max 5 m/s^2 acceleration

        case 'distance'
            mean_expected = sensor_params.belt_length / 2;
            std_expected = sensor_params.belt_length / 4;
            drift_threshold = 2.0; % 2 meters
            max_variance = 25;
            min_change = 0.1;
            max_rate = 10; % Max 10 m/s

        otherwise
            % Default parameters
            mean_expected = 0;
            std_expected = 1;
            drift_threshold = 3;
            max_variance = 2;
            min_change = 0.1;
            max_rate = 100;
    end
    
    % Run all detection algorithms
    alarm_details.threshold = threshold_detector(signal, mean_expected, std_expected, 3.0);
    alarm_details.drift = drift_detector(signal, 500, drift_threshold); % 5s window
    alarm_details.noise = variance_monitor(signal, 500, max_variance);
    alarm_details.stuck = stuck_detector(signal, 1000, min_change); % 10s window
    alarm_details.data_loss = data_loss_detector(signal, 5.0, sample_time); % 5s timeout
    alarm_details.rate = rate_of_change_detector(signal, max_rate, sample_time);

    % Calculate Total Alarms
    total_alarms = alarm_details.threshold + alarm_details.drift + ...
                   alarm_details.noise + alarm_details.stuck + ...
                   alarm_details.data_loss + alarm_details.rate;

    % Calculate Health score (each alarm reduces score by 17 points)
    health_score = max(0, 100 - (total_alarms*17));
            
    % Determine status
    if health_score >= 90
        status = 0; % OK (green)
    elseif health_score >= 70
        status = 1; % Warning (yellow)
    else
        status = 2; % FAULT (red)
    end
end