% =========================================================
% BO4831NH2B02-101-24.0
% MOTOR PARAMETERS
% =========================================================
%
% Purpose:
%   Define the locked electrical and mechanical parameters
%   of the selected BLDC motor for the complete project.
%
% Motor:
%   BO4831NH2B02-101-24.0
%
% Application:
%   BLDC Motor Mathematical Modeling and Control
%
% MATLAB Version:
%   MATLAB R2014a
%
% IMPORTANT:
%   These parameters are LOCKED.
%   Do not modify them in later stages.
%
% =========================================================

clear;
clc;

fprintf('\n');
fprintf('============================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' LOCKED MOTOR PARAMETERS\n');
fprintf('============================================\n');

% =========================================================
% ELECTRICAL PARAMETERS
% =========================================================

Vdc = 24.00;              % DC supply voltage [V]

R = 0.080000;             % Phase/terminal resistance [Ohm]

L = 80.0e-6;              % Effective phase inductance [H]

Ke = 0.028018;            % Effective back-EMF constant [V.s/rad]

Kt = 0.025398;            % Effective torque constant [N.m/A]

% =========================================================
% MECHANICAL PARAMETERS
% =========================================================

J = 3.060000e-05;         % Rotor inertia [kg.m^2]

B = 1.903300e-05;         % Viscous friction coefficient
                          % [N.m.s/rad]

% =========================================================
% MOTOR RATED PARAMETERS
% =========================================================

rated_voltage = 24.00;    % Rated voltage [V]

rated_speed_rpm = 7700;   % Rated speed [rpm]

rated_current = 17.60;    % Rated current [A]

rated_torque = 0.447;     % Rated torque [N.m]

% =========================================================
% MOTOR CONFIGURATION
% =========================================================

pole_pairs = 7;           % Number of pole pairs

% =========================================================
% CONVERTED PARAMETERS
% =========================================================

rated_speed_rad = rated_speed_rpm * 2*pi/60;

% =========================================================
% DERIVED RATED-POINT VALUES
% =========================================================

rated_back_emf = Ke * rated_speed_rad;

rated_resistive_drop = R * rated_current;

rated_electromagnetic_torque = Kt * rated_current;

rated_friction_torque = B * rated_speed_rad;

rated_mechanical_power = ...
    rated_torque * rated_speed_rad;

rated_electrical_power = ...
    rated_voltage * rated_current;

% =========================================================
% DISPLAY PARAMETERS
% =========================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' ELECTRICAL PARAMETERS\n');
fprintf('============================================\n');

fprintf('DC voltage              = %.6f V\n', Vdc);
fprintf('Resistance              = %.8f Ohm\n', R);
fprintf('Inductance              = %.6e H\n', L);
fprintf('Effective Ke             = %.8f V.s/rad\n', Ke);
fprintf('Effective Kt             = %.8f N.m/A\n', Kt);

fprintf('\n');
fprintf('============================================\n');
fprintf(' MECHANICAL PARAMETERS\n');
fprintf('============================================\n');

fprintf('Rotor inertia           = %.8e kg.m^2\n', J);
fprintf('Viscous coefficient     = %.8e N.m.s/rad\n', B);

fprintf('\n');
fprintf('============================================\n');
fprintf(' RATED MOTOR PARAMETERS\n');
fprintf('============================================\n');

fprintf('Rated voltage           = %.2f V\n', rated_voltage);
fprintf('Rated speed             = %.2f rpm\n', rated_speed_rpm);
fprintf('Rated current           = %.2f A\n', rated_current);
fprintf('Rated torque            = %.6f N.m\n', rated_torque);
fprintf('Pole pairs              = %d\n', pole_pairs);

fprintf('\n');
fprintf('============================================\n');
fprintf(' DERIVED RATED-POINT VALUES\n');
fprintf('============================================\n');

fprintf('Rated angular speed     = %.6f rad/s\n', ...
    rated_speed_rad);

fprintf('Rated back EMF          = %.6f V\n', ...
    rated_back_emf);

fprintf('Rated IR voltage drop   = %.6f V\n', ...
    rated_resistive_drop);

fprintf('Model EM torque         = %.6f N.m\n', ...
    rated_electromagnetic_torque);

fprintf('Viscous friction torque = %.6f N.m\n', ...
    rated_friction_torque);

fprintf('Rated mechanical power  = %.6f W\n', ...
    rated_mechanical_power);

fprintf('Rated electrical power  = %.6f W\n', ...
    rated_electrical_power);

fprintf('\n');
fprintf('============================================\n');
fprintf(' MOTOR PARAMETER STATUS\n');
fprintf('============================================\n');

fprintf('Motor                    = BO4831NH2B02-101-24.0\n');
fprintf('Parameter set            = LOCKED\n');
fprintf('Status                   = READY FOR MODELING\n');

fprintf('============================================\n');
