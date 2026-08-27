clc;
clear;
close all;

fprintf('\n');
fprintf('============================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 4 - PI CONTROLLER & CLOSED LOOP\n');
fprintf('============================================\n');


%% ============================================================
% LOCKED MOTOR PARAMETERS FROM STAGE 3
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
% LOCKED PI CONTROLLER GAINS
% =============================================================

Kp = 0.15;
Ki = 8;


%% ============================================================
% STAGE 3 TRANSFER FUNCTION
%
% G(s) = Kt /
% [LJ*s^2 + (LB+RJ)*s + (RB+Ke*Kt)]
%
% =============================================================

a2 = L * J;
a1 = L * B + R * J;
a0 = R * B + Ke * Kt;

motor_plant = tf(Kt, [a2 a1 a0]);


%% ============================================================
% DISPLAY MOTOR PARAMETERS
% =============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' MOTOR PARAMETERS\n');
fprintf('============================================\n');

fprintf('DC voltage          = %.6f V\n', Vdc);
fprintf('Resistance          = %.8f Ohm\n', R);
fprintf('Inductance          = %.8e H\n', L);
fprintf('Effective Ke        = %.8f V.s/rad\n', Ke);
fprintf('Effective Kt        = %.8f N.m/A\n', Kt);
fprintf('Rotor inertia       = %.8e kg.m^2\n', J);
fprintf('Viscous coefficient = %.8e N.m.s/rad\n', B);


%% ============================================================
% DISPLAY STAGE 3 PLANT
% =============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' STAGE 3 MOTOR PLANT\n');
fprintf('============================================\n');

fprintf('\n');
disp(motor_plant);


%% ============================================================
% PI CONTROLLER
%
% C(s) = Kp + Ki/s
%
%      Kp*s + Ki
% C(s) = ---------
%           s
%
% =============================================================

PI_controller = tf([Kp Ki], [1 0]);


fprintf('\n');
fprintf('============================================\n');
fprintf(' PI CONTROLLER\n');
fprintf('============================================\n');

fprintf('Kp = %.6f\n', Kp);
fprintf('Ki = %.6f\n', Ki);

fprintf('\n');
fprintf('PI controller transfer function:\n');

disp(PI_controller);


%% ============================================================
% OPEN-LOOP SYSTEM
% =============================================================

open_loop = PI_controller * motor_plant;


fprintf('\n');
fprintf('============================================\n');
fprintf(' OPEN-LOOP SYSTEM\n');
fprintf('============================================\n');

fprintf('\n');
disp(open_loop);


%% ============================================================
% UNITY-FEEDBACK CLOSED-LOOP SYSTEM
% =============================================================

closed_loop = feedback(open_loop, 1);


fprintf('\n');
fprintf('============================================\n');
fprintf(' CLOSED-LOOP TRANSFER FUNCTION\n');
fprintf('============================================\n');

fprintf('\n');
fprintf('T(s) = C(s)G(s) / [1 + C(s)G(s)]\n');

fprintf('\n');
disp(closed_loop);


%% ============================================================
% CLOSED-LOOP POLES
% =============================================================

closed_loop_poles = pole(closed_loop);


fprintf('\n');
fprintf('============================================\n');
fprintf(' CLOSED-LOOP POLES\n');
fprintf('============================================\n');

for k = 1:length(closed_loop_poles)

    fprintf('Pole %d = %.10f', ...
        k, real(closed_loop_poles(k)));

    if imag(closed_loop_poles(k)) >= 0
        fprintf(' + %.10fj\n', ...
            imag(closed_loop_poles(k)));
    else
        fprintf(' - %.10fj\n', ...
            abs(imag(closed_loop_poles(k))));
    end

end


%% ============================================================
% CLOSED-LOOP STABILITY
% =============================================================

stable = all(real(closed_loop_poles) < 0);


fprintf('\n');
fprintf('============================================\n');
fprintf(' CLOSED-LOOP STABILITY\n');
fprintf('============================================\n');

if stable
    fprintf('Closed-loop stability = STABLE\n');
else
    fprintf('Closed-loop stability = UNSTABLE\n');
end


%% ============================================================
% CLOSED-LOOP DC GAIN
% =============================================================

closed_loop_dc_gain = dcgain(closed_loop);


fprintf('\n');
fprintf('============================================\n');
fprintf(' CLOSED-LOOP DC GAIN\n');
fprintf('============================================\n');

fprintf('DC gain = %.10f\n', closed_loop_dc_gain);


%% ============================================================
% CLOSED-LOOP CHARACTERISTIC EQUATION
%
% C(s)G(s):
%
%       Kt(Kp*s + Ki)
% ---------------------------
% s(a2*s^2 + a1*s + a0)
%
% Therefore:
%
% a2*s^3
% + a1*s^2
% + (a0 + Kt*Kp)*s
% + Kt*Ki = 0
%
% =============================================================

c3 = a2;
c2 = a1;
c1 = a0 + Kt*Kp;
c0 = Kt*Ki;


fprintf('\n');
fprintf('============================================\n');
fprintf(' CLOSED-LOOP CHARACTERISTIC COEFFICIENTS\n');
fprintf('============================================\n');

fprintf('s^3 coefficient = %.12e\n', c3);
fprintf('s^2 coefficient = %.12e\n', c2);
fprintf('s^1 coefficient = %.12e\n', c1);
fprintf('s^0 coefficient = %.12e\n', c0);


%% ============================================================
% CALCULATE POLES DIRECTLY FROM CHARACTERISTIC EQUATION
% =============================================================

calculated_poles = roots([c3 c2 c1 c0]);


fprintf('\n');
fprintf('============================================\n');
fprintf(' POLES FROM CHARACTERISTIC EQUATION\n');
fprintf('============================================\n');

for k = 1:length(calculated_poles)

    fprintf('Calculated Pole %d = %.10f', ...
        k, real(calculated_poles(k)));

    if imag(calculated_poles(k)) >= 0
        fprintf(' + %.10fj\n', ...
            imag(calculated_poles(k)));
    else
        fprintf(' - %.10fj\n', ...
            abs(imag(calculated_poles(k))));
    end

end


%% ============================================================
% POLE VALIDATION
%
% Expected validated Stage 4 poles
%
% =============================================================

expected_pole_1 = -477.30183641 + 1255.31368292i;
expected_pole_2 = -477.30183641 - 1255.31368292i;
expected_pole_3 = -46.01832065;


%% ============================================================
% POLE VALIDATION WITHOUT LOCAL FUNCTION
% MATLAB R2014a COMPATIBLE
% =============================================================

expected_poles = [
    expected_pole_1;
    expected_pole_2;
    expected_pole_3
];


% Match each expected pole with the closest calculated pole

remaining_poles = calculated_poles;

pole_error = zeros(3,1);

for k = 1:3

    differences = abs(remaining_poles - expected_poles(k));

    [minimum_error, index] = min(differences);

    pole_error(k) = minimum_error;

    remaining_poles(index) = [];

end


pole_tolerance = 1e-5;

poles_match = all(pole_error < pole_tolerance);


fprintf('\n');
fprintf('============================================\n');
fprintf(' CLOSED-LOOP POLE VALIDATION\n');
fprintf('============================================\n');

fprintf('Expected Pole 1 = %.10f + %.10fj\n', ...
    real(expected_pole_1), ...
    imag(expected_pole_1));

fprintf('Expected Pole 2 = %.10f - %.10fj\n', ...
    real(expected_pole_2), ...
    abs(imag(expected_pole_2)));

fprintf('Expected Pole 3 = %.10f\n', ...
    expected_pole_3);

fprintf('\n');

fprintf('Maximum pole error = %.12e\n', ...
    max(pole_error));

if poles_match
    fprintf('Closed-loop poles = PASS\n');
else
    fprintf('Closed-loop poles = CHECK\n');
end


%% ============================================================
% SPEED REFERENCE
% =============================================================

reference_speed_rpm = rated_speed_rpm;

reference_speed_rad_s = ...
    reference_speed_rpm * 2*pi/60;


fprintf('\n');
fprintf('============================================\n');
fprintf(' SPEED REFERENCE\n');
fprintf('============================================\n');

fprintf('Reference speed = %.2f rpm\n', ...
    reference_speed_rpm);

fprintf('Reference speed = %.6f rad/s\n', ...
    reference_speed_rad_s);


%% ============================================================
% UNIT STEP RESPONSE
% =============================================================

figure;

step(closed_loop);

grid on;

title('BO4831NH2B02-101-24.0 - Closed-Loop PI Response');

xlabel('Time (s)');

ylabel('Speed Response');


%% ============================================================
% STEP RESPONSE INFORMATION
% =============================================================

step_info = stepinfo(closed_loop);


fprintf('\n');
fprintf('============================================\n');
fprintf(' CLOSED-LOOP STEP RESPONSE\n');
fprintf('============================================\n');

fprintf('Rise time       = %.10f s\n', ...
    step_info.RiseTime);

fprintf('Settling time   = %.10f s\n', ...
    step_info.SettlingTime);

fprintf('Overshoot       = %.10f %%\n', ...
    step_info.Overshoot);

fprintf('Peak            = %.10f\n', ...
    step_info.Peak);


%% ============================================================
% STEADY-STATE ERROR
% =============================================================

steady_state_error = ...
    abs(1 - closed_loop_dc_gain);


fprintf('\n');
fprintf('============================================\n');
fprintf(' STEADY-STATE ERROR\n');
fprintf('============================================\n');

fprintf('Closed-loop DC gain = %.10f\n', ...
    closed_loop_dc_gain);

fprintf('Steady-state error  = %.10e\n', ...
    steady_state_error);


%% ============================================================
% FINAL VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' STAGE 4 VALIDATION\n');
fprintf('============================================\n');


% Stability

if stable
    fprintf('Closed-loop stability       = PASS\n');
else
    fprintf('Closed-loop stability       = FAIL\n');
end


% Pole validation

if poles_match
    fprintf('Closed-loop pole validation = PASS\n');
else
    fprintf('Closed-loop pole validation = CHECK\n');
end


% DC gain validation

if abs(closed_loop_dc_gain - 1) < 1e-10
    fprintf('Zero steady-state error     = PASS\n');
else
    fprintf('Zero steady-state error     = CHECK\n');
end


%% ============================================================
% OVERALL STAGE 4 RESULT
% =============================================================

stage4_pass = ...
    stable && ...
    poles_match && ...
    (abs(closed_loop_dc_gain - 1) < 1e-10);


fprintf('\n');
fprintf('============================================\n');
fprintf(' STAGE 4 FINAL RESULT\n');
fprintf('============================================\n');

if stage4_pass

    fprintf('STAGE 4 = PASS\n');

else

    fprintf('STAGE 4 = CHECK REQUIRED\n');

end


fprintf('\n');
fprintf('PI controller implemented successfully.\n');
fprintf('Kp = %.6f\n', Kp);
fprintf('Ki = %.6f\n', Ki);

fprintf('\n');
fprintf('Closed-loop model generated.\n');
fprintf('Closed-loop poles calculated.\n');
fprintf('Stability checked.\n');
fprintf('Steady-state tracking checked.\n');

fprintf('\n');
fprintf('============================================\n');
fprintf(' END OF STAGE 4\n');
fprintf('============================================\n');
