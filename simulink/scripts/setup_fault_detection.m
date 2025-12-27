%% Fault Detection System - Setup
% Author: santeewavsto
% Date: 2025-12-27
% Description: Parametri per simulazione sensori BHS

clear all; close all; clc;

%% Simulation Parameters
sim_time = 120;              % [s] 
sample_time = 0.01;          % [s]

%% Sensor Parameters
% Barcode
barcode_interval = 8;        % [s]
barcode_pulse_duration = 0.1;% [s]

% Weight  
weight_mean = 25;            % [kg]
weight_std = 8;              % [kg]
weight_noise_std = 0.5;      % [kg]

% Speed
belt_speed_nominal = 1.5;    % [m/s]
speed_noise_std = 0.05;      % [m/s]

% Distance
belt_length = 10;            % [m]

%% Display Info
fprintf('========================================\n');
fprintf('  BHS FAULT DETECTION SYSTEM - SETUP   \n');
fprintf('========================================\n');
fprintf('Simulation time: %d seconds\n', sim_time);
fprintf('Number of sensors: 5\n');
fprintf('  1. Barcode Scanner\n');
fprintf('  2. Weight Sensor\n');
fprintf('  3. Position Sensor\n');
fprintf('  4. Speed Sensor\n');
fprintf('  5. Distance Sensor\n');
fprintf('========================================\n\n');

%% Save Workspace
save('sensor_params.mat');
fprintf('✅ Setup completed!\n');