% =========================================================
% BO4831NH2B02-101-24.0
% STAGE 2 - BLDC MATHEMATICAL MODEL
% =========================================================
%
% Purpose:
%   Establish the electrical and mechanical equations
%   of the selected BLDC motor.
%
% MATLAB Version:
%   MATLAB R2014a
%
% Motor parameters are taken from the locked parameter set.
%
% =========================================================

clear;
clc;

fprintf('\n');
fprintf('============================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 2 - BLDC MATHEMATICAL MODEL\n');
fprintf('============================================\n');

% =========================================================
% LOCKED MOTOR PARAMETERS
% =========================================================

V = 24.00;                  % DC voltage [V]
R = 0.080000;               % Resistance [Ohm]
L = 80.0e-6;                % Inductance [H]

Ke = 0.028018;              % Back-EMF constant [V.s/rad]
Kt = 0.025398;              % Torque constant [N.m/A]

J = 3.060000e-05;           % Rotor inertia [kg.m^2]
B = 1.903300e-05;           % Viscous friction [N.m.s/rad]

rated_speed_rpm = 7700;
rated_current = 17.60;
rated_torque = 0.447;

% =========================================================
% ELECTRICAL MODEL
% =========================================================
%
% V = L(di/dt) + R*i + Ke*omega
%
% Therefore:
%
% di/dt = (V - R*i - Ke*omega)/L
%
% =========================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' ELECTRICAL EQUATION\n');
fprintf('============================================\n');

fprintf('V = L(di/dt) + R*i + Ke*omega\n');

fprintf('\n');
fprintf('di/dt = (V - R*i - Ke*omega)/L\n');

% =========================================================
% ELECTROMAGNETIC TORQUE
% =========================================================
%
% Te = Kt*i
%
% =========================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' ELECTROMAGNETIC TORQUE EQUATION\n');
fprintf('============================================\n');

fprintf('Te = Kt*i\n');

% =========================================================
% MECHANICAL MODEL
% =========================================================
%
% J(domega/dt) = Te - B*omega - TL
%
% Therefore:
%
% domega/dt = (Te - B*omega - TL)/J
%
% =========================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' MECHANICAL EQUATION\n');
fprintf('============================================\n');

fprintf('J(domega/dt) = Te - B*omega - TL\n');

fprintf('\n');
fprintf('domega/dt = (Te - B*omega - TL)/J\n');

% =========================================================
% RATED SPEED CONVERSION
% =========================================================

rated_speed_rad = rated_speed_rpm * 2*pi/60;

% =========================================================
% BACK EMF AT RATED SPEED
% =========================================================

rated_back_emf = Ke * rated_speed_rad;

% =========================================================
% TORQUE AT RATED CURRENT
% =========================================================

rated_em_torque = Kt * rated_current;

% =========================================================
% VISCOUS FRICTION TORQUE
% =========================================================

rated_friction_torque = B * rated_speed_rad;

% =========================================================
% SHAFT TORQUE
% =========================================================

rated_shaft_torque = ...
    rated_em_torque - rated_friction_torque;

% =========================================================
% DISPLAY RESULTS
% =========================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' RATED-POINT CALCULATIONS\n');
fprintf('============================================\n');

fprintf('Rated speed             = %.6f rpm\n', ...
    rated_speed_rpm);

fprintf('Rated angular speed     = %.6f rad/s\n', ...
    rated_speed_rad);

fprintf('Rated current            = %.6f A\n', ...
    rated_current);

fprintf('Back EMF                = %.6f V\n', ...
    rated_back_emf);

fprintf('Electromagnetic torque  = %.6f N.m\n', ...
    rated_em_torque);

fprintf('Viscous friction torque = %.6f N.m\n', ...
    rated_friction_torque);

fprintf('Model shaft torque      = %.6f N.m\n', ...
    rated_shaft_torque);

% =========================================================
% ELECTRICAL POWER
% =========================================================

electrical_power = V * rated_current;

% =========================================================
% MANUFACTURER MECHANICAL POWER
% =========================================================

manufacturer_mechanical_power = ...
    rated_torque * rated_speed_rad;

% =========================================================
% MODEL SHAFT POWER
% =========================================================

model_shaft_power = ...
    rated_shaft_torque * rated_speed_rad;

fprintf('\n');
fprintf('============================================\n');
fprintf(' POWER CALCULATIONS\n');
fprintf('============================================\n');

fprintf('Electrical input power      = %.6f W\n', ...
    electrical_power);

fprintf('Manufacturer mechanical\n');
fprintf('power reference              = %.6f W\n', ...
    manufacturer_mechanical_power);

fprintf('Model shaft mechanical\n');
fprintf('power after friction         = %.6f W\n', ...
    model_shaft_power);

% =========================================================
% FINAL MODEL SUMMARY
% =========================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' MATHEMATICAL MODEL SUMMARY\n');
fprintf('============================================\n');

fprintf('\n');
fprintf('Electrical model:\n');
fprintf('V = L(di/dt) + R*i + Ke*omega\n');

fprintf('\n');
fprintf('Torque model:\n');
fprintf('Te = Kt*i\n');

fprintf('\n');
fprintf('Mechanical model:\n');
fprintf('J(domega/dt) = Te - B*omega - TL\n');

fprintf('\n');
fprintf('State equations:\n');

fprintf('di/dt = (V - R*i - Ke*omega)/L\n');

fprintf('domega/dt = (Kt*i - B*omega - TL)/J\n');

fprintf('\n');
fprintf('============================================\n');
fprintf(' STAGE 2 STATUS\n');
fprintf('============================================\n');

fprintf('Electrical model        = ESTABLISHED\n');
fprintf('Torque model            = ESTABLISHED\n');
fprintf('Mechanical model        = ESTABLISHED\n');
fprintf('State equations         = ESTABLISHED\n');
fprintf('Motor parameters        = LOCKED\n');

fprintf('\n');
fprintf('STAGE 2 MATHEMATICAL MODEL COMPLETE.\n');

fprintf('============================================\n');
