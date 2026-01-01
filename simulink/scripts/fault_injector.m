function faulty_signal = fault_injector(healthy_signal, fault_type, fault_start_time, current_time, fault_param1, fault_param2)
% FAULT_INJECTOR - Inject controlled faults in sensor signals
%
% Inputs:
%   healthy_signal - signal healthy sensor [double]
%   fault_type - [0=none, 1=drift, 2=noise, 3=stuck, 4=intermittent]
%   fault_start_time - [seconds]
%   current_time - [seconds]
%   fault_param1 - 1st specific parameter for fault type
%   fault_param2 - 2nd specific parameter for fault type
%
% Output:
%   faulty_signal - signal with applicated fault
%
% Parameters for type:
%   Drift(1):           param1=drift_rate [unit/s], param2=unused
%   Noise(2):           param1=noise_multiplier [dimensionless], param2=unused
%   Stuck(3):           param1=unused, param2=unused
%   Intermittent(4):    param1=dropout_probability [0-1], param2=unused
%

% Persistent variables
persistent stuck_value last_valid_value;

% initialize
if isempty(stuck_value)
    stuck_value = 0;
end
if isempty(last_valid_value)
    last_valid_value = 0;
end

% until fault_start_time faulty_signal is equal to healthy_signal
faulty_signal = healthy_signal;

% check time for applying fault
if current_time < fault_start_time
    faulty_signal = healthy_signal;
    stuck_value = healthy_signal; % Save for stuck fault
    last_valid_value = healthy_signal; % Save for intermittent
    return;
end

% Set Fault
switch fault_type
    case 0 % NO FAULT
        faulty_signal = healthy_signal;

    case 1 % DRIFT
        % Linear Drift from Fault time
        drift_rate = fault_param1; % Ex.: 0.1 kg/s
        time_since_fault = current_time - fault_start_time;
        drift_amount = drift_rate * time_since_fault;

        faulty_signal = healthy_signal + drift_amount;

    case 2 % EXCESSIVE NOISE (multiplied noise)
        % Increase noise of a param
        noise_multiplier = fault_param1; % Ex.: 10x

        noise_std = abs(healthy_signal) * 0.1 * noise_multiplier;
        noise = randn() * noise_std;
        faulty_signal = healthy_signal + noise;

    case 3 % STUCK VALUE (Blocked over last value)
        faulty_signal = stuck_value;

    case 4 % INTERMITTENT (Dropout random)
        dropout_prob = fault_param1; % Ex.: 0.3 = 30% loss

        if rand() < dropout_prob
            % Lost signal
            faulty_signal = last_valid_value; % Or NaN
        else
            % OK Signal
            faulty_signal = healthy_signal;
            last_valid_value = healthy_signal;
        end

    otherwise
        % Unrecognized Signal -> healthy signal output
        faulty_signal = healthy_signal;
        warning('Fault type %d not recognized, passing healthy signal.', fault_type);
end

% NAN & Inf 
if isnan(faulty_signal) || isinf(faulty_signal)
    faulty_signal = last_valid_value;
end
end





