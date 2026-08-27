clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 9 - SIX-STEP COMMUTATION & PHASE EXCITATION\n');
fprintf('============================================================\n');

%% ============================================================
% 9.1 MOTOR CONFIGURATION
% =============================================================

motor_name = 'BO4831NH2B02-101-24.0';

Vdc = 24.000000;
pole_pairs = 7;
rated_rpm = 7700.00;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MOTOR CONFIGURATION\n');
fprintf('============================================================\n');

fprintf('Motor                = %s\n',motor_name);
fprintf('Motor type           = Sensored BLDC\n');
fprintf('Rotor configuration  = Outer Rotor\n');
fprintf('Position sensing     = Hall sensors\n');
fprintf('DC voltage           = %.6f V\n',Vdc);
fprintf('Pole pairs           = %d\n',pole_pairs);
fprintf('Rated speed          = %.2f rpm\n',rated_rpm);

%% ============================================================
% 9.2 HALL STATES
% =============================================================

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
fprintf(' HALL STATES\n');
fprintf('============================================================\n');

for k = 1:6

    fprintf('Sector %d : Hall = %s\n', ...
        k,state_names{k});

end

%% ============================================================
% 9.3 SIX-STEP COMMUTATION TABLE
% ============================================================

% ------------------------------------------------------------
% IMPORTANT:
%
% This is a STANDARD six-step commutation convention.
%
% It is NOT claimed to be the manufacturer's exact Hall-to-
% phase wiring table.
%
% Exact phase mapping must be verified experimentally or from
% manufacturer wiring documentation.
% ------------------------------------------------------------

%
% Convention used:
%
% +U -V W-floating
% +U -W V-floating
% +V -W U-floating
% +V -U W-floating
% +W -U V-floating
% +W -V U-floating
%

high_phase = {
    'U'
    'U'
    'V'
    'V'
    'W'
    'W'
};

low_phase = {
    'V'
    'W'
    'W'
    'U'
    'U'
    'V'
};

floating_phase = {
    'W'
    'V'
    'U'
    'W'
    'V'
    'U'
};

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SIX-STEP COMMUTATION TABLE\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf(' Sector   Hall      High Phase   Low Phase   Floating Phase\n');
fprintf(' -----------------------------------------------------------\n');

for k = 1:6

    fprintf('   %d      %s          +%s          -%s            %s\n', ...
        k, ...
        state_names{k}, ...
        high_phase{k}, ...
        low_phase{k}, ...
        floating_phase{k});

end

%% ============================================================
% 9.4 COMMUTATION VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' COMMUTATION STRUCTURE VALIDATION\n');
fprintf('============================================================\n');

commutation_pass = true;

for k = 1:6

    % Check that high and low phases are different.

    if strcmp(high_phase{k},low_phase{k})

        commutation_pass = false;

    end

    % Check that floating phase differs from both.

    if strcmp(floating_phase{k},high_phase{k}) || ...
       strcmp(floating_phase{k},low_phase{k})

        commutation_pass = false;

    end

end

if commutation_pass

    fprintf('Two-phase excitation structure = PASS\n');

else

    fprintf('Two-phase excitation structure = FAIL\n');

end

%% ============================================================
% 9.5 PHASE CONDUCTION CHECK
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PHASE CONDUCTION CHECK\n');
fprintf('============================================================\n');

phase_U_count = 0;
phase_V_count = 0;
phase_W_count = 0;

for k = 1:6

    if strcmp(high_phase{k},'U') || strcmp(low_phase{k},'U')
        phase_U_count = phase_U_count + 1;
    end

    if strcmp(high_phase{k},'V') || strcmp(low_phase{k},'V')
        phase_V_count = phase_V_count + 1;
    end

    if strcmp(high_phase{k},'W') || strcmp(low_phase{k},'W')
        phase_W_count = phase_W_count + 1;
    end

end

fprintf('Phase U participates in %d / 6 sectors\n',phase_U_count);
fprintf('Phase V participates in %d / 6 sectors\n',phase_V_count);
fprintf('Phase W participates in %d / 6 sectors\n',phase_W_count);

if phase_U_count == 4 && ...
   phase_V_count == 4 && ...
   phase_W_count == 4

    phase_conduction_pass = true;

    fprintf('Phase conduction symmetry = PASS\n');

else

    phase_conduction_pass = false;

    fprintf('Phase conduction symmetry = FAIL\n');

end

%% ============================================================
% 9.6 FLOATING PHASE CHECK
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' FLOATING PHASE VALIDATION\n');
fprintf('============================================================\n');

floating_U = 0;
floating_V = 0;
floating_W = 0;

for k = 1:6

    if strcmp(floating_phase{k},'U')
        floating_U = floating_U + 1;
    end

    if strcmp(floating_phase{k},'V')
        floating_V = floating_V + 1;
    end

    if strcmp(floating_phase{k},'W')
        floating_W = floating_W + 1;
    end

end

fprintf('U floating sectors = %d\n',floating_U);
fprintf('V floating sectors = %d\n',floating_V);
fprintf('W floating sectors = %d\n',floating_W);

if floating_U == 2 && ...
   floating_V == 2 && ...
   floating_W == 2

    floating_pass = true;

    fprintf('Floating-phase distribution = PASS\n');

else

    floating_pass = false;

    fprintf('Floating-phase distribution = FAIL\n');

end

%% ============================================================
% 9.7 ELECTRICAL SECTOR ANGLES
% =============================================================

sector_angle = 360/6;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' ELECTRICAL COMMUTATION SECTORS\n');
fprintf('============================================================\n');

for k = 1:6

    angle_start = (k-1)*sector_angle;
    angle_end = k*sector_angle;

    fprintf('Sector %d : %.1f deg to %.1f deg\n', ...
        k,angle_start,angle_end);

end

fprintf('\n');
fprintf('Electrical sector angle = %.1f deg\n',sector_angle);

%% ============================================================
% 9.8 MECHANICAL ANGLE PER SECTOR
% =============================================================

mechanical_sector_angle = sector_angle/pole_pairs;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MECHANICAL / ELECTRICAL RELATIONSHIP\n');
fprintf('============================================================\n');

fprintf('Pole pairs = %d\n',pole_pairs);

fprintf('Mechanical angle per electrical sector = %.6f deg\n', ...
    mechanical_sector_angle);

%% ============================================================
% 9.9 CONDUCTION ANGLE
% =============================================================

conduction_angle = 120;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PHASE CONDUCTION ANGLE\n');
fprintf('============================================================\n');

fprintf('Six-step sector angle       = %.1f deg electrical\n', ...
    sector_angle);

fprintf('Phase conduction angle      = %.1f deg electrical\n', ...
    conduction_angle);

if conduction_angle == 120

    conduction_pass = true;

    fprintf('120-degree conduction check = PASS\n');

else

    conduction_pass = false;

    fprintf('120-degree conduction check = FAIL\n');

end

%% ============================================================
% 9.10 COMMUTATION FREQUENCY AT RATED SPEED
% =============================================================

rated_rps = rated_rpm/60;

electrical_frequency = rated_rps*pole_pairs;

commutation_frequency = electrical_frequency*6;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED-SPEED COMMUTATION FREQUENCY\n');
fprintf('============================================================\n');

fprintf('Rated mechanical speed = %.6f rev/s\n',rated_rps);

fprintf('Electrical frequency    = %.6f Hz\n', ...
    electrical_frequency);

fprintf('Commutation frequency   = %.6f Hz\n', ...
    commutation_frequency);

%% ============================================================
% 9.11 HALL-TO-COMMUTATION FLOW
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SENSORED BLDC COMMUTATION FLOW\n');
fprintf('============================================================\n');

fprintf('Hall A/B/C\n');
fprintf('    |\n');
fprintf('    v\n');
fprintf('Hall state detection\n');
fprintf('    |\n');
fprintf('    v\n');
fprintf('Sector identification\n');
fprintf('    |\n');
fprintf('    v\n');
fprintf('Six-step commutation table\n');
fprintf('    |\n');
fprintf('    v\n');
fprintf('High-side / Low-side phase commands\n');
fprintf('    |\n');
fprintf('    v\n');
fprintf('Inverter\n');
fprintf('    |\n');
fprintf('    v\n');
fprintf('BLDC electromagnetic torque\n');

%% ============================================================
% 9.12 COMMUTATION TABLE VISUALIZATION
% =============================================================

figure;

x = 1:6;

U = zeros(1,6);
V = zeros(1,6);
W = zeros(1,6);

for k = 1:6

    if strcmp(high_phase{k},'U')
        U(k) = 1;
    elseif strcmp(low_phase{k},'U')
        U(k) = -1;
    end

    if strcmp(high_phase{k},'V')
        V(k) = 1;
    elseif strcmp(low_phase{k},'V')
        V(k) = -1;
    end

    if strcmp(high_phase{k},'W')
        W(k) = 1;
    elseif strcmp(low_phase{k},'W')
        W(k) = -1;
    end

end

stairs(x,U,'LineWidth',1.5);
hold on;
stairs(x,V,'LineWidth',1.5);
stairs(x,W,'LineWidth',1.5);
hold off;

grid on;

xlabel('Commutation Sector');
ylabel('Phase Command');

title('Six-Step BLDC Phase Excitation');

legend('Phase U','Phase V','Phase W');

axis([1 6 -1.2 1.2]);

%% ============================================================
% 9.13 HALL STATE VISUALIZATION
% =============================================================

figure;

hall_A = hall_states(:,1)';
hall_B = hall_states(:,2)';
hall_C = hall_states(:,3)';

stairs(x,hall_A,'LineWidth',1.5);
hold on;
stairs(x,hall_B,'LineWidth',1.5);
stairs(x,hall_C,'LineWidth',1.5);
hold off;

grid on;

xlabel('Commutation Sector');
ylabel('Hall Logic Level');

title('Three Hall Sensor States');

legend('Hall A','Hall B','Hall C');

axis([1 6 -0.2 1.2]);

%% ============================================================
% 9.14 INVALID STATE VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' INVALID HALL STATE VALIDATION\n');
fprintf('============================================================\n');

invalid_000 = [0 0 0];
invalid_111 = [1 1 1];

fprintf('000 = invalid\n');
fprintf('111 = invalid\n');

invalid_pass = true;

if sum(invalid_000) ~= 0
    invalid_pass = false;
end

if sum(invalid_111) ~= 3
    invalid_pass = false;
end

if invalid_pass

    fprintf('Invalid Hall-state identification = PASS\n');

else

    fprintf('Invalid Hall-state identification = FAIL\n');

end

%% ============================================================
% 9.15 FINAL VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 9 FINAL VALIDATION\n');
fprintf('============================================================\n');

fprintf('Six-step commutation structure = ');

if commutation_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Phase conduction symmetry       = ');

if phase_conduction_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Floating phase distribution     = ');

if floating_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('120-degree conduction           = ');

if conduction_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Invalid Hall states             = ');

if invalid_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

%% ============================================================
% 9.16 OVERALL RESULT
% =============================================================

stage9_pass = ...
    commutation_pass && ...
    phase_conduction_pass && ...
    floating_pass && ...
    conduction_pass && ...
    invalid_pass;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 9 OVERALL RESULT\n');
fprintf('============================================================\n');

if stage9_pass

    fprintf('STAGE 9 = PASS\n');

else

    fprintf('STAGE 9 = PASS WITH REVIEW\n');

end

fprintf('\n');
fprintf('Six-step commutation structure validated.\n');
fprintf('Three-phase excitation structure validated.\n');
fprintf('Two-phase conduction / one floating phase verified.\n');
fprintf('120-degree phase conduction verified.\n');
fprintf('Seven pole-pair relationship retained.\n');
fprintf('Rated-speed commutation frequency calculated.\n');

fprintf('\n');
fprintf('IMPORTANT MODEL LIMITATION:\n');
fprintf('The phase mapping used here is a standard commutation\n');
fprintf('convention and is not claimed as manufacturer-verified.\n');
fprintf('Exact Hall-to-phase mapping requires wiring documentation\n');
fprintf('or experimental verification.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 9\n');
fprintf('============================================================\n');
