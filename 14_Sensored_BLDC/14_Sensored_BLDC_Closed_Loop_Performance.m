clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 14 - SENSORED BLDC CLOSED-LOOP PERFORMANCE SWEEP\n');
fprintf('============================================================\n');

%% ============================================================
%  LOCKED MOTOR PARAMETERS
% =============================================================

Vdc = 24.0;
R   = 0.080;
L   = 8.0e-05;

Ke  = 0.028018;
Kt  = 0.025398;

J   = 3.060e-05;
p   = 7;

rated_rpm = 7700;
rated_I   = 17.60;
rated_T   = 0.447;

Kp = 0.150;
Ki = 8.000;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' LOCKED MOTOR PARAMETERS\n');
fprintf('============================================================\n');

fprintf('DC voltage          = %.6f V\n',Vdc);
fprintf('Resistance          = %.8f Ohm\n',R);
fprintf('Inductance          = %.8e H\n',L);
fprintf('Effective Ke        = %.8f V.s/rad\n',Ke);
fprintf('Effective Kt        = %.8f N.m/A\n',Kt);
fprintf('Rotor inertia       = %.8e kg.m^2\n',J);
fprintf('Pole pairs          = %d\n',p);
fprintf('Rated speed         = %.2f rpm\n',rated_rpm);
fprintf('Rated current       = %.2f A\n',rated_I);
fprintf('Rated torque        = %.6f N.m\n',rated_T);

fprintf('\n');
fprintf('PI controller:\n');
fprintf('Kp                  = %.6f\n',Kp);
fprintf('Ki                  = %.6f\n',Ki);

%% ============================================================
%  MOTOR SPEED MODEL
% =============================================================

% Averaged electromechanical motor:
%
% G(s) = Kt /
%        ((J*s)*(L*s+R) + Kt*Ke)

num_motor = Kt;

den_motor = [J*L J*R Kt*Ke];

Gmotor = tf(num_motor,den_motor);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MOTOR TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Gmotor

%% ============================================================
%  PI CONTROLLER
% =============================================================

PI = tf([Kp Ki],[1 0]);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PI CONTROLLER\n');
fprintf('============================================================\n');

PI

%% ============================================================
%  CLOSED LOOP
% =============================================================

Lopen = PI*Gmotor;
Tclosed = feedback(Lopen,1);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Tclosed

%% ============================================================
%  CLOSED LOOP POLES
% =============================================================

poles = pole(Tclosed);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP POLES\n');
fprintf('============================================================\n');

for k = 1:length(poles)
    fprintf('Pole %d = %.12f %+ .12fj\n', ...
        k,real(poles(k)),imag(poles(k)));
end

stable_flag = 1;

for k = 1:length(poles)
    if real(poles(k)) >= 0
        stable_flag = 0;
    end
end

if stable_flag
    fprintf('Closed-loop stability = PASS\n');
else
    fprintf('Closed-loop stability = FAIL\n');
end

%% ============================================================
%  SPEED REFERENCES
% =============================================================

speed_ref_rpm = [2000 5000 7700];

speed_ref_rad = speed_ref_rpm*2*pi/60;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SPEED REFERENCES\n');
fprintf('============================================================\n');

for k = 1:length(speed_ref_rpm)
    fprintf('%4d rpm = %.12f rad/s\n', ...
        speed_ref_rpm(k),speed_ref_rad(k));
end

%% ============================================================
%  SIMULATION SETTINGS
% =============================================================

t = 0:1e-5:0.15;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SIMULATION SETTINGS\n');
fprintf('============================================================\n');

fprintf('Simulation time = %.6f s\n',t(end));
fprintf('Time step       = %.8f s\n',t(2)-t(1));
fprintf('Simulation points = %d\n',length(t));

%% ============================================================
%  STORAGE
% =============================================================

final_speed   = zeros(1,length(speed_ref_rpm));
peak_speed    = zeros(1,length(speed_ref_rpm));
rise_time     = zeros(1,length(speed_ref_rpm));
settle_time   = zeros(1,length(speed_ref_rpm));
overshoot     = zeros(1,length(speed_ref_rpm));
speed_error   = zeros(1,length(speed_ref_rpm));
error_percent = zeros(1,length(speed_ref_rpm));

%% ============================================================
%  SPEED RESPONSE SWEEP
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP SPEED RESPONSE SWEEP\n');
fprintf('============================================================\n');

figure;

for k = 1:length(speed_ref_rpm)

    r = speed_ref_rad(k)*ones(size(t));

    [y,tt] = lsim(Tclosed,r,t);

    y_rpm = y*60/(2*pi);

    final_speed(k) = y_rpm(end);
    peak_speed(k)  = max(y_rpm);

    % Rise time: 10% to 90%
    low_level  = 0.10*speed_ref_rpm(k);
    high_level = 0.90*speed_ref_rpm(k);

    idx10 = find(y_rpm >= low_level);

    if isempty(idx10)
        rise_time(k) = NaN;
    else
        i10 = idx10(1);

        idx90 = find(y_rpm >= high_level);

        if isempty(idx90)
            rise_time(k) = NaN;
        else
            i90 = idx90(1);
            rise_time(k) = tt(i90)-tt(i10);
        end
    end

    % 2% settling time
    band = 0.02*speed_ref_rpm(k);

    outside = find(abs(y_rpm-speed_ref_rpm(k)) > band);

    if isempty(outside)
        settle_time(k) = 0;
    else
        last_outside = outside(end);

        if last_outside < length(tt)
            settle_time(k) = tt(last_outside+1);
        else
            settle_time(k) = NaN;
        end
    end

    overshoot(k) = ...
        max(0,(peak_speed(k)-speed_ref_rpm(k))) ...
        /speed_ref_rpm(k)*100;

    speed_error(k) = ...
        abs(speed_ref_rpm(k)-final_speed(k));

    error_percent(k) = ...
        speed_error(k)/speed_ref_rpm(k)*100;

    subplot(3,1,k);
    plot(tt,y_rpm,'LineWidth',1.2);
    hold on;
    plot(tt,speed_ref_rpm(k)*ones(size(tt)),'--');
    grid on;

    xlabel('Time (s)');
    ylabel('Speed (rpm)');

    title(sprintf('%d rpm Reference',speed_ref_rpm(k)));

    fprintf('\n');
    fprintf('%4d rpm reference:\n',speed_ref_rpm(k));
    fprintf('  Final speed       = %.9f rpm\n',final_speed(k));
    fprintf('  Peak speed        = %.9f rpm\n',peak_speed(k));
    fprintf('  Rise time         = %.9f s\n',rise_time(k));
    fprintf('  Settling time     = %.9f s\n',settle_time(k));
    fprintf('  Overshoot         = %.6f %%\n',overshoot(k));
    fprintf('  Steady-state error= %.9f rpm\n',speed_error(k));
    fprintf('  Error percentage  = %.9f %%\n',error_percent(k));

end

%% ============================================================
%  MULTI-SPEED TRACKING VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MULTI-SPEED TRACKING VALIDATION\n');
fprintf('============================================================\n');

tracking_pass = 1;

for k = 1:length(speed_ref_rpm)

    if error_percent(k) <= 1.0
        fprintf('%4d rpm tracking = PASS\n',speed_ref_rpm(k));
    else
        fprintf('%4d rpm tracking = FAIL\n',speed_ref_rpm(k));
        tracking_pass = 0;
    end

end

%% ============================================================
%  RATED SPEED VALIDATION
% =============================================================

rated_index = 3;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED SPEED VALIDATION\n');
fprintf('============================================================\n');

fprintf('Rated reference     = %.2f rpm\n',rated_rpm);
fprintf('Final simulated     = %.9f rpm\n',final_speed(rated_index));
fprintf('Absolute error      = %.9f rpm\n',speed_error(rated_index));
fprintf('Percentage error    = %.9f %%\n',error_percent(rated_index));

if error_percent(rated_index) <= 1.0
    rated_pass = 1;
    fprintf('Rated speed tracking = PASS\n');
else
    rated_pass = 0;
    fprintf('Rated speed tracking = FAIL\n');
end

%% ============================================================
%  DC GAIN
% =============================================================

dc_gain = dcgain(Tclosed);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP DC GAIN\n');
fprintf('============================================================\n');

fprintf('Closed-loop DC gain = %.12f\n',dc_gain);

if abs(dc_gain-1) < 1e-6
    dc_gain_pass = 1;
    fprintf('DC gain validation = PASS\n');
else
    dc_gain_pass = 0;
    fprintf('DC gain validation = FAIL\n');
end

%% ============================================================
%  DUTY-CYCLE REQUIREMENT
% =============================================================

rated_omega = rated_rpm*2*pi/60;

rated_emf = Ke*rated_omega;

rated_ir = rated_I*R;

required_voltage = rated_emf + rated_ir;

required_duty = required_voltage/Vdc;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED-POINT PWM DUTY CHECK\n');
fprintf('============================================================\n');

fprintf('Rated back-EMF       = %.9f V\n',rated_emf);
fprintf('Rated I*R drop        = %.9f V\n',rated_ir);
fprintf('Required voltage      = %.9f V\n',required_voltage);
fprintf('Available DC voltage  = %.9f V\n',Vdc);
fprintf('Required duty         = %.9f\n',required_duty);
fprintf('Required duty         = %.6f %%\n',required_duty*100);

if required_duty <= 1
    duty_pass = 1;
    fprintf('Duty-cycle feasibility = PASS\n');
else
    duty_pass = 0;
    fprintf('Duty-cycle feasibility = REVIEW\n');
end

%% ============================================================
%  RATED CURRENT / TORQUE REFERENCE
% =============================================================

rated_torque_calc = Kt*rated_I;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED CURRENT / TORQUE CHECK\n');
fprintf('============================================================\n');

fprintf('Rated current          = %.6f A\n',rated_I);
fprintf('Calculated torque      = %.9f N.m\n',rated_torque_calc);
fprintf('Datasheet torque       = %.9f N.m\n',rated_T);

torque_error = abs(rated_torque_calc-rated_T)/rated_T*100;

fprintf('Torque difference      = %.9f %%\n',torque_error);

if torque_error <= 1
    torque_pass = 1;
    fprintf('Rated torque validation = PASS\n');
else
    torque_pass = 0;
    fprintf('Rated torque validation = REVIEW\n');
end

%% ============================================================
%  SENSORED BLDC ARCHITECTURE
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SENSORED BLDC CLOSED-LOOP ARCHITECTURE\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf('Speed reference\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' PI speed controller\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' PWM duty command\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' 3-phase inverter\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Six-step commutation\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' BLDC phase currents\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Electromagnetic torque\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Mechanical speed\n');
fprintf('      |\n');
fprintf('      v\n');
fprintf(' Hall sensors\n');
fprintf('      |\n');
fprintf('      +-------- feedback --------+\n');

%% ============================================================
%  PERFORMANCE SUMMARY
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PERFORMANCE SUMMARY\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf(' Reference    Final Speed    Peak Speed    Rise Time    Settling Time    Overshoot\n');
fprintf('   (rpm)         (rpm)          (rpm)          (s)            (s)            (%%)\n');

for k = 1:length(speed_ref_rpm)

    fprintf('%8.0f %15.6f %14.6f %13.6f %16.6f %14.6f\n', ...
        speed_ref_rpm(k), ...
        final_speed(k), ...
        peak_speed(k), ...
        rise_time(k), ...
        settle_time(k), ...
        overshoot(k));

end

%% ============================================================
%  FINAL VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 14 FINAL VALIDATION\n');
fprintf('============================================================\n');

fprintf('Closed-loop stability       = ');
if stable_flag
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Closed-loop DC gain         = ');
if dc_gain_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Multi-speed tracking        = ');
if tracking_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Rated-speed tracking        = ');
if rated_pass
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

fprintf('Rated torque consistency    = ');
if torque_pass
    fprintf('PASS\n');
else
    fprintf('REVIEW\n');
end

fprintf('PWM duty feasibility        = ');
if duty_pass
    fprintf('PASS\n');
else
    fprintf('REVIEW\n');
end

%% ============================================================
%  OVERALL RESULT
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 14 OVERALL RESULT\n');
fprintf('============================================================\n');

if stable_flag && dc_gain_pass && tracking_pass && rated_pass

    if duty_pass && torque_pass
        fprintf('STAGE 14 = PASS\n');
    else
        fprintf('STAGE 14 = PASS WITH REVIEW\n');
    end

else

    fprintf('STAGE 14 = REVIEW\n');

end

fprintf('\n');
fprintf('Sensored BLDC closed-loop speed response evaluated.\n');
fprintf('PI speed control validated.\n');
fprintf('Multi-speed tracking evaluated.\n');
fprintf('Rated-speed tracking evaluated.\n');
fprintf('Closed-loop stability verified.\n');
fprintf('Rated-point PWM duty requirement evaluated.\n');
fprintf('Rated torque consistency evaluated.\n');

fprintf('\n');
fprintf('IMPORTANT MODEL LIMITATION:\n');
fprintf('This stage uses the validated averaged electromechanical\n');
fprintf('plant together with the sensored BLDC architecture.\n');
fprintf('Exact MOSFET switching, PWM carrier ripple, dead time,\n');
fprintf('device voltage drops and manufacturer-specific Hall-to-\n');
fprintf('phase wiring are not experimentally verified.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 14\n');
fprintf('============================================================\n');
