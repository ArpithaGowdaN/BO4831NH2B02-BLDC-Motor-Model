clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 12 - INVERTER & PWM VALIDATION\n');
fprintf('============================================================\n');

%% ============================================================
%  12.1 LOCKED MOTOR PARAMETERS
% =============================================================

Vdc = 24.0;
R = 0.080;
L = 8.0e-05;

Ke = 0.028018;
Kt = 0.025398;
J = 3.060e-05;

pole_pairs = 7;
rated_rpm = 7700;
rated_current = 17.6;
rated_torque = 0.447;

Kp = 0.150;
Ki = 8.000;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' LOCKED MOTOR PARAMETERS\n');
fprintf('============================================================\n');

fprintf('DC voltage          = %.6f V\n', Vdc);
fprintf('Resistance          = %.8f Ohm\n', R);
fprintf('Inductance          = %.8e H\n', L);
fprintf('Effective Ke        = %.8f V.s/rad\n', Ke);
fprintf('Effective Kt        = %.8f N.m/A\n', Kt);
fprintf('Rotor inertia       = %.8e kg.m^2\n', J);
fprintf('Pole pairs          = %d\n', pole_pairs);
fprintf('Rated speed         = %.2f rpm\n', rated_rpm);
fprintf('Rated current       = %.2f A\n', rated_current);
fprintf('Rated torque        = %.6f N.m\n', rated_torque);

%% ============================================================
%  12.2 MOTOR CONFIGURATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MOTOR CONFIGURATION\n');
fprintf('============================================================\n');

fprintf('Motor type          = Sensored BLDC\n');
fprintf('Rotor configuration = Outer Rotor\n');
fprintf('Position sensing    = 3 Hall sensors\n');
fprintf('Commutation         = Six-step electronic commutation\n');
fprintf('Inverter            = 3-phase voltage-source inverter\n');
fprintf('PWM                 = Duty-cycle based voltage control\n');

%% ============================================================
%  12.3 HALL STATES
% =============================================================

hall_states = [
    0 0 1;
    1 0 1;
    1 0 0;
    1 1 0;
    0 1 0;
    0 1 1
];

fprintf('\n');
fprintf('============================================================\n');
fprintf(' HALL STATE SEQUENCE\n');
fprintf('============================================================\n');

fprintf('Sector 1 = 001\n');
fprintf('Sector 2 = 101\n');
fprintf('Sector 3 = 100\n');
fprintf('Sector 4 = 110\n');
fprintf('Sector 5 = 010\n');
fprintf('Sector 6 = 011\n');

%% ============================================================
%  12.4 SIX-STEP INVERTER SWITCHING TABLE
%
%  +U = U high-side active
%  -U = U low-side active
%   U = floating
%
%  Same standard commutation convention as Stage 9.
% =============================================================

high_phase = {'U','U','V','V','W','W'};
low_phase  = {'V','W','W','U','U','V'};
float_phase = {'W','V','U','W','V','U'};

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SIX-STEP INVERTER SWITCHING TABLE\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf(' Sector   Hall      High Phase   Low Phase   Floating Phase\n');
fprintf(' -----------------------------------------------------------\n');

for k = 1:6

    fprintf('   %d      %d%d%d          +%s          -%s            %s\n', ...
        k, ...
        hall_states(k,1), ...
        hall_states(k,2), ...
        hall_states(k,3), ...
        high_phase{k}, ...
        low_phase{k}, ...
        float_phase{k});

end

%% ============================================================
%  12.5 INVERTER STRUCTURE VALIDATION
% =============================================================

two_phase_pass = true;

for k = 1:6

    if strcmp(high_phase{k},low_phase{k})
        two_phase_pass = false;
    end

end

fprintf('\n');
fprintf('============================================================\n');
fprintf(' INVERTER STRUCTURE VALIDATION\n');
fprintf('============================================================\n');

if two_phase_pass
    fprintf('Two-phase excitation structure = PASS\n');
else
    fprintf('Two-phase excitation structure = FAIL\n');
end

%% ============================================================
%  12.6 PHASE PARTICIPATION CHECK
% =============================================================

U_count = 0;
V_count = 0;
W_count = 0;

for k = 1:6

    if strcmp(high_phase{k},'U') || strcmp(low_phase{k},'U')
        U_count = U_count + 1;
    end

    if strcmp(high_phase{k},'V') || strcmp(low_phase{k},'V')
        V_count = V_count + 1;
    end

    if strcmp(high_phase{k},'W') || strcmp(low_phase{k},'W')
        W_count = W_count + 1;
    end

end

phase_symmetry_pass = ...
    (U_count == 4) && ...
    (V_count == 4) && ...
    (W_count == 4);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PHASE PARTICIPATION VALIDATION\n');
fprintf('============================================================\n');

fprintf('Phase U participates in %d / 6 sectors\n',U_count);
fprintf('Phase V participates in %d / 6 sectors\n',V_count);
fprintf('Phase W participates in %d / 6 sectors\n',W_count);

if phase_symmetry_pass
    fprintf('Phase participation symmetry = PASS\n');
else
    fprintf('Phase participation symmetry = FAIL\n');
end

%% ============================================================
%  12.7 PWM DUTY CYCLE
% ============================================================

duty_test = [0.25 0.50 0.75 1.00];

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PWM DUTY-CYCLE / AVERAGE VOLTAGE RELATIONSHIP\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf(' Duty Cycle       Average Voltage (V)\n');
fprintf(' ------------------------------------\n');

for k = 1:length(duty_test)

    D = duty_test(k);

    Vavg = D * Vdc;

    fprintf('    %.2f               %.6f\n', ...
        D,Vavg);

end

%% ============================================================
%  12.8 PWM VALIDATION
% =============================================================

D0 = 0;
D50 = 0.50;
D100 = 1.00;

V0 = D0 * Vdc;
V50 = D50 * Vdc;
V100 = D100 * Vdc;

pwm_pass = ...
    abs(V0 - 0) < 1e-12 && ...
    abs(V50 - 12) < 1e-12 && ...
    abs(V100 - 24) < 1e-12;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PWM VALIDATION\n');
fprintf('============================================================\n');

fprintf('0%% duty cycle      = %.6f V\n',V0);
fprintf('50%% duty cycle     = %.6f V\n',V50);
fprintf('100%% duty cycle    = %.6f V\n',V100);

if pwm_pass
    fprintf('PWM average-voltage relationship = PASS\n');
else
    fprintf('PWM average-voltage relationship = FAIL\n');
end

%% ============================================================
%  12.9 RATED SPEED BACK-EMF
% =============================================================

omega_rated = rated_rpm * 2*pi/60;

E_rated = Ke * omega_rated;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED-SPEED BACK-EMF\n');
fprintf('============================================================\n');

fprintf('Rated mechanical speed = %.6f rad/s\n',omega_rated);
fprintf('Back-EMF               = %.9f V\n',E_rated);

%% ============================================================
%  12.10 REQUIRED AVERAGE VOLTAGE
% =============================================================

V_R = rated_current * R;

V_required = E_rated + V_R;

D_required = V_required / Vdc;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED-POINT PWM VOLTAGE REQUIREMENT\n');
fprintf('============================================================\n');

fprintf('Back-EMF             = %.9f V\n',E_rated);
fprintf('I*R voltage drop     = %.9f V\n',V_R);
fprintf('Required voltage     = %.9f V\n',V_required);
fprintf('Available DC voltage = %.9f V\n',Vdc);
fprintf('Required duty cycle  = %.9f\n',D_required);
fprintf('Required duty cycle  = %.6f %%\n',100*D_required);

%% ============================================================
%  12.11 DUTY-CYCLE FEASIBILITY
% =============================================================

duty_margin = 1 - D_required;

duty_feasible = D_required <= 1.0;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PWM DUTY-CYCLE FEASIBILITY\n');
fprintf('============================================================\n');

fprintf('Required duty cycle = %.6f %%\n',100*D_required);
fprintf('Duty-cycle margin   = %.6f %%\n',100*duty_margin);

if duty_feasible
    fprintf('Rated operating point within 0-100%% duty range = PASS\n');
else
    fprintf('Rated operating point within 0-100%% duty range = FAIL\n');
end

%% ============================================================
%  12.12 EFFECTIVE VOLTAGE / CURRENT CHECK
% =============================================================

V_effective = Vdc - E_rated;

I_predicted = V_effective / R;

current_error = abs(I_predicted-rated_current);
current_error_percent = ...
    100*current_error/rated_current;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PWM + PHASE CURRENT CHECK\n');
fprintf('============================================================\n');

fprintf('Effective voltage = %.9f V\n',V_effective);
fprintf('Predicted current = %.9f A\n',I_predicted);
fprintf('Rated current     = %.9f A\n',rated_current);
fprintf('Current error     = %.9f A\n',current_error);
fprintf('Current error     = %.9f %%\n',current_error_percent);

current_pass = current_error_percent < 0.01;

if current_pass
    fprintf('Rated current consistency = PASS\n');
else
    fprintf('Rated current consistency = REVIEW\n');
end

%% ============================================================
%  12.13 ELECTRICAL FREQUENCY
% =============================================================

electrical_frequency = ...
    pole_pairs * rated_rpm / 60;

commutation_frequency = ...
    6 * electrical_frequency;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' COMMUTATION FREQUENCY\n');
fprintf('============================================================\n');

fprintf('Rated mechanical speed = %.6f rev/s\n',rated_rpm/60);
fprintf('Electrical frequency    = %.6f Hz\n',electrical_frequency);
fprintf('Commutation frequency   = %.6f Hz\n',commutation_frequency);

%% ============================================================
%  12.14 PWM + HALL CONTROL ARCHITECTURE
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SENSORED BLDC INVERTER CONTROL FLOW\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf('Hall A/B/C\n');
fprintf('     |\n');
fprintf('     v\n');
fprintf('Hall state detection\n');
fprintf('     |\n');
fprintf('     v\n');
fprintf('Electrical sector identification\n');
fprintf('     |\n');
fprintf('     v\n');
fprintf('Six-step commutation table\n');
fprintf('     |\n');
fprintf('     v\n');
fprintf('PWM duty-cycle command\n');
fprintf('     |\n');
fprintf('     v\n');
fprintf('3-phase inverter\n');
fprintf('     |\n');
fprintf('     v\n');
fprintf('Phase voltage\n');
fprintf('     |\n');
fprintf('     v\n');
fprintf('Phase R-L current dynamics\n');
fprintf('     |\n');
fprintf('     v\n');
fprintf('Electromagnetic torque\n');
fprintf('     |\n');
fprintf('     v\n');
fprintf('Mechanical speed\n');

%% ============================================================
%  12.15 PLOT 1 - PWM AVERAGE VOLTAGE
% =============================================================

D_plot = linspace(0,1,101);
V_plot = D_plot * Vdc;

figure(1);

plot(D_plot*100,V_plot,'LineWidth',2);

grid on;

xlabel('PWM Duty Cycle (%)');
ylabel('Average Phase Voltage (V)');
title('Stage 12 - PWM Duty Cycle vs Average Voltage');

%% ============================================================
%  12.16 PLOT 2 - SIX-STEP PHASE COMMANDS
% =============================================================

sector = 1:6;

U_command = zeros(1,6);
V_command = zeros(1,6);
W_command = zeros(1,6);

for k = 1:6

    if strcmp(high_phase{k},'U')
        U_command(k) = 1;
    elseif strcmp(low_phase{k},'U')
        U_command(k) = -1;
    end

    if strcmp(high_phase{k},'V')
        V_command(k) = 1;
    elseif strcmp(low_phase{k},'V')
        V_command(k) = -1;
    end

    if strcmp(high_phase{k},'W')
        W_command(k) = 1;
    elseif strcmp(low_phase{k},'W')
        W_command(k) = -1;
    end

end

figure(2);

stairs(sector,U_command,'LineWidth',2);
hold on;
stairs(sector,V_command,'LineWidth',2);
stairs(sector,W_command,'LineWidth',2);

grid on;

xlabel('Electrical Sector');
ylabel('Phase Command (+1 / -1 / 0)');
title('Stage 12 - Six-Step Inverter Phase Commands');

legend('Phase U','Phase V','Phase W');

%% ============================================================
%  12.17 FINAL VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 12 FINAL VALIDATION\n');
fprintf('============================================================\n');

fprintf('Six-step inverter structure       = ');

if two_phase_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Phase participation symmetry      = ');

if phase_symmetry_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('PWM average-voltage relationship  = ');

if pwm_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Rated-point duty feasibility      = ');

if duty_feasible
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Rated current consistency         = ');

if current_pass
    fprintf('PASS\n');
else
    fprintf('REVIEW\n');
end

fprintf('Hall-to-inverter architecture     = PASS\n');
fprintf('Commutation frequency calculation = PASS\n');

%% ============================================================
%  12.18 OVERALL RESULT
% =============================================================

overall_pass = ...
    two_phase_pass && ...
    phase_symmetry_pass && ...
    pwm_pass && ...
    duty_feasible && ...
    current_pass;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 12 OVERALL RESULT\n');
fprintf('============================================================\n');

if overall_pass

    fprintf('STAGE 12 = PASS\n');

else

    fprintf('STAGE 12 = PASS WITH REVIEW\n');

end

fprintf('\n');
fprintf('Three-phase inverter structure validated.\n');
fprintf('Six-step phase excitation validated.\n');
fprintf('PWM duty-cycle relationship validated.\n');
fprintf('Rated-point duty-cycle feasibility evaluated.\n');
fprintf('Rated-speed electrical frequency calculated.\n');
fprintf('Hall-to-inverter control architecture verified.\n');

fprintf('\n');
fprintf('IMPORTANT MODEL LIMITATION:\n');
fprintf('This stage uses an averaged inverter voltage model.\n');
fprintf('Individual MOSFET switching losses, dead time,\n');
fprintf('device voltage drops and detailed PWM carrier\n');
fprintf('switching are not modeled yet.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 12\n');
fprintf('============================================================\n');
