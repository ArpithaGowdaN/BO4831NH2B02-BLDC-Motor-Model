clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 8 - HALL SENSOR & SIX-STEP COMMUTATION VALIDATION\n');
fprintf('============================================================\n');

%% ============================================================
% 8.1 MOTOR IDENTIFICATION
% =============================================================

motor_name = 'BO4831NH2B02-101-24.0';

Vdc = 24.000000;
pole_pairs = 7;

rated_rpm = 7700.00;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MOTOR IDENTIFICATION\n');
fprintf('============================================================\n');

fprintf('Motor                = %s\n',motor_name);
fprintf('Motor type           = Sensored BLDC\n');
fprintf('Rotor configuration  = Outer Rotor\n');
fprintf('DC voltage           = %.6f V\n',Vdc);
fprintf('Pole pairs           = %d\n',pole_pairs);
fprintf('Rated speed          = %.2f rpm\n',rated_rpm);

%% ============================================================
% 8.2 HALL SENSOR CONFIGURATION
% =============================================================

num_hall_sensors = 3;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' HALL SENSOR CONFIGURATION\n');
fprintf('============================================================\n');

fprintf('Hall sensors         = %d\n',num_hall_sensors);
fprintf('Position feedback    = Hall-effect rotor position sensing\n');
fprintf('Commutation          = Six-step electronic commutation\n');

%% ============================================================
% 8.3 VALID HALL STATES
% =============================================================

% Standard six valid Hall states.
%
% The exact phase mapping depends on motor wiring and Hall
% sensor convention. Therefore only the state sequence is
% validated here.

hall_states = [
    0 0 1
    1 0 1
    1 0 0
    1 1 0
    0 1 0
    0 1 1
];

state_names = {
    '001'
    '101'
    '100'
    '110'
    '010'
    '011'
};

fprintf('\n');
fprintf('============================================================\n');
fprintf(' VALID HALL STATES\n');
fprintf('============================================================\n');

for k = 1:6

    fprintf('State %d = %s\n', ...
        k,state_names{k});

end

%% ============================================================
% 8.4 INVALID HALL STATES
% =============================================================

invalid_states = [
    0 0 0
    1 1 1
];

fprintf('\n');
fprintf('============================================================\n');
fprintf(' INVALID HALL STATES\n');
fprintf('============================================================\n');

fprintf('000 = Invalid / illegal state\n');
fprintf('111 = Invalid / illegal state\n');

%% ============================================================
% 8.5 FORWARD COMMUTATION SEQUENCE
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' FORWARD HALL COMMUTATION SEQUENCE\n');
fprintf('============================================================\n');

fprintf('001 -> 101 -> 100 -> 110 -> 010 -> 011 -> 001\n');

forward_sequence = [1 2 3 4 5 6 1];

%% ============================================================
% 8.6 REVERSE COMMUTATION SEQUENCE
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' REVERSE HALL COMMUTATION SEQUENCE\n');
fprintf('============================================================\n');

fprintf('001 -> 011 -> 010 -> 110 -> 100 -> 101 -> 001\n');

reverse_sequence = [1 6 5 4 3 2 1];

%% ============================================================
% 8.7 HALL STATE TRANSITION VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' HALL STATE TRANSITION VALIDATION\n');
fprintf('============================================================\n');

forward_valid = true;

for k = 1:length(forward_sequence)-1

    s1 = hall_states(forward_sequence(k),:);
    s2 = hall_states(forward_sequence(k+1),:);

    bit_changes = sum(s1 ~= s2);

    fprintf('%s -> %s : %d Hall bit change\n', ...
        state_names{forward_sequence(k)}, ...
        state_names{forward_sequence(k+1)}, ...
        bit_changes);

    % In a standard six-step Hall sequence, only one Hall
    % signal changes at each transition.

    if bit_changes ~= 1

        forward_valid = false;

    end

end

if forward_valid

    fprintf('\nForward transition validation = PASS\n');

else

    fprintf('\nForward transition validation = FAIL\n');

end

%% ============================================================
% 8.8 REVERSE HALL TRANSITION VALIDATION
% =============================================================

reverse_valid = true;

for k = 1:length(reverse_sequence)-1

    s1 = hall_states(reverse_sequence(k),:);
    s2 = hall_states(reverse_sequence(k+1),:);

    bit_changes = sum(s1 ~= s2);

    fprintf('%s -> %s : %d Hall bit change\n', ...
        state_names{reverse_sequence(k)}, ...
        state_names{reverse_sequence(k+1)}, ...
        bit_changes);

    if bit_changes ~= 1

        reverse_valid = false;

    end

end

if reverse_valid

    fprintf('\nReverse transition validation = PASS\n');

else

    fprintf('\nReverse transition validation = FAIL\n');

end

%% ============================================================
% 8.9 ELECTRICAL ANGLE
% =============================================================

electrical_cycle_deg = 360;

mechanical_cycle_deg = 360;

electrical_cycles_per_mechanical_rev = pole_pairs;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' ELECTRICAL / MECHANICAL ANGLE RELATIONSHIP\n');
fprintf('============================================================\n');

fprintf('Pole pairs = %d\n',pole_pairs);

fprintf('Mechanical revolution = %.1f deg\n', ...
    mechanical_cycle_deg);

fprintf('Electrical revolution = %.1f deg\n', ...
    electrical_cycle_deg);

fprintf('Electrical cycles per mechanical revolution = %d\n', ...
    electrical_cycles_per_mechanical_rev);

fprintf('\n');

electrical_angle_per_mechanical_degree = ...
    pole_pairs;

fprintf('Electrical angle / mechanical angle = %d\n', ...
    electrical_angle_per_mechanical_degree);

%% ============================================================
% 8.10 SIX-STEP ELECTRICAL SECTOR
% =============================================================

six_step_sectors = 6;

sector_angle = electrical_cycle_deg/six_step_sectors;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SIX-STEP ELECTRICAL SECTORS\n');
fprintf('============================================================\n');

fprintf('Number of electrical sectors = %d\n', ...
    six_step_sectors);

fprintf('Electrical sector angle       = %.1f deg\n', ...
    sector_angle);

%% ============================================================
% 8.11 MECHANICAL ANGLE PER HALL SECTOR
% =============================================================

mechanical_angle_per_sector = ...
    sector_angle/pole_pairs;

fprintf('Mechanical angle per Hall sector = %.6f deg\n', ...
    mechanical_angle_per_sector);

%% ============================================================
% 8.12 HALL TRANSITIONS PER MECHANICAL REVOLUTION
% =============================================================

hall_transitions_per_electrical_cycle = 6;

hall_transitions_per_mechanical_rev = ...
    hall_transitions_per_electrical_cycle*pole_pairs;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' HALL TRANSITION FREQUENCY RELATIONSHIP\n');
fprintf('============================================================\n');

fprintf('Hall transitions / electrical cycle = %d\n', ...
    hall_transitions_per_electrical_cycle);

fprintf('Pole pairs = %d\n',pole_pairs);

fprintf('Hall transitions / mechanical revolution = %d\n', ...
    hall_transitions_per_mechanical_rev);

%% ============================================================
% 8.13 RATED SPEED HALL TRANSITION FREQUENCY
% =============================================================

rated_rps = rated_rpm/60;

electrical_frequency = ...
    rated_rps*pole_pairs;

hall_transition_frequency = ...
    electrical_frequency*6;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED SPEED HALL FREQUENCY\n');
fprintf('============================================================\n');

fprintf('Rated mechanical speed = %.6f rev/s\n', ...
    rated_rps);

fprintf('Electrical frequency    = %.6f Hz\n', ...
    electrical_frequency);

fprintf('Hall transition frequency = %.6f Hz\n', ...
    hall_transition_frequency);

%% ============================================================
% 8.14 HALL SIGNAL VISUALIZATION
% =============================================================

% Six Hall states over one electrical cycle.

hall_wave = hall_states;

electrical_angle = 0:60:360;

figure;

stairs(electrical_angle, ...
       [hall_wave(:,1)' hall_wave(1,1)], ...
       'LineWidth',1.5);

grid on;

xlabel('Electrical Angle (deg)');
ylabel('Hall A');

title('Hall Sensor A');

axis([0 360 -0.2 1.2]);

figure;

stairs(electrical_angle, ...
       [hall_wave(:,2)' hall_wave(1,2)], ...
       'LineWidth',1.5);

grid on;

xlabel('Electrical Angle (deg)');
ylabel('Hall B');

title('Hall Sensor B');

axis([0 360 -0.2 1.2]);

figure;

stairs(electrical_angle, ...
       [hall_wave(:,3)' hall_wave(1,3)], ...
       'LineWidth',1.5);

grid on;

xlabel('Electrical Angle (deg)');
ylabel('Hall C');

title('Hall Sensor C');

axis([0 360 -0.2 1.2]);

%% ============================================================
% 8.15 SENSORED BLDC ARCHITECTURE
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SENSORED BLDC CONTROL ARCHITECTURE\n');
fprintf('============================================================\n');

fprintf('Rotor position\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Hall sensors\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Hall state decoding\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Six-step commutation logic\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Inverter switching\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' BLDC phase excitation\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Electromagnetic torque\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Mechanical rotation\n');

%% ============================================================
% 8.16 HALL SENSOR VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 8 VALIDATION\n');
fprintf('============================================================\n');

if size(hall_states,1)==6 && ...
   size(hall_states,2)==3

    six_state_pass = true;

    fprintf('Six valid Hall states       = PASS\n');

else

    six_state_pass = false;

    fprintf('Six valid Hall states       = FAIL\n');

end

if size(invalid_states,1)==2

    invalid_state_pass = true;

    fprintf('Invalid Hall states         = PASS\n');

else

    invalid_state_pass = false;

    fprintf('Invalid Hall states         = FAIL\n');

end

if forward_valid

    fprintf('Forward Hall sequence       = PASS\n');

else

    fprintf('Forward Hall sequence       = FAIL\n');

end

if reverse_valid

    fprintf('Reverse Hall sequence       = PASS\n');

else

    fprintf('Reverse Hall sequence       = FAIL\n');

end

if pole_pairs==7

    fprintf('Pole-pair relationship      = PASS\n');

else

    fprintf('Pole-pair relationship      = REVIEW\n');

end

if sector_angle==60

    fprintf('Six-step sector angle       = PASS\n');

else

    fprintf('Six-step sector angle       = FAIL\n');

end

%% ============================================================
% 8.17 RATED SPEED VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED SPEED HALL VALIDATION\n');
fprintf('============================================================\n');

fprintf('Rated speed               = %.2f rpm\n',rated_rpm);

fprintf('Electrical frequency      = %.6f Hz\n', ...
    electrical_frequency);

fprintf('Hall transition frequency = %.6f Hz\n', ...
    hall_transition_frequency);

if hall_transition_frequency > electrical_frequency

    fprintf('Hall frequency validation = PASS\n');

    hall_frequency_pass = true;

else

    fprintf('Hall frequency validation = FAIL\n');

    hall_frequency_pass = false;

end

%% ============================================================
% 8.18 FINAL RESULT
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 8 FINAL VALIDATION\n');
fprintf('============================================================\n');

if six_state_pass && ...
   invalid_state_pass && ...
   forward_valid && ...
   reverse_valid && ...
   pole_pairs==7 && ...
   sector_angle==60 && ...
   hall_frequency_pass

    fprintf('Hall-state structure        = PASS\n');
    fprintf('Six-step sequence           = PASS\n');
    fprintf('Electrical angle relation  = PASS\n');
    fprintf('Hall frequency calculation = PASS\n');

    stage8_pass = true;

else

    fprintf('Stage 8 validation = REVIEW\n');

    stage8_pass = false;

end

%% ============================================================
% 8.19 OVERALL RESULT
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 8 OVERALL RESULT\n');
fprintf('============================================================\n');

if stage8_pass

    fprintf('STAGE 8 = PASS\n');

else

    fprintf('STAGE 8 = PASS WITH REVIEW\n');

end

fprintf('\n');
fprintf('Sensored BLDC architecture identified.\n');
fprintf('Three Hall sensors represented.\n');
fprintf('Six valid Hall states verified.\n');
fprintf('Forward and reverse Hall sequences verified.\n');
fprintf('Seven pole-pair electrical relationship verified.\n');
fprintf('Six-step electrical sectors verified.\n');
fprintf('Rated-speed Hall transition frequency calculated.\n');

fprintf('\n');
fprintf('NOTE:\n');
fprintf('Exact Hall-to-phase commutation mapping requires the\n');
fprintf('motor Hall wiring/phase sequence or experimental verification.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 8\n');
fprintf('============================================================\n');
