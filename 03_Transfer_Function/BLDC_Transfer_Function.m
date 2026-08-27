clc;
clear;
close all;

fprintf('\n');
fprintf('============================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 3 - BLDC TRANSFER FUNCTION\n');
fprintf('============================================\n');


%% ============================================================
% LOCKED MOTOR PARAMETERS
% =============================================================

Vdc = 24.0;

R  = 0.080000;
L  = 80e-6;

Ke = 0.028018;
Kt = 0.025398;

J  = 3.060e-05;
B  = 1.9033e-05;

rated_speed_rpm = 7700.0;
rated_current   = 17.6;
rated_torque    = 0.447;


%% ============================================================
% DISPLAY MOTOR PARAMETERS
% =============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' MOTOR PARAMETERS\n');
fprintf('============================================\n');

fprintf('DC voltage              = %.6f V\n', Vdc);
fprintf('Resistance              = %.8f Ohm\n', R);
fprintf('Inductance              = %.8e H\n', L);
fprintf('Effective Ke            = %.8f V.s/rad\n', Ke);
fprintf('Effective Kt            = %.8f N.m/A\n', Kt);
fprintf('Rotor inertia           = %.8e kg.m^2\n', J);
fprintf('Viscous coefficient     = %.8e N.m.s/rad\n', B);

fprintf('\n');
fprintf('Rated speed             = %.2f rpm\n', rated_speed_rpm);
fprintf('Rated current           = %.2f A\n', rated_current);
fprintf('Rated torque            = %.6f N.m\n', rated_torque);


%% ============================================================
% TRANSFER FUNCTION COEFFICIENTS
%
% Electrical:
%
% V = L(di/dt) + R*i + Ke*omega
%
% Mechanical:
%
% J(domega/dt) = Kt*i - B*omega - TL
%
% For TL = 0:
%
% Omega(s)/V(s) =
%
% Kt
% ---------------------------------------------
% LJ*s^2 + (LB + RJ)*s + (RB + Ke*Kt)
%
% =============================================================

a2 = L * J;

a1 = L * B + R * J;

a0 = R * B + Ke * Kt;

numerator = Kt;

denominator = [a2 a1 a0];


%% ============================================================
% DISPLAY TRANSFER FUNCTION COEFFICIENTS
% =============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' TRANSFER FUNCTION COEFFICIENTS\n');
fprintf('============================================\n');

fprintf('LJ       = %.12e\n', a2);
fprintf('LB + RJ  = %.12e\n', a1);
fprintf('RB + KeKt = %.12e\n', a0);


%% ============================================================
% CREATE TRANSFER FUNCTION
% =============================================================

motor_plant = tf(numerator, denominator);


fprintf('\n');
fprintf('============================================\n');
fprintf(' VOLTAGE TO SPEED TRANSFER FUNCTION\n');
fprintf('============================================\n');

fprintf('\n');
fprintf('G(s) = Kt / [LJ*s^2 + (LB+RJ)*s + (RB+KeKt)]\n');

fprintf('\n');
fprintf('G =\n\n');

disp(motor_plant);


%% ============================================================
% PLANT POLES
% =============================================================

plant_poles = pole(motor_plant);


fprintf('\n');
fprintf('============================================\n');
fprintf(' SYSTEM POLES\n');
fprintf('============================================\n');

for k = 1:length(plant_poles)
    fprintf('Pole %d = %.10f', k, real(plant_poles(k)));

    if imag(plant_poles(k)) >= 0
        fprintf(' + %.10fj\n', imag(plant_poles(k)));
    else
        fprintf(' - %.10fj\n', abs(imag(plant_poles(k))));
    end
end


%% ============================================================
% STABILITY CHECK
% =============================================================

stable = all(real(plant_poles) < 0);


fprintf('\n');
fprintf('============================================\n');
fprintf(' PLANT STABILITY\n');
fprintf('============================================\n');

if stable
    fprintf('Plant stability = STABLE\n');
else
    fprintf('Plant stability = UNSTABLE\n');
end


%% ============================================================
% DC GAIN
% =============================================================

dc_gain = dcgain(motor_plant);


fprintf('\n');
fprintf('============================================\n');
fprintf(' DC GAIN\n');
fprintf('============================================\n');

fprintf('DC gain = %.10f (rad/s)/V\n', dc_gain);


%% ============================================================
% 24 V STEADY-STATE SPEED
% =============================================================

predicted_speed_rad_s = dc_gain * Vdc;

predicted_speed_rpm = ...
    predicted_speed_rad_s * 60 / (2*pi);

speed_error_rpm = predicted_speed_rpm - rated_speed_rpm;

speed_error_percent = ...
    abs(speed_error_rpm) / rated_speed_rpm * 100;


fprintf('\n');
fprintf('============================================\n');
fprintf(' 24 V STEADY-STATE RESULT\n');
fprintf('============================================\n');

fprintf('Applied voltage      = %.4f V\n', Vdc);

fprintf('Predicted speed      = %.6f rad/s\n', ...
        predicted_speed_rad_s);

fprintf('Predicted speed      = %.6f rpm\n', ...
        predicted_speed_rpm);

fprintf('Rated speed           = %.2f rpm\n', ...
        rated_speed_rpm);

fprintf('Speed error           = %.6f %%\n', ...
        speed_error_percent);


%% ============================================================
% RATED BACK-EMF CHECK
% =============================================================

omega_rated = rated_speed_rpm * 2*pi/60;

rated_back_emf = Ke * omega_rated;

rated_ir_drop = R * rated_current;

rated_voltage_required = ...
    rated_back_emf + rated_ir_drop;


fprintf('\n');
fprintf('============================================\n');
fprintf(' RATED-POINT ELECTRICAL CHECK\n');
fprintf('============================================\n');

fprintf('Rated angular speed   = %.6f rad/s\n', ...
        omega_rated);

fprintf('Back EMF              = %.6f V\n', ...
        rated_back_emf);

fprintf('IR voltage drop       = %.6f V\n', ...
        rated_ir_drop);

fprintf('E + IR                = %.6f V\n', ...
        rated_voltage_required);

fprintf('DC bus voltage        = %.6f V\n', ...
        Vdc);


%% ============================================================
% FINAL TRANSFER FUNCTION INFORMATION
% =============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' FINAL TRANSFER FUNCTION RESULT\n');
fprintf('============================================\n');

fprintf('Voltage-to-speed model generated successfully.\n');

fprintf('\n');

fprintf('G(s) = Kt / [LJ*s^2 + (LB+RJ)*s + (RB+KeKt)]\n');

fprintf('\n');

fprintf('Numerator = %.8f\n', numerator);

fprintf('\n');

fprintf('Denominator:\n');
fprintf('[ %.12e   %.12e   %.12e ]\n', ...
        denominator(1), denominator(2), denominator(3));


%% ============================================================
% VALIDATION AGAINST LOCKED VALUES
% =============================================================

expected_a2 = 2.448000000000e-09;
expected_a1 = 2.449522640000e-06;
expected_a0 = 7.131238040000e-04;

coefficient_tolerance = 1e-12;

coefficients_match = ...
    abs(a2 - expected_a2) < coefficient_tolerance && ...
    abs(a1 - expected_a1) < coefficient_tolerance && ...
    abs(a0 - expected_a0) < coefficient_tolerance;


fprintf('\n');
fprintf('============================================\n');
fprintf(' TRANSFER FUNCTION VALIDATION\n');
fprintf('============================================\n');

if coefficients_match
    fprintf('Transfer-function coefficients = PASS\n');
else
    fprintf('Transfer-function coefficients = CHECK\n');
end

fprintf('Plant stability                = ');

if stable
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end


%% ============================================================
% PLOT
% =============================================================

figure;

step(motor_plant);

grid on;

title('BO4831NH2B02-101-24.0 - Voltage to Speed Response');
xlabel('Time (s)');
ylabel('Speed (rad/s)');


%% ============================================================
% COMPLETE
% =============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' STAGE 3 TRANSFER FUNCTION COMPLETE\n');
fprintf('============================================\n');
fprintf('Motor parameters remain LOCKED.\n');
fprintf('Transfer function established.\n');
fprintf('Plant poles calculated.\n');
fprintf('DC gain calculated.\n');
fprintf('24 V steady-state speed evaluated.\n');
fprintf('Validation completed.\n');

fprintf('============================================\n');
