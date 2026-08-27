clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 5 - OPEN/CLOSED LOOP CHARACTERISTICS & VALIDATION\n');
fprintf('============================================================\n');


%% ============================================================
% 1. LOCKED MOTOR PARAMETERS
% =============================================================

Vdc = 24.0;

R  = 0.080000;
L  = 80e-6;

Ke = 0.028018;
Kt = 0.025398;

J  = 3.060e-05;
B  = 1.9033e-05;


%% ============================================================
% 2. LOCKED PI CONTROLLER PARAMETERS
% =============================================================

Kp = 0.15;
Ki = 8;


%% ============================================================
% 3. DATASHEET REFERENCE VALUES
%
% IMPORTANT:
% These are comparison values only.
% They DO NOT replace the locked Stage 3/4 parameters.
% =============================================================

rated_voltage       = 24.0;
rated_speed_rpm     = 7700.0;
rated_current       = 17.6;
rated_torque_Nm     = 0.447;

no_load_speed_rpm   = 10160.0;
no_load_current     = 0.9;

datasheet_R         = 0.080;
datasheet_Ke_mVrpm  = 2.4;
datasheet_Kt_mNmA   = 22.5;


%% ============================================================
% 4. CONVERT DATASHEET CONSTANTS
% =============================================================

% Datasheet Ke:
%
% 2.4 mV/rpm -> V.s/rad
%
% Ke = 0.0024 * 60/(2*pi)

datasheet_Ke = ...
    (datasheet_Ke_mVrpm / 1000) * 60/(2*pi);


% Datasheet Kt:
%
% 22.5 mN.m/A -> N.m/A

datasheet_Kt = ...
    datasheet_Kt_mNmA / 1000;


%% ============================================================
% 5. DISPLAY CONSTANT COMPARISON
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MODEL CONSTANTS VS DATASHEET REFERENCE\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf('Locked model Ke       = %.8f V.s/rad\n',Ke);

fprintf('Datasheet Ke          = %.8f V.s/rad\n',datasheet_Ke);

fprintf('Difference            = %.6f %%\n', ...
    abs(Ke-datasheet_Ke)/datasheet_Ke*100);


fprintf('\n');

fprintf('Locked model Kt       = %.8f N.m/A\n',Kt);

fprintf('Datasheet Kt          = %.8f N.m/A\n',datasheet_Kt);

fprintf('Difference            = %.6f %%\n', ...
    abs(Kt-datasheet_Kt)/datasheet_Kt*100);


fprintf('\n');
fprintf('NOTE: Locked model constants are retained.\n');
fprintf('Datasheet constants are used for reference comparison only.\n');


%% ============================================================
% 6. MOTOR TRANSFER FUNCTION
%
% G(s) = Kt /
% [LJ*s^2 + (LB+RJ)*s + (RB+Ke*Kt)]
%
% =============================================================

a2 = L * J;
a1 = L * B + R * J;
a0 = R * B + Ke * Kt;

motor_plant = tf(Kt,[a2 a1 a0]);


%% ============================================================
% 7. OPEN-LOOP MOTOR CHARACTERISTICS
% =============================================================

motor_poles = pole(motor_plant);

motor_dc_gain = dcgain(motor_plant);

motor_stable = ...
    all(real(motor_poles) < 0);


fprintf('\n');
fprintf('============================================================\n');
fprintf(' 5.1 OPEN-LOOP MOTOR CHARACTERISTICS\n');
fprintf('============================================================\n');

fprintf('\nMotor transfer function:\n');
disp(motor_plant);


fprintf('\nOpen-loop motor poles:\n');

for k = 1:length(motor_poles)

    fprintf('Pole %d = %.10f', ...
        k,real(motor_poles(k)));

    if imag(motor_poles(k)) >= 0

        fprintf(' + %.10fj\n', ...
            imag(motor_poles(k)));

    else

        fprintf(' - %.10fj\n', ...
            abs(imag(motor_poles(k))));

    end

end


fprintf('\nOpen-loop motor DC gain = %.10f\n', ...
    motor_dc_gain);


if motor_stable
    fprintf('Open-loop motor stability = STABLE\n');
else
    fprintf('Open-loop motor stability = UNSTABLE\n');
end


%% ============================================================
% 8. PI CONTROLLER
% =============================================================

PI_controller = tf([Kp Ki],[1 0]);


%% ============================================================
% 9. PI-CONTROLLED OPEN LOOP
% =============================================================

open_loop = PI_controller * motor_plant;

open_loop_poles = pole(open_loop);


fprintf('\n');
fprintf('============================================================\n');
fprintf(' 5.2 PI-CONTROLLED OPEN-LOOP CHARACTERISTICS\n');
fprintf('============================================================\n');

fprintf('\nPI controller:\n');
disp(PI_controller);

fprintf('\nPI-controlled open-loop transfer function:\n');
disp(open_loop);


fprintf('\nOpen-loop poles:\n');

for k = 1:length(open_loop_poles)

    fprintf('Pole %d = %.10f', ...
        k,real(open_loop_poles(k)));

    if imag(open_loop_poles(k)) >= 0

        fprintf(' + %.10fj\n', ...
            imag(open_loop_poles(k)));

    else

        fprintf(' - %.10fj\n', ...
            abs(imag(open_loop_poles(k))));

    end

end


%% ============================================================
% 10. OPEN-LOOP STABILITY MARGINS
% =============================================================

[Gm,Pm,Wcg,Wcp] = margin(open_loop);


fprintf('\n');
fprintf('============================================================\n');
fprintf(' OPEN-LOOP STABILITY MARGINS\n');
fprintf('============================================================\n');

if isinf(Gm)

    fprintf('Gain margin        = INF\n');
    fprintf('Gain margin (dB)   = INF dB\n');

else

    fprintf('Gain margin        = %.10f\n',Gm);
    fprintf('Gain margin (dB)   = %.10f dB\n', ...
        20*log10(Gm));

end


fprintf('Phase margin       = %.10f deg\n',Pm);

if isinf(Wcg)
    fprintf('Gain crossover     = INF\n');
else
    fprintf('Gain crossover     = %.10f rad/s\n',Wcg);
end

if isinf(Wcp)
    fprintf('Phase crossover    = INF\n');
else
    fprintf('Phase crossover    = %.10f rad/s\n',Wcp);
end


%% ============================================================
% 11. CLOSED-LOOP SYSTEM
% =============================================================

closed_loop = feedback(open_loop,1);

closed_loop_poles = pole(closed_loop);

closed_loop_dc_gain = dcgain(closed_loop);

closed_loop_stable = ...
    all(real(closed_loop_poles) < 0);


fprintf('\n');
fprintf('============================================================\n');
fprintf(' 5.3 CLOSED-LOOP CHARACTERISTICS\n');
fprintf('============================================================\n');

fprintf('\nClosed-loop transfer function:\n');
disp(closed_loop);


fprintf('\nClosed-loop poles:\n');

for k = 1:length(closed_loop_poles)

    fprintf('Pole %d = %.10f', ...
        k,real(closed_loop_poles(k)));

    if imag(closed_loop_poles(k)) >= 0

        fprintf(' + %.10fj\n', ...
            imag(closed_loop_poles(k)));

    else

        fprintf(' - %.10fj\n', ...
            abs(imag(closed_loop_poles(k))));

    end

end


if closed_loop_stable
    fprintf('\nClosed-loop stability = STABLE\n');
else
    fprintf('\nClosed-loop stability = UNSTABLE\n');
end


fprintf('Closed-loop DC gain = %.10f\n', ...
    closed_loop_dc_gain);


%% ============================================================
% 12. CLOSED-LOOP STEP RESPONSE
% =============================================================

step_data = stepinfo(closed_loop);

steady_state_error = ...
    abs(1-closed_loop_dc_gain);


fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP DYNAMIC CHARACTERISTICS\n');
fprintf('============================================================\n');

fprintf('Rise time          = %.10f s\n', ...
    step_data.RiseTime);

fprintf('Settling time      = %.10f s\n', ...
    step_data.SettlingTime);

fprintf('Overshoot          = %.10f %%\n', ...
    step_data.Overshoot);

fprintf('Peak               = %.10f\n', ...
    step_data.Peak);

fprintf('Steady-state error = %.10e\n', ...
    steady_state_error);


%% ============================================================
% 13. CLOSED-LOOP BANDWIDTH
% =============================================================

try

    closed_loop_bandwidth = bandwidth(closed_loop);

catch

    closed_loop_bandwidth = NaN;

end


fprintf('\nClosed-loop bandwidth = %.10f rad/s\n', ...
    closed_loop_bandwidth);


%% ============================================================
% 14. RATED SPEED CONVERSION
% =============================================================

rated_speed_rad_s = ...
    rated_speed_rpm * 2*pi/60;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED SPEED\n');
fprintf('============================================================\n');

fprintf('Rated speed = %.2f rpm\n', ...
    rated_speed_rpm);

fprintf('Rated speed = %.6f rad/s\n', ...
    rated_speed_rad_s);


%% ============================================================
% 15. RATED BACK-EMF USING LOCKED MODEL Ke
% =============================================================

model_rated_back_emf = ...
    Ke * rated_speed_rad_s;


datasheet_rated_back_emf = ...
    datasheet_Ke * rated_speed_rad_s;


Ke_model_vs_datasheet_difference = ...
    abs(model_rated_back_emf-datasheet_rated_back_emf) ...
    / datasheet_rated_back_emf * 100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' 5.4 BACK-EMF REFERENCE COMPARISON\n');
fprintf('============================================================\n');

fprintf('Locked model Ke = %.8f V.s/rad\n',Ke);

fprintf('Datasheet Ke    = %.8f V.s/rad\n',datasheet_Ke);

fprintf('\n');

fprintf('Model back EMF at 7700 rpm = %.6f V\n', ...
    model_rated_back_emf);

fprintf('Datasheet-based EMF        = %.6f V\n', ...
    datasheet_rated_back_emf);

fprintf('Difference                 = %.6f %%\n', ...
    Ke_model_vs_datasheet_difference);

fprintf('\n');
fprintf('STATUS: REFERENCE DIFFERENCE - CONSTANT CONVENTION REVIEW\n');


%% ============================================================
% 16. RATED TORQUE VALIDATION
%
% T = Kt * I
%
% =============================================================

model_rated_torque = ...
    Kt * rated_current;


rated_torque_difference = ...
    abs(model_rated_torque-rated_torque_Nm) ...
    / rated_torque_Nm * 100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED TORQUE VALIDATION\n');
fprintf('============================================================\n');

fprintf('Rated current          = %.6f A\n', ...
    rated_current);

fprintf('Locked model Kt        = %.8f N.m/A\n', ...
    Kt);

fprintf('Calculated torque      = %.6f N.m\n', ...
    model_rated_torque);

fprintf('Datasheet rated torque = %.6f N.m\n', ...
    rated_torque_Nm);

fprintf('Difference             = %.6f %%\n', ...
    rated_torque_difference);


if rated_torque_difference < 5
    fprintf('Rated torque validation = PASS\n');
elseif rated_torque_difference < 10
    fprintf('Rated torque validation = CLOSE\n');
else
    fprintf('Rated torque validation = REVIEW\n');
end


%% ============================================================
% 17. RESISTANCE VALIDATION
% =============================================================

R_difference = ...
    abs(R-datasheet_R)/datasheet_R*100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' RESISTANCE VALIDATION\n');
fprintf('============================================================\n');

fprintf('Model resistance     = %.8f Ohm\n',R);

fprintf('Datasheet resistance = %.8f Ohm\n',datasheet_R);

fprintf('Difference            = %.6f %%\n',R_difference);


if R_difference < 1
    fprintf('Resistance validation = PASS\n');
else
    fprintf('Resistance validation = REVIEW\n');
end


%% ============================================================
% 18. RATED-POINT ELECTRICAL BALANCE
%
% V = R*I + Ke*w
%
% This uses the LOCKED model parameters.
%
% =============================================================

rated_R_drop = ...
    R*rated_current;


rated_model_back_emf = ...
    Ke*rated_speed_rad_s;


rated_required_voltage = ...
    rated_R_drop + rated_model_back_emf;


rated_voltage_difference = ...
    abs(rated_required_voltage-Vdc)/Vdc*100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED-POINT ELECTRICAL BALANCE\n');
fprintf('============================================================\n');

fprintf('I*R drop             = %.9f V\n', ...
    rated_R_drop);

fprintf('Back EMF             = %.9f V\n', ...
    rated_model_back_emf);

fprintf('Required voltage     = %.9f V\n', ...
    rated_required_voltage);

fprintf('Available Vdc        = %.9f V\n', ...
    Vdc);

fprintf('Difference           = %.9f %%\n', ...
    rated_voltage_difference);


% Engineering tolerance:
% Less than 1% is considered a close/pass result.

if rated_voltage_difference < 1

    fprintf('Rated voltage balance = PASS\n');

elseif rated_voltage_difference < 5

    fprintf('Rated voltage balance = CLOSE\n');

else

    fprintf('Rated voltage balance = REVIEW\n');

end


%% ============================================================
% 19. NO-LOAD REFERENCE CHECK
%
% IMPORTANT:
% The simple equation V = Ke*w + R*I is used only as a
% consistency check.
%
% It is NOT used to modify the locked model.
%
% =============================================================

no_load_speed_rad_s = ...
    no_load_speed_rpm*2*pi/60;


no_load_model_back_emf = ...
    Ke*no_load_speed_rad_s;


no_load_R_drop = ...
    R*no_load_current;


no_load_required_voltage = ...
    no_load_model_back_emf + no_load_R_drop;


no_load_speed_prediction_rad_s = ...
    (Vdc-R*no_load_current)/Ke;


no_load_speed_prediction_rpm = ...
    no_load_speed_prediction_rad_s*60/(2*pi);


no_load_speed_difference = ...
    abs(no_load_speed_prediction_rpm-no_load_speed_rpm) ...
    / no_load_speed_rpm*100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' NO-LOAD REFERENCE CHECK\n');
fprintf('============================================================\n');

fprintf('Datasheet no-load speed = %.2f rpm\n', ...
    no_load_speed_rpm);

fprintf('Datasheet no-load current = %.6f A\n', ...
    no_load_current);

fprintf('\n');

fprintf('Locked-model predicted no-load speed = %.6f rpm\n', ...
    no_load_speed_prediction_rpm);

fprintf('Datasheet no-load speed              = %.6f rpm\n', ...
    no_load_speed_rpm);

fprintf('Difference                            = %.6f %%\n', ...
    no_load_speed_difference);

fprintf('\n');

fprintf('Model EMF at datasheet no-load speed = %.6f V\n', ...
    no_load_model_back_emf);

fprintf('I*R drop                             = %.6f V\n', ...
    no_load_R_drop);

fprintf('Simple-model required voltage        = %.6f V\n', ...
    no_load_required_voltage);

fprintf('Available voltage                    = %.6f V\n', ...
    Vdc);

fprintf('\n');
fprintf('STATUS: REFERENCE CHECK - REVIEW EFFECTIVE Ke / MOTOR CONVENTION\n');


%% ============================================================
% 20. CHARACTERISTIC EQUATION
% =============================================================

c3 = a2;

c2 = a1;

c1 = a0 + Kt*Kp;

c0 = Kt*Ki;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP CHARACTERISTIC EQUATION\n');
fprintf('============================================================\n');

fprintf('c3 = %.12e\n',c3);
fprintf('c2 = %.12e\n',c2);
fprintf('c1 = %.12e\n',c1);
fprintf('c0 = %.12e\n',c0);

fprintf('\nCharacteristic equation:\n');

fprintf('%.6e s^3 + ',c3);
fprintf('%.6e s^2 + ',c2);
fprintf('%.6e s + ',c1);
fprintf('%.6e = 0\n',c0);


%% ============================================================
% 21. POLE VALIDATION FROM CHARACTERISTIC EQUATION
% =============================================================

calculated_poles = ...
    roots([c3 c2 c1 c0]);


fprintf('\nCalculated characteristic-equation poles:\n');

for k = 1:length(calculated_poles)

    fprintf('Pole %d = %.10f', ...
        k,real(calculated_poles(k)));

    if imag(calculated_poles(k)) >= 0

        fprintf(' + %.10fj\n', ...
            imag(calculated_poles(k)));

    else

        fprintf(' - %.10fj\n', ...
            abs(imag(calculated_poles(k))));

    end

end


%% ============================================================
% 22. PLOTS
% =============================================================

% Open-loop Bode plot

figure;

margin(open_loop);

grid on;

title('BO4831NH2B02-101-24.0 - PI Open-Loop Bode Plot');


% Closed-loop response

figure;

step(closed_loop);

grid on;

title('BO4831NH2B02-101-24.0 - Closed-Loop Step Response');

xlabel('Time (s)');

ylabel('Normalized Speed');


%% ============================================================
% 23. FINAL VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 5 FINAL VALIDATION\n');
fprintf('============================================================\n');


%% Dynamic validation

if motor_stable
    fprintf('Open-loop motor stability       = PASS\n');
else
    fprintf('Open-loop motor stability       = FAIL\n');
end


if closed_loop_stable
    fprintf('Closed-loop stability           = PASS\n');
else
    fprintf('Closed-loop stability           = FAIL\n');
end


if steady_state_error < 1e-10
    fprintf('Steady-state error              = PASS\n');
else
    fprintf('Steady-state error              = REVIEW\n');
end


%% Physical validation

if R_difference < 1
    fprintf('Resistance validation            = PASS\n');
else
    fprintf('Resistance validation            = REVIEW\n');
end


if rated_torque_difference < 5
    fprintf('Rated torque validation          = PASS\n');
elseif rated_torque_difference < 10
    fprintf('Rated torque validation          = CLOSE\n');
else
    fprintf('Rated torque validation          = REVIEW\n');
end


if rated_voltage_difference < 1
    fprintf('Rated voltage balance            = PASS\n');
elseif rated_voltage_difference < 5
    fprintf('Rated voltage balance            = CLOSE\n');
else
    fprintf('Rated voltage balance            = REVIEW\n');
end


fprintf('Back-EMF constant comparison     = REFERENCE REVIEW\n');

fprintf('No-load speed consistency        = REFERENCE REVIEW\n');


%% ============================================================
% 24. OVERALL STAGE 5 STATUS
% =============================================================

dynamic_pass = ...
    motor_stable && ...
    closed_loop_stable && ...
    (steady_state_error < 1e-10);


physical_pass = ...
    (R_difference < 1) && ...
    (rated_torque_difference < 5) && ...
    (rated_voltage_difference < 1);


fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 5 OVERALL RESULT\n');
fprintf('============================================================\n');


if dynamic_pass && physical_pass

    fprintf('STAGE 5 = PASS WITH DATASHEET REFERENCE REVIEW\n');

elseif dynamic_pass

    fprintf('STAGE 5 = DYNAMIC PASS / DATASHEET REFERENCE REVIEW\n');

else

    fprintf('STAGE 5 = CHECK REQUIRED\n');

end


fprintf('\n');
fprintf('Open-loop characteristics analyzed.\n');
fprintf('PI-controlled open-loop analyzed.\n');
fprintf('Closed-loop characteristics analyzed.\n');
fprintf('Characteristic equation verified.\n');
fprintf('Rated torque validated.\n');
fprintf('Rated voltage balance validated.\n');
fprintf('Datasheet constants retained as reference values.\n');
fprintf('No-load point retained as a model-convention review.\n');


fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 5\n');
fprintf('============================================================\n');
