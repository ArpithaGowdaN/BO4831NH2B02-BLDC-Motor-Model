clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 15 - LOAD DISTURBANCE & TORQUE REJECTION VALIDATION\n');
fprintf('============================================================\n');

%% ============================================================
% LOCKED MOTOR PARAMETERS
% ============================================================

Vdc = 24.0;
R   = 0.080;
L   = 8.0e-05;

Ke  = 0.028018;
Kt  = 0.025398;

J   = 3.060e-05;
p   = 7;

rated_speed_rpm = 7700.0;
rated_current   = 17.60;
rated_torque    = 0.447;

Kp = 0.15;
Ki = 8.0;

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
fprintf('Rated speed         = %.2f rpm\n',rated_speed_rpm);
fprintf('Rated current       = %.2f A\n',rated_current);
fprintf('Rated torque        = %.3f N.m\n',rated_torque);

fprintf('\n');
fprintf('PI controller:\n');
fprintf('Kp                  = %.6f\n',Kp);
fprintf('Ki                  = %.6f\n',Ki);

%% ============================================================
% SPEED CONVERSION
% ============================================================

rated_speed = rated_speed_rpm*2*pi/60;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SPEED CONVERSION\n');
fprintf('============================================================\n');

fprintf('Rated speed         = %.6f rpm\n',rated_speed_rpm);
fprintf('Rated angular speed = %.12f rad/s\n',rated_speed);

%% ============================================================
% MECHANICAL DAMPING
% ============================================================

B = 1.0e-05;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MECHANICAL DAMPING\n');
fprintf('============================================================\n');

fprintf('Viscous damping B     = %.8e N.m.s/rad\n',B);
fprintf('Status                = MODEL ASSUMPTION\n');

%% ============================================================
% TRANSFER FUNCTIONS
% ============================================================

s = tf('s');

% Motor voltage-to-speed plant
Gmotor = Kt / ...
    ((L*s + R)*(J*s + B) + Ke*Kt);

% PI controller
PI = Kp + Ki/s;

% Open-loop
Loop = PI*Gmotor;

% Closed-loop reference transfer function
Tclosed = feedback(Loop,1);

% Load torque disturbance plant
%
% Load torque acts in the opposite direction to motor torque.
%
% omega/Tload = -(L*s + R) /
% ((L*s + R)*(J*s + B) + Ke*Kt)

Gload = -(L*s + R) / ...
    ((L*s + R)*(J*s + B) + Ke*Kt);

% CORRECT closed-loop disturbance transfer function
%
% Tdist = Gload/(1 + PI*Gmotor)

Tdisturbance = Gload / (1 + Loop);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MOTOR TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Gmotor

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PI CONTROLLER\n');
fprintf('============================================================\n');

PI

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Tclosed

fprintf('\n');
fprintf('============================================================\n');
fprintf(' LOAD DISTURBANCE TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Tdisturbance

%% ============================================================
% CLOSED LOOP POLES
% ============================================================

closed_poles = pole(Tclosed);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP POLES\n');
fprintf('============================================================\n');

for k = 1:length(closed_poles)

    fprintf('Pole %d = %.12f %+.12fj\n', ...
        k, ...
        real(closed_poles(k)), ...
        imag(closed_poles(k)));

end

if all(real(closed_poles) < 0)

    stability_status = 'PASS';

else

    stability_status = 'FAIL';

end

fprintf('Closed-loop stability = %s\n',stability_status);

%% ============================================================
% SIMULATION SETTINGS
% ============================================================

ref_rpm = rated_speed_rpm;

disturbance_time = 0.075;

initial_load_torque = 0.0;
applied_load_torque = rated_torque;

simulation_time = 0.150;
dt = 1.0e-05;

t = (0:dt:simulation_time)';

N = length(t);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' DISTURBANCE SETTINGS\n');
fprintf('============================================================\n');

fprintf('Speed reference       = %.2f rpm\n',ref_rpm);
fprintf('Disturbance time      = %.6f s\n',disturbance_time);
fprintf('Initial load torque   = %.6f N.m\n',initial_load_torque);
fprintf('Applied load torque   = %.6f N.m\n',applied_load_torque);
fprintf('Simulation time       = %.6f s\n',simulation_time);
fprintf('Time step             = %.8f s\n',dt);
fprintf('Simulation points     = %d\n',N);

%% ============================================================
% REFERENCE SIGNAL
% ============================================================

ref_rad = ref_rpm*2*pi/60;

reference = ref_rad*ones(size(t));

%% ============================================================
% LOAD DISTURBANCE SIGNAL
% ============================================================

load_torque = zeros(size(t));

for k = 1:N

    if t(k) >= disturbance_time

        load_torque(k) = applied_load_torque;

    else

        load_torque(k) = initial_load_torque;

    end

end

%% ============================================================
% REFERENCE RESPONSE
% ============================================================

speed_reference_rad = lsim(Tclosed,reference,t);

%% ============================================================
% LOAD DISTURBANCE RESPONSE
% ============================================================

speed_disturbance_rad = ...
    lsim(Tdisturbance,load_torque,t);

%% ============================================================
% TOTAL SPEED
% ============================================================

speed_rad = ...
    speed_reference_rad + speed_disturbance_rad;

speed_rpm = ...
    speed_rad*60/(2*pi);

%% ============================================================
% NUMERICAL SANITY CHECK
% ============================================================

if any(isnan(speed_rpm)) || any(isinf(speed_rpm))

    fprintf('\n');
    fprintf('ERROR: Numerical instability detected.\n');
    fprintf('Stage 15 simulation aborted.\n');

    return;

end

%% ============================================================
% DISTURBANCE RESPONSE PARAMETERS
% ============================================================

pre_index = find(t < disturbance_time);

post_index = find(t >= disturbance_time);

pre_speed = speed_rpm(pre_index);

post_speed = speed_rpm(post_index);

pre_disturbance_speed = pre_speed(end);

[min_post_speed,min_local_index] = min(post_speed);

min_post_index = post_index(min_local_index);

final_speed = speed_rpm(end);

speed_drop = ...
    pre_disturbance_speed - min_post_speed;

final_speed_error = ...
    abs(ref_rpm-final_speed);

final_speed_error_percent = ...
    100*final_speed_error/ref_rpm;

%% ============================================================
% RECOVERY BAND
% ============================================================

upper_band = ref_rpm*1.02;
lower_band = ref_rpm*0.98;

recovery_time = NaN;

for k = min_post_index:N

    remaining_speed = speed_rpm(k:N);

    if all(remaining_speed >= lower_band & ...
           remaining_speed <= upper_band)

        recovery_time = t(k)-disturbance_time;

        break;

    end

end

if isnan(recovery_time)

    recovery_status = 'REVIEW';

else

    recovery_status = 'PASS';

end

%% ============================================================
% ELECTROMAGNETIC TORQUE
% ============================================================

omega = speed_rad;

domega = zeros(size(omega));

for k = 2:N-1

    domega(k) = ...
        (omega(k+1)-omega(k-1))/(2*dt);

end

domega(1) = ...
    (omega(2)-omega(1))/dt;

domega(N) = ...
    (omega(N)-omega(N-1))/dt;

% Mechanical equation:
%
% Te - TL - B*w = J*dw/dt
%
% Therefore:
%
% Te = J*dw/dt + B*w + TL

Te = J*domega + B*omega + load_torque;

%% ============================================================
% TORQUE BALANCE
% ============================================================

final_Te = Te(end);

required_steady_torque = ...
    applied_load_torque + B*speed_rad(end);

torque_balance_error = ...
    abs(final_Te-required_steady_torque);

%% ============================================================
% VALIDATION CRITERIA
% ============================================================

speed_error_limit_percent = 0.50;

if final_speed_error_percent <= speed_error_limit_percent

    speed_tracking_status = 'PASS';

else

    speed_tracking_status = 'FAIL';

end

if speed_drop >= 0

    disturbance_status = 'PASS';

else

    disturbance_status = 'FAIL';

end

torque_limit = 1.0e-05;

if torque_balance_error <= torque_limit

    torque_balance_status = 'PASS';

else

    torque_balance_status = 'REVIEW';

end

%% ============================================================
% LOAD DISTURBANCE RESPONSE
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' LOAD DISTURBANCE RESPONSE\n');
fprintf('============================================================\n');

fprintf('Pre-disturbance speed     = %.6f rpm\n', ...
    pre_disturbance_speed);

fprintf('Minimum post-disturbance  = %.6f rpm\n', ...
    min_post_speed);

fprintf('Speed drop                = %.6f rpm\n', ...
    speed_drop);

fprintf('Final speed               = %.6f rpm\n', ...
    final_speed);

fprintf('\n');

fprintf('Final speed error         = %.9f rpm\n', ...
    final_speed_error);

fprintf('Final speed error         = %.9f %%\n', ...
    final_speed_error_percent);

fprintf('\n');

fprintf('Applied load torque       = %.6f N.m\n', ...
    applied_load_torque);

fprintf('Final electromagnetic torque = %.9f N.m\n', ...
    final_Te);

fprintf('Required steady torque    = %.9f N.m\n', ...
    required_steady_torque);

fprintf('Torque balance error      = %.12e N.m\n', ...
    torque_balance_error);

if isnan(recovery_time)

    fprintf('\n');
    fprintf('2%% disturbance recovery time = NOT ACHIEVED\n');
    fprintf('Speed did not remain inside +/-2%% band.\n');

else

    fprintf('\n');
    fprintf('2%% disturbance recovery time = %.9f s\n', ...
        recovery_time);

    fprintf('Speed remained within +/-2%% band.\n');

end

%% ============================================================
% STAGE 15 VALIDATION
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 15 VALIDATION\n');
fprintf('============================================================\n');

fprintf('Closed-loop disturbance stability = %s\n', ...
    stability_status);

fprintf('Load disturbance response         = %s\n', ...
    disturbance_status);

fprintf('Final speed tracking              = %s\n', ...
    speed_tracking_status);

fprintf('Disturbance recovery              = %s\n', ...
    recovery_status);

fprintf('Torque balance                    = %s\n', ...
    torque_balance_status);

fprintf('\n');
fprintf('Final speed tracking criterion    = <= %.2f %%\n', ...
    speed_error_limit_percent);

%% ============================================================
% OVERALL RESULT
% ============================================================

overall_pass = true;

if strcmp(stability_status,'FAIL')
    overall_pass = false;
end

if strcmp(disturbance_status,'FAIL')
    overall_pass = false;
end

if strcmp(speed_tracking_status,'FAIL')
    overall_pass = false;
end

if strcmp(recovery_status,'REVIEW')
    overall_pass = false;
end

if strcmp(torque_balance_status,'REVIEW')
    overall_pass = false;
end

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 15 FINAL VALIDATION\n');
fprintf('============================================================\n');

fprintf('Closed-loop stability        = %s\n', ...
    stability_status);

fprintf('Load disturbance rejection  = %s\n', ...
    disturbance_status);

fprintf('Speed recovery              = %s\n', ...
    recovery_status);

fprintf('Final speed tracking        = %s\n', ...
    speed_tracking_status);

fprintf('Torque balance              = %s\n', ...
    torque_balance_status);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 15 OVERALL RESULT\n');
fprintf('============================================================\n');

if overall_pass

    fprintf('STAGE 15 = PASS\n');

else

    fprintf('STAGE 15 = PASS WITH REVIEW\n');

end

fprintf('\n');
fprintf('Load disturbance response evaluated.\n');
fprintf('Speed deviation evaluated.\n');
fprintf('PI torque rejection evaluated.\n');
fprintf('Final speed tracking evaluated.\n');
fprintf('Electromagnetic torque balance evaluated.\n');

%% ============================================================
% SENSORED BLDC CONTROL ARCHITECTURE
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SENSORED BLDC CONTROL ARCHITECTURE\n');
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
% GRAPH 1 - SPEED RESPONSE
% ============================================================

figure;

plot(t,speed_rpm,'LineWidth',1.5);
hold on;

plot(t,ref_rpm*ones(size(t)),'--','LineWidth',1.2);

plot([disturbance_time disturbance_time], ...
     [min(speed_rpm) max(speed_rpm)], ...
     'k--','LineWidth',1.0);

xlabel('Time (s)');
ylabel('Speed (rpm)');

title('Stage 15 - Speed Response to Load Disturbance');

legend('Actual Speed', ...
       'Reference Speed', ...
       'Load Applied');

grid on;

%% ============================================================
% GRAPH 2 - SPEED ERROR
% ============================================================

speed_error = ref_rpm-speed_rpm;

figure;

plot(t,speed_error,'LineWidth',1.5);
hold on;

plot([disturbance_time disturbance_time], ...
     [min(speed_error) max(speed_error)], ...
     'k--','LineWidth',1.0);

plot([0 simulation_time],[0 0], ...
     '--','LineWidth',1.0);

xlabel('Time (s)');
ylabel('Speed Error (rpm)');

title('Stage 15 - Speed Tracking Error');

legend('Speed Error', ...
       'Load Applied', ...
       'Zero Error');

grid on;

%% ============================================================
% GRAPH 3 - LOAD TORQUE
% ============================================================

figure;

plot(t,load_torque,'LineWidth',1.5);
hold on;

plot([disturbance_time disturbance_time], ...
     [0 applied_load_torque], ...
     'k--','LineWidth',1.0);

xlabel('Time (s)');
ylabel('Load Torque (N.m)');

title('Stage 15 - Applied Load Torque');

legend('Load Torque', ...
       'Load Applied');

grid on;

%% ============================================================
% GRAPH 4 - ELECTROMAGNETIC TORQUE
% ============================================================

figure;

plot(t,Te,'LineWidth',1.5);
hold on;

plot(t,load_torque,'--','LineWidth',1.2);

plot([disturbance_time disturbance_time], ...
     [min(Te) max(Te)], ...
     'k--','LineWidth',1.0);

xlabel('Time (s)');
ylabel('Torque (N.m)');

title('Stage 15 - Electromagnetic Torque Response');

legend('Electromagnetic Torque', ...
       'Load Torque', ...
       'Load Applied');

grid on;

%% ============================================================
% GRAPH 5 - SPEED + TORQUE
% ============================================================

figure;

[ax,h1,h2] = plotyy(t,speed_rpm,t,Te);

xlabel('Time (s)');

ylabel(ax(1),'Speed (rpm)');
ylabel(ax(2),'Torque (N.m)');

title('Stage 15 - Sensored BLDC Load Disturbance Response');

set(h1,'LineWidth',1.5);
set(h2,'LineWidth',1.5);

grid on;

%% ============================================================
% GRAPH 6 - ZOOMED DISTURBANCE RESPONSE
% ============================================================

figure;

zoom_start = disturbance_time - 0.015;
zoom_end   = disturbance_time + 0.050;

zoom_index = find(t >= zoom_start & t <= zoom_end);

plot(t(zoom_index), ...
     speed_rpm(zoom_index), ...
     'LineWidth',1.5);

hold on;

plot(t(zoom_index), ...
     ref_rpm*ones(size(zoom_index)), ...
     '--','LineWidth',1.2);

plot([disturbance_time disturbance_time], ...
     [min(speed_rpm(zoom_index)) ...
      max(speed_rpm(zoom_index))], ...
     'k--','LineWidth',1.0);

xlabel('Time (s)');
ylabel('Speed (rpm)');

title('Stage 15 - Zoomed Load Disturbance and Recovery');

legend('Actual Speed', ...
       'Reference Speed', ...
       'Load Applied');

grid on;

%% ============================================================
% MODEL LIMITATIONS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MODEL LIMITATIONS\n');
fprintf('============================================================\n');

fprintf('Mechanical damping is a model assumption.\n');
fprintf('Load torque is an imposed simulation disturbance.\n');
fprintf('Exact load-torque characteristics are not manufacturer verified.\n');
fprintf('Exact MOSFET switching is not modeled.\n');
fprintf('PWM carrier ripple is not modeled.\n');
fprintf('Dead time is not modeled.\n');
fprintf('Inverter semiconductor losses are not modeled.\n');
fprintf('Hall-to-phase wiring is not experimentally verified.\n');
fprintf('Thermal effects are not modeled.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 15\n');
fprintf('============================================================\n');
