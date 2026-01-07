%% Simulation-Only Test - Integration Tests Only
% Skips algorithm unit tests, focuses on system validation
% Author:   Santino Ventre
% Date:  2025-01-07

clear all; close all; clc;

fprintf('============================================================\n');
fprintf('  SIMULATION TEST - Integration Only                        \n');
fprintf('============================================================\n\n');

%% Initialize
test_results = struct();
test_results.simulation = false;
test_results.logging = false;
test_results.weight_drift = false;
test_results. speed_noise = false;
test_results.barcode_stuck = false;

% Initialize measurement variables
drift = 0;
noise_increase = 0;
signal_range = 0;

%% STEP 1: Simulation
fprintf('STEP 1: Running simulation (120 seconds)...\n');
try
    run('simulink/scripts/setup_fault_detection.m');  % Forward slash! 
    tic;
    simOut = sim('fault_detection_system', 'StopTime', '120');
    sim_time = toc;
    fprintf('   ✅ Simulation completed in %.2f seconds\n', sim_time);
    test_results.simulation = true;
catch ME
    fprintf('   ❌ Simulation FAILED:   %s\n', ME. message);
    simOut = [];
end
fprintf('\n');

%% STEP 2: Extract Data
fprintf('STEP 2: Extracting data.. .\n');

if test_results.simulation && ~isempty(simOut)
    var_names = {'weight_faulty', 'weight_healthy', 'speed_faulty', 'speed_healthy', ... 
                 'barcode_faulty', 'barcode_healthy', 'position_faulty', 'position_healthy', ...
                 'distance_faulty', 'distance_healthy', 'tout'};
    
    extracted = 0;
    for i = 1:length(var_names)
        var_name = var_names{i};
        
        % Handle potential typo in distance_healty
        if strcmp(var_name, 'distance_healthy') && isprop(simOut, 'distance_healty')
            var_name_in_sim = 'distance_healty';
        else
            var_name_in_sim = var_name;
        end
        
        if isprop(simOut, var_name_in_sim)
            try
                data = simOut.(var_name_in_sim);
                assignin('base', var_name, data);
                eval([var_name ' = data;']);
                fprintf('   ✅ %s (%d samples)\n', var_name, length(data));
                extracted = extracted + 1;
            catch
                fprintf('   ⚠️  %s (extraction failed)\n', var_name);
            end
        end
    end
    
    test_results.logging = (extracted >= 3);
    fprintf('   Total extracted: %d/%d variables\n', extracted, length(var_names));
else
    fprintf('   ⚠️  No simulation output available\n');
    test_results.logging = false;
end
fprintf('\n');

%% STEP 3: Analyze Faults
if test_results.logging
    fprintf('STEP 3: Analyzing fault detection...\n\n');
    
    % Weight Drift
    if exist('weight_faulty', 'var') && exist('tout', 'var') && exist('weight_fault_start_time', 'var')
        fprintf('--- Weight Sensor (Drift) ---\n');
        try
            pre_idx = tout < weight_fault_start_time;
            post_idx = tout >= weight_fault_start_time;
            
            pre_data = weight_faulty(pre_idx);
            pre_data = pre_data(pre_data > 0.5);
            post_data = weight_faulty(post_idx);
            post_data = post_data(post_data > 0.5);
            
            if ~isempty(pre_data) && ~isempty(post_data)
                drift = abs(mean(post_data) - mean(pre_data));
                fprintf('   Drift detected: %.2f kg\n', drift);
                test_results. weight_drift = (drift > 3.0);
                if test_results.weight_drift
                    fprintf('   ✅ PASS (drift > 3 kg)\n');
                else
                    fprintf('   ⚠️  WEAK (drift < 3 kg)\n');
                end
            else
                fprintf('   ⚠️  Insufficient data\n');
                drift = 0;
            end
        catch ME
            fprintf('   ⚠️  Error: %s\n', ME.message);
            drift = 0;
        end
        fprintf('\n');
    else
        fprintf('--- Weight Sensor (Drift) ---\n');
        fprintf('   ⚠️  Required variables not found\n\n');
    end
    
    % Speed Noise
    if exist('speed_faulty', 'var') && exist('tout', 'var') && exist('speed_fault_start_time', 'var')
        fprintf('--- Speed Sensor (Noise) ---\n');
        try
            pre_idx = tout < speed_fault_start_time;
            post_idx = tout >= speed_fault_start_time;
            
            noise_increase = std(speed_faulty(post_idx)) / std(speed_faulty(pre_idx));
            fprintf('   Noise increase:  %.1fx\n', noise_increase);
            test_results. speed_noise = (noise_increase > 5.0);
            if test_results.speed_noise
                fprintf('   ✅ PASS (noise > 5x)\n');
            else
                fprintf('   ⚠️  WEAK (noise < 5x)\n');
            end
        catch ME
            fprintf('   ⚠️  Error: %s\n', ME. message);
            noise_increase = 0;
        end
        fprintf('\n');
    else
        fprintf('--- Speed Sensor (Noise) ---\n');
        fprintf('   ⚠️  Required variables not found\n\n');
    end
    
    % Barcode Stuck
    if exist('barcode_faulty', 'var') && exist('tout', 'var') && exist('barcode_fault_start_time', 'var')
        fprintf('--- Barcode Sensor (Stuck) ---\n');
        try
            post_idx = tout >= barcode_fault_start_time;
            signal_range = max(barcode_faulty(post_idx)) - min(barcode_faulty(post_idx));
            fprintf('   Signal range after fault: %.3f\n', signal_range);
            test_results.barcode_stuck = (signal_range < 0.1);
            if test_results.barcode_stuck
                fprintf('   ✅ PASS (stuck detected)\n');
            else
                fprintf('   ⚠️  FAIL (signal varying)\n');
            end
        catch ME
            fprintf('   ⚠️  Error:  %s\n', ME.message);
            signal_range = 1;
        end
        fprintf('\n');
    else
        fprintf('--- Barcode Sensor (Stuck) ---\n');
        fprintf('   ⚠️  Required variables not found\n\n');
    end
else
    fprintf('STEP 3: Skipped (no data available)\n\n');
end

%% Summary
fprintf('============================================================\n');
fprintf('  TEST SUMMARY                                              \n');
fprintf('============================================================\n\n');

fprintf('INTEGRATION TESTS:\n');
fprintf('  Simulation (120s)        %s\n', tf(test_results.simulation));
fprintf('  Data Extraction          %s\n', tf(test_results. logging));
fprintf('  Weight Drift Detection   %s\n', tf(test_results.weight_drift));
fprintf('  Speed Noise Detection    %s\n', tf(test_results.speed_noise));
fprintf('  Barcode Stuck Detection  %s\n', tf(test_results. barcode_stuck));

passed = sum([test_results.simulation, test_results.logging, test_results.weight_drift, ... 
              test_results.speed_noise, test_results.barcode_stuck]);
total = 5;

fprintf('\n============================================================\n');
fprintf('  OVERALL:  %d/%d tests passed (%. 0f%%)\n', passed, total, passed/total*100);
fprintf('============================================================\n\n');

if passed == total
    fprintf('🎉 EXCELLENT!  System fully functional.\n\n');
elseif passed >= 3
    fprintf('✅ GOOD! Core functionality verified.\n\n');
else
    fprintf('⚠️  Issues detected.\n\n');
end

if test_results.logging
    fprintf('RESULTS FOR REPORT:\n');
    fprintf('  Weight drift:   %.2f kg\n', drift);
    fprintf('  Speed noise:    %.1fx increase\n', noise_increase);
    fprintf('  Barcode stuck:  range = %.3f\n', signal_range);
    fprintf('\n');
end

%% Helper Function
function s = tf(val)
    if val
        s = '✅ PASS';
    else
        s = '❌ FAIL';
    end
end