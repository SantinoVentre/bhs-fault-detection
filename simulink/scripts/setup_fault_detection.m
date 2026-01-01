%% Fault Detection System - Setup Script
% Author: Santino Ventre
% Date: 2025-12-27
% Description: Parametri per simulazione sensori BHS con fault injection

clear all; close all; clc;

%% ====================================================================
%  SIMULATION PARAMETERS
%  ====================================================================
sim_time = 120;              % [s] Durata simulazione
sample_time = 0.01;          % [s] Passo temporale

%% ====================================================================
%  SENSOR PARAMETERS (Healthy State)
%  ====================================================================

% Barcode Scanner
barcode_interval = 8;        % [s] Intervallo tra bagagli
barcode_pulse_duration = 0.1;% [s] Durata pulse
barcode_period_samples = barcode_interval / sample_time;  % 800 samples
barcode_width_samples = barcode_pulse_duration / sample_time;  % 10 samples

% Weight Sensor  
weight_mean = 25;            % [kg] Peso medio bagaglio
weight_std = 8;              % [kg] Deviazione standard
weight_noise_std = 0.5;      % [kg] Rumore misura

% Position Sensor
position_active_time = 6.67; % [s] Tempo presenza su nastro
position_width_samples = position_active_time / sample_time;  % 667 samples

% Speed Sensor
belt_speed_nominal = 1.5;    % [m/s] Velocità nominale
speed_noise_std = 0.05;      % [m/s] Rumore velocità

% Distance Sensor
belt_length = 10;            % [m] Lunghezza nastro

%% ====================================================================
%  FAULT INJECTION CONFIGURATION
%  ====================================================================

% FAULT TYPES: 
% 0 = None (no fault)
% 1 = Drift (gradual deviation)
% 2 = Excessive Noise
% 3 = Stuck Value
% 4 = Intermittent (dropout)

% ----------------------
% BARCODE SENSOR FAULT
% ----------------------
barcode_fault_type = 3;           % STUCK VALUE
barcode_fault_start_time = 70;    % [s] Inizia a t=70s
barcode_fault_param1 = 0;         % Unused per stuck
barcode_fault_param2 = 0;

% ----------------------
% WEIGHT SENSOR FAULT
% ----------------------
weight_fault_type = 1;            % DRIFT
weight_fault_start_time = 40;     % [s] Inizia a t=40s
weight_drift_rate = 0.15;         % [kg/s] Deriva 0.15 kg al secondo
weight_fault_param1 = weight_drift_rate;
weight_fault_param2 = 0;

% ----------------------
% POSITION SENSOR FAULT
% ----------------------
position_fault_type = 4;          % INTERMITTENT
position_fault_start_time = 50;   % [s]
position_dropout_prob = 0.4;      % 40% packet loss
position_fault_param1 = position_dropout_prob;
position_fault_param2 = 0;

% ----------------------
% SPEED SENSOR FAULT
% ----------------------
speed_fault_type = 2;             % EXCESSIVE NOISE
speed_fault_start_time = 30;      % [s]
speed_noise_multiplier = 15;      % 15x rumore normale
speed_fault_param1 = speed_noise_multiplier;
speed_fault_param2 = 0;

% ----------------------
% DISTANCE SENSOR FAULT
% ----------------------
distance_fault_type = 0;          % NO FAULT (reference)
distance_fault_start_time = 999;  % Mai
distance_fault_param1 = 0;
distance_fault_param2 = 0;

%% ====================================================================
%  DISPLAY CONFIGURATION
%  ====================================================================
fprintf('========================================\n');
fprintf('  BHS FAULT DETECTION SYSTEM - SETUP   \n');
fprintf('========================================\n');
fprintf('Simulation time: %d seconds\n', sim_time);
fprintf('Sample time: %. 3f seconds\n', sample_time);
fprintf('\n');

fprintf('--- SENSORS CONFIGURED ---\n');
fprintf('  1. Barcode Scanner\n');
fprintf('  2. Weight Sensor\n');
fprintf('  3. Position Sensor\n');
fprintf('  4. Speed Sensor\n');
fprintf('  5. Distance Sensor\n');
fprintf('\n');

fprintf('--- FAULTS CONFIGURED ---\n');
fprintf('Barcode:   Type %d (Stuck) @ t=%. 1fs\n', barcode_fault_type, barcode_fault_start_time);
fprintf('Weight:   Type %d (Drift %. 2f kg/s) @ t=%.1fs\n', weight_fault_type, weight_drift_rate, weight_fault_start_time);
fprintf('Position: Type %d (Intermittent %. 0f%%) @ t=%.1fs\n', position_fault_type, position_dropout_prob*100, position_fault_start_time);
fprintf('Speed:    Type %d (Noise %dx) @ t=%.1fs\n', speed_fault_type, speed_noise_multiplier, speed_fault_start_time);
fprintf('Distance: Type %d (None) - Reference sensor\n', distance_fault_type);
fprintf('========================================\n\n');

%% ====================================================================
%  SAVE WORKSPACE
%  ====================================================================

% Determina path progetto (cartella root)
project_root = fileparts(fileparts(mfilename('fullpath')));  
% mfilename('fullpath') = path di questo script
% fileparts(... ) una volta = simulink/scripts
% fileparts(...) due volte = root progetto

% Path cartella data
data_folder = fullfile(project_root, 'data');

% Crea cartella se non esiste
if ~exist(data_folder, 'dir')
    mkdir(data_folder);
    fprintf('📁 Created data folder: %s\n', data_folder);
end

% Path completo file da salvare
save_file = fullfile(data_folder, 'sensor_params.mat');

% Salva workspace
save(save_file);
fprintf('✅ Setup completed!  Parameters saved.\n');
fprintf('📊 Ready to run simulation.\n\n');