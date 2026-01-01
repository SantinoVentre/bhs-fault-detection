%% Analyze Fault Injection Results
% Verifica quantitativa degli effetti dei guasti

% Estrai dati da workspace (assumendo logging attivo)
% Nota: devi abilitare logging nei Scope o usare To Workspace blocks

fprintf('=== FAULT INJECTION ANALYSIS ===\n\n');

%% Weight Sensor Analysis
fprintf('--- WEIGHT SENSOR (Drift) ---\n');
fprintf('Fault start time: %. 1f s\n', weight_fault_start_time);
fprintf('Drift rate: %.3f kg/s\n', weight_drift_rate);
fprintf('Expected drift at t=120s: %.2f kg\n', weight_drift_rate * (120 - weight_fault_start_time));
% TODO: Calcola drift reale da dati simulazione
fprintf('\n');

%% Speed Sensor Analysis
fprintf('--- SPEED SENSOR (Noise) ---\n');
fprintf('Fault start time: %.1f s\n', speed_fault_start_time);
fprintf('Noise multiplier: %dx\n', speed_noise_multiplier);
fprintf('Expected noise std (before): %.3f m/s\n', speed_noise_std);
fprintf('Expected noise std (after):  %.3f m/s\n', speed_noise_std * speed_noise_multiplier);
% TODO: Calcola std reale
fprintf('\n');

%% Barcode Sensor Analysis
fprintf('--- BARCODE SENSOR (Stuck) ---\n');
fprintf('Fault start time: %.1f s\n', barcode_fault_start_time);
fprintf('Expected pulses before fault: %d\n', floor(barcode_fault_start_time / barcode_interval));
fprintf('Expected pulses after fault: 0 (stuck)\n');
% TODO: Conta pulse reali
fprintf('\n');

%% Position Sensor Analysis
fprintf('--- POSITION SENSOR (Intermittent) ---\n');
fprintf('Fault start time:  %.1f s\n', position_fault_start_time);
fprintf('Dropout probability: %.1f%%\n', position_dropout_prob * 100);
fprintf('Expected packet loss: ~%.0f samples\n', (120 - position_fault_start_time) / sample_time * position_dropout_prob);
% TODO: Conta dropout reali
fprintf('\n');

fprintf('✅ Analysis complete\n');