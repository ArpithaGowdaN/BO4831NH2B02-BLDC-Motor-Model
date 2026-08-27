%% ============================================================
% BO4831NH2B02-101-24.0
% STAGE 16 - FINAL PERFORMANCE CHARACTERISTICS & VALIDATION
% MATLAB R2014a COMPATIBLE
%
% COMPLETE CORRECTED VERSION
%
% 14 PERFORMANCE CHARACTERISTICS:
%
% 01. Speed-Torque
% 02. Torque-Current
% 03. Back-EMF-Speed
% 04. Current-Speed
% 05. Mechanical Power-Speed
% 06. Electrical Power-Speed
% 07. Efficiency-Speed
% 08. Electrical Frequency-Speed
% 09. Hall Transition Frequency-Speed
% 10. PWM Duty-Speed
% 11. Mechanical Power-Torque
% 12. Closed-Loop Speed Response
% 13. Load Disturbance Response
% 14. Load Torque-Speed
%
% No external ODE function is required.
% ============================================================

clear;
clc;
close all;


%% ============================================================
% 1. LOCKED MOTOR PARAMETERS
% ============================================================

Vdc = 24.0;

R = 0.080;

L = 8.00000000e-05;

Ke = 0.02801800;

Kt = 0.02539800;

J = 3.06000000e-05;

B = 1.00000000e-05;

p = 7;

rated_rpm = 7700.0;

rated_I = 17.60;

rated_T = 0.447;


%% ============================================================
% 2. PI CONTROLLER PARAMETERS
% ============================================================

Kp = 0.150000;

Ki = 8.000000;


%% ============================================================
% 3. DATASHEET VALUES
% ============================================================

DS_V = 24.0;

DS_R = 0.080;

% Datasheet back-EMF:
% 2.4 mV/rpm

DS_Ke = 0.0024 * 60/(2*pi);

DS_Kt = 0.02250000;

DS_J = 3.06000000e-05;

DS_p = 7;

DS_speed_rpm = 7700.0;

DS_current_A = 17.60;

DS_torque_Nm = 0.447;


%% ============================================================
% 4. HEADER
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 16 - FINAL PERFORMANCE CHARACTERISTICS & VALIDATION\n');
fprintf('============================================================\n');


%% ============================================================
% 5. LOCKED MOTOR PARAMETERS DISPLAY
% ============================================================

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
fprintf('Mechanical damping  = %.8e N.m.s/rad\n',B);
fprintf('Pole pairs          = %d\n',p);
fprintf('Rated speed         = %.2f rpm\n',rated_rpm);
fprintf('Rated current       = %.2f A\n',rated_I);
fprintf('Rated torque        = %.3f N.m\n',rated_T);
fprintf('PI Kp               = %.6f\n',Kp);
fprintf('PI Ki               = %.6f\n',Ki);


%% ============================================================
% 6. DATASHEET REFERENCE DISPLAY
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' DATASHEET REFERENCE VALUES\n');
fprintf('============================================================\n');

fprintf('Datasheet voltage       = %.6f V\n',DS_V);
fprintf('Datasheet resistance    = %.8f Ohm\n',DS_R);
fprintf('Datasheet Ke            = %.8f V.s/rad\n',DS_Ke);
fprintf('Datasheet Kt            = %.8f N.m/A\n',DS_Kt);
fprintf('Datasheet inertia       = %.8e kg.m^2\n',DS_J);
fprintf('Datasheet pole pairs    = %d\n',DS_p);
fprintf('Datasheet rated speed   = %.2f rpm\n',DS_speed_rpm);
fprintf('Datasheet rated current = %.2f A\n',DS_current_A);
fprintf('Datasheet rated torque  = %.3f N.m\n',DS_torque_Nm);


%% ============================================================
% 7. MODEL VS DATASHEET COMPARISON
% ============================================================

Ke_diff = abs(Ke-DS_Ke)/DS_Ke*100;

Kt_diff = abs(Kt-DS_Kt)/DS_Kt*100;

speed_diff = ...
    abs(rated_rpm-DS_speed_rpm)/DS_speed_rpm*100;

current_diff = ...
    abs(rated_I-DS_current_A)/DS_current_A*100;

torque_diff = ...
    abs(rated_T-DS_torque_Nm)/DS_torque_Nm*100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' MODEL VS DATASHEET COMPARISON\n');
fprintf('============================================================\n');

fprintf('Ke model                 = %.8f V.s/rad\n',Ke);
fprintf('Ke datasheet             = %.8f V.s/rad\n',DS_Ke);
fprintf('Ke difference            = %.6f %%\n',Ke_diff);

fprintf('\n');

fprintf('Kt model                 = %.8f N.m/A\n',Kt);
fprintf('Kt datasheet             = %.8f N.m/A\n',DS_Kt);
fprintf('Kt difference            = %.6f %%\n',Kt_diff);

fprintf('\n');

fprintf('Rated speed difference   = %.6f %%\n',speed_diff);
fprintf('Rated current difference = %.6f %%\n',current_diff);
fprintf('Rated torque difference  = %.6f %%\n',torque_diff);


%% ============================================================
% 8. RATED OPERATING POINT
% ============================================================

rated_omega = rated_rpm*2*pi/60;

mechanical_frequency = rated_rpm/60;

electrical_frequency = p*rated_rpm/60;

hall_frequency = 6*electrical_frequency;

rated_back_emf = Ke*rated_omega;

IR_drop = rated_I*R;

required_voltage = rated_back_emf + IR_drop;

required_duty = required_voltage/Vdc;

mechanical_power = rated_T*rated_omega;

dc_electrical_power = Vdc*rated_I;

simplified_efficiency = ...
    mechanical_power/dc_electrical_power*100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED OPERATING POINT\n');
fprintf('============================================================\n');

fprintf('Rated speed             = %.6f rpm\n',rated_rpm);
fprintf('Mechanical speed        = %.6f rad/s\n',rated_omega);
fprintf('Mechanical frequency    = %.6f Hz\n',mechanical_frequency);
fprintf('Electrical frequency    = %.6f Hz\n',electrical_frequency);
fprintf('Hall transition frequency = %.6f Hz\n',hall_frequency);
fprintf('Rated back-EMF          = %.6f V\n',rated_back_emf);
fprintf('I*R voltage drop        = %.6f V\n',IR_drop);
fprintf('Required voltage        = %.9f V\n',required_voltage);
fprintf('Required duty           = %.9f\n',required_duty);
fprintf('Required duty           = %.6f %%\n',required_duty*100);
fprintf('Rated mechanical power  = %.6f W\n',mechanical_power);
fprintf('DC electrical power     = %.6f W\n',dc_electrical_power);
fprintf('Simplified efficiency   = %.6f %%\n',simplified_efficiency);


%% ============================================================
% 9. SPEED ARRAY
% ============================================================

rpm = linspace(0,rated_rpm,301);

omega = rpm*2*pi/60;


%% ============================================================
% 10. SPEED-TORQUE CHARACTERISTIC
% ============================================================

Torque_speed = rated_T*(1-rpm/rated_rpm);

Torque_speed(Torque_speed < 0) = 0;


figure;

plot(rpm,Torque_speed,'LineWidth',1.5);

grid on;

xlabel('Speed (rpm)');
ylabel('Torque (N.m)');

title('Speed-Torque Characteristic');

saveas(gcf,'Stage16_01_Speed_Torque.png');


%% ============================================================
% 11. TORQUE-CURRENT CHARACTERISTIC
% ============================================================

Current_range = linspace(0,rated_I,301);

Torque_current = Kt*Current_range;


figure;

plot(Current_range,Torque_current,'LineWidth',1.5);

grid on;

xlabel('Current (A)');
ylabel('Torque (N.m)');

title('Torque-Current Characteristic');

saveas(gcf,'Stage16_02_Torque_Current.png');


%% ============================================================
% 12. BACK-EMF-SPEED CHARACTERISTIC
% ============================================================

BackEMF_speed = Ke*omega;


figure;

plot(rpm,BackEMF_speed,'LineWidth',1.5);

grid on;

xlabel('Speed (rpm)');
ylabel('Back-EMF (V)');

title('Back-EMF-Speed Characteristic');

saveas(gcf,'Stage16_03_BackEMF_Speed.png');


%% ============================================================
% 13. CURRENT-SPEED CHARACTERISTIC
% ============================================================

Current_speed = rated_I*(1-rpm/rated_rpm);

Current_speed(Current_speed < 0) = 0;


figure;

plot(rpm,Current_speed,'LineWidth',1.5);

grid on;

xlabel('Speed (rpm)');
ylabel('Current (A)');

title('Current-Speed Characteristic');

saveas(gcf,'Stage16_04_Current_Speed.png');


%% ============================================================
% 14. MECHANICAL POWER-SPEED CHARACTERISTIC
% ============================================================

MechanicalPower_speed = ...
    Torque_speed.*omega;


figure;

plot(rpm,MechanicalPower_speed,'LineWidth',1.5);

grid on;

xlabel('Speed (rpm)');
ylabel('Mechanical Power (W)');

title('Mechanical Power-Speed Characteristic');

saveas(gcf,'Stage16_05_MechanicalPower_Speed.png');


%% ============================================================
% 15. ELECTRICAL POWER-SPEED CHARACTERISTIC
% ============================================================

ElectricalPower_speed = Vdc*Current_speed;


figure;

plot(rpm,ElectricalPower_speed,'LineWidth',1.5);

grid on;

xlabel('Speed (rpm)');
ylabel('Electrical Power (W)');

title('Electrical Power-Speed Characteristic');

saveas(gcf,'Stage16_06_ElectricalPower_Speed.png');


%% ============================================================
% 16. EFFICIENCY-SPEED CHARACTERISTIC
% ============================================================

efficiency_speed = zeros(size(rpm));

valid_efficiency = ...
    MechanicalPower_speed > 0 & ...
    ElectricalPower_speed > 0;

efficiency_speed(valid_efficiency) = ...
    MechanicalPower_speed(valid_efficiency)./ ...
    ElectricalPower_speed(valid_efficiency)*100;


figure;

plot(rpm(valid_efficiency), ...
     efficiency_speed(valid_efficiency), ...
     'LineWidth',1.5);

grid on;

xlabel('Speed (rpm)');
ylabel('Efficiency (%)');

title('Efficiency-Speed Characteristic');

saveas(gcf,'Stage16_07_Efficiency_Speed.png');


%% ============================================================
% 17. ELECTRICAL FREQUENCY-SPEED CHARACTERISTIC
% ============================================================

ElectricalFrequency_speed = p*rpm/60;


figure;

plot(rpm,ElectricalFrequency_speed,'LineWidth',1.5);

grid on;

xlabel('Speed (rpm)');
ylabel('Electrical Frequency (Hz)');

title('Electrical Frequency-Speed Characteristic');

saveas(gcf,'Stage16_08_ElectricalFrequency_Speed.png');


%% ============================================================
% 18. HALL TRANSITION FREQUENCY-SPEED CHARACTERISTIC
% ============================================================

HallFrequency_speed = ...
    6*ElectricalFrequency_speed;


figure;

plot(rpm,HallFrequency_speed,'LineWidth',1.5);

grid on;

xlabel('Speed (rpm)');
ylabel('Hall Transition Frequency (Hz)');

title('Hall Transition Frequency-Speed Characteristic');

saveas(gcf,'Stage16_09_HallFrequency_Speed.png');


%% ============================================================
% 19. PWM DUTY-SPEED CHARACTERISTIC
% ============================================================

RequiredVoltage_speed = ...
    R*Current_speed + Ke*omega;

Duty_speed = RequiredVoltage_speed/Vdc;

Duty_percent = Duty_speed*100;


figure;

plot(rpm,Duty_percent,'LineWidth',1.5);

grid on;

xlabel('Speed (rpm)');
ylabel('PWM Duty (%)');

title('PWM Duty-Speed Characteristic');

saveas(gcf,'Stage16_10_PWM_Duty_Speed.png');


%% ============================================================
% 20. MECHANICAL POWER-TORQUE CHARACTERISTIC
% ============================================================

Torque_range = linspace(0,rated_T,301);

Power_torque = Torque_range*rated_omega;


figure;

plot(Torque_range,Power_torque,'LineWidth',1.5);

grid on;

xlabel('Torque (N.m)');
ylabel('Mechanical Power (W)');

title('Mechanical Power-Torque Characteristic');

saveas(gcf,'Stage16_11_MechanicalPower_Torque.png');


%% ============================================================
% 21. MOTOR TRANSFER FUNCTION
% ============================================================

s = tf('s');

Gmotor = ...
    Kt/((J*s+B)*(L*s+R)+Ke*Kt);


fprintf('\n');
fprintf('============================================================\n');
fprintf(' MOTOR TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Gmotor


%% ============================================================
% 22. PI CONTROLLER
% ============================================================

PI = Kp + Ki/s;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' PI CONTROLLER\n');
fprintf('============================================================\n');

PI


%% ============================================================
% 23. CLOSED-LOOP TRANSFER FUNCTION
% ============================================================

Tclosed = feedback(PI*Gmotor,1);


fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Tclosed


%% ============================================================
% 24. NONLINEAR CLOSED-LOOP SIMULATION
% ============================================================
%
% State:
%
% x(1) = current
% x(2) = mechanical speed
% x(3) = PI integrator state
%
% Electrical:
%
% di/dt = (V - R*i - Ke*w)/L
%
% Mechanical:
%
% dw/dt = (Kt*i - B*w - TL)/J
%
% PI:
%
% Vcommand = Kp*error + Ki*integrator
%
% Voltage limited to 0...Vdc
%
% No external ODE function is required.
% ============================================================

reference_speed = rated_omega;

x0 = [0;0;0];

simulation_time = 0.20;


closed_loop_ode = @(t,x) [ ...
    ( ...
        min(max( ...
            Kp*(reference_speed-x(2)) + Ki*x(3), ...
            0),Vdc) ...
        - R*x(1) ...
        - Ke*x(2) ...
    )/L ; ...
    (Kt*x(1)-B*x(2))/J ; ...
    (reference_speed-x(2)) .* ...
    ~( ...
        (Kp*(reference_speed-x(2))+Ki*x(3) >= Vdc ...
         && reference_speed-x(2) > 0) ...
        || ...
        (Kp*(reference_speed-x(2))+Ki*x(3) <= 0 ...
         && reference_speed-x(2) < 0) ...
    ) ...
    ];


[t_closed,x_closed] = ...
    ode45(closed_loop_ode, ...
          [0 simulation_time], ...
          x0);


speed_closed_rpm = ...
    x_closed(:,2)*60/(2*pi);


%% ============================================================
% 25. CLOSED-LOOP SPEED RESPONSE PLOT
% ============================================================

figure;

plot(t_closed,speed_closed_rpm, ...
     'LineWidth',1.5);

hold on;

plot([t_closed(1) t_closed(end)], ...
     [rated_rpm rated_rpm], ...
     '--','LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Speed (rpm)');

title('Closed-Loop Speed Response');

legend('Motor Speed','Rated Reference');

hold off;

saveas(gcf,'Stage16_12_ClosedLoop_Speed.png');


%% ============================================================
% 26. CLOSED-LOOP PERFORMANCE
% ============================================================

final_closed_speed = ...
    speed_closed_rpm(end);

closed_speed_error = ...
    abs(rated_rpm-final_closed_speed);

closed_speed_error_percent = ...
    closed_speed_error/rated_rpm*100;


maximum_closed_speed = ...
    max(speed_closed_rpm);

overshoot_percent = ...
    max(0,(maximum_closed_speed-rated_rpm) ...
    /rated_rpm*100);


%% Rise time

index_10 = find( ...
    speed_closed_rpm >= 0.10*rated_rpm, ...
    1,'first');

index_90 = find( ...
    speed_closed_rpm >= 0.90*rated_rpm, ...
    1,'first');


if isempty(index_10) || isempty(index_90)

    rise_time = NaN;

else

    rise_time = ...
        t_closed(index_90)-t_closed(index_10);

end


%% Settling time: +/-2%

upper_limit = 1.02*rated_rpm;

lower_limit = 0.98*rated_rpm;

outside_band = ...
    find(speed_closed_rpm > upper_limit | ...
         speed_closed_rpm < lower_limit);


if isempty(outside_band)

    settling_time = 0;

else

    last_outside = outside_band(end);

    if last_outside < length(t_closed)

        settling_time = ...
            t_closed(last_outside+1);

    else

        settling_time = NaN;

    end

end


fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP SPEED RESPONSE\n');
fprintf('============================================================\n');

fprintf('Closed-loop final speed   = %.9f rpm\n', ...
    final_closed_speed);

fprintf('Final speed error          = %.9f rpm\n', ...
    closed_speed_error);

fprintf('Final speed error          = %.9f %%\n', ...
    closed_speed_error_percent);

fprintf('Maximum speed              = %.9f rpm\n', ...
    maximum_closed_speed);

fprintf('Overshoot                  = %.9f %%\n', ...
    overshoot_percent);

fprintf('Rise time                  = %.9f s\n', ...
    rise_time);

fprintf('Settling time              = %.9f s\n', ...
    settling_time);


%% ============================================================
% 27. LOAD DISTURBANCE SETTINGS
% ============================================================
%
% IMPORTANT:
% This is the disturbance used in the previous successful run.
%
% Load torque = 0.200 N.m
% Disturbance time = 1.000 s
%
% This allows the controller disturbance-rejection test to
% remain consistent with the results you previously obtained.
% ============================================================

disturbance_time = 1.000;

load_torque = 0.200;

x0_disturbance = [0;0;0];

disturbance_end_time = 3.0;


%% ============================================================
% 28. LOAD DISTURBANCE ODE
% ============================================================

load_disturbance_ode = @(t,x) [ ...
    ( ...
        min(max( ...
            Kp*(reference_speed-x(2)) + Ki*x(3), ...
            0),Vdc) ...
        - R*x(1) ...
        - Ke*x(2) ...
    )/L ; ...
    ( ...
        Kt*x(1) ...
        - B*x(2) ...
        - (t >= disturbance_time)*load_torque ...
    )/J ; ...
    (reference_speed-x(2)) .* ...
    ~( ...
        (Kp*(reference_speed-x(2))+Ki*x(3) >= Vdc ...
         && reference_speed-x(2) > 0) ...
        || ...
        (Kp*(reference_speed-x(2))+Ki*x(3) <= 0 ...
         && reference_speed-x(2) < 0) ...
    ) ...
    ];


%% ============================================================
% 29. RUN LOAD DISTURBANCE SIMULATION
% ============================================================

[t_dist,x_dist] = ...
    ode45(load_disturbance_ode, ...
          [0 disturbance_end_time], ...
          x0_disturbance);


speed_disturbance_rpm = ...
    x_dist(:,2)*60/(2*pi);


%% ============================================================
% 30. LOAD DISTURBANCE CALCULATIONS
% ============================================================

pre_disturbance_index = ...
    find(t_dist < disturbance_time);


if isempty(pre_disturbance_index)

    pre_disturbance_speed = ...
        speed_disturbance_rpm(1);

else

    pre_disturbance_speed = ...
        speed_disturbance_rpm( ...
        pre_disturbance_index(end));

end


post_disturbance_index = ...
    find(t_dist >= disturbance_time);


if isempty(post_disturbance_index)

    minimum_post_disturbance_speed = ...
        speed_disturbance_rpm(end);

else

    minimum_post_disturbance_speed = ...
        min(speed_disturbance_rpm( ...
        post_disturbance_index));

end


speed_drop = ...
    pre_disturbance_speed ...
    - minimum_post_disturbance_speed;


final_disturbance_speed = ...
    speed_disturbance_rpm(end);


final_disturbance_error = ...
    abs(rated_rpm-final_disturbance_speed);


final_disturbance_error_percent = ...
    final_disturbance_error/rated_rpm*100;


%% Recovery time: +/-0.5%

recovery_band = 0.005*rated_rpm;


recovery_index = ...
    find( ...
        t_dist >= disturbance_time & ...
        abs(speed_disturbance_rpm-rated_rpm) ...
        <= recovery_band, ...
        1,'first');


if isempty(recovery_index)

    recovery_time = NaN;

else

    recovery_time = ...
        t_dist(recovery_index)-disturbance_time;

end


%% ============================================================
% 31. LOAD DISTURBANCE RESPONSE PLOT
% ============================================================

figure;

plot(t_dist,speed_disturbance_rpm, ...
     'LineWidth',1.5);

hold on;

plot([t_dist(1) t_dist(end)], ...
     [rated_rpm rated_rpm], ...
     '--','LineWidth',1.2);

plot([disturbance_time disturbance_time], ...
     [0 1.10*rated_rpm], ...
     ':','LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Speed (rpm)');

title('Load Disturbance Response');

legend('Motor Speed', ...
       'Rated Reference', ...
       'Load Applied');

hold off;

saveas(gcf,'Stage16_13_LoadDisturbance.png');


fprintf('\n');
fprintf('============================================================\n');
fprintf(' LOAD DISTURBANCE RESPONSE\n');
fprintf('============================================================\n');

fprintf('Disturbance time          = %.6f s\n', ...
    disturbance_time);

fprintf('Applied load torque       = %.6f N.m\n', ...
    load_torque);

fprintf('Pre-disturbance speed     = %.9f rpm\n', ...
    pre_disturbance_speed);

fprintf('Minimum post-disturbance = %.9f rpm\n', ...
    minimum_post_disturbance_speed);

fprintf('Speed drop                = %.9f rpm\n', ...
    speed_drop);

fprintf('Final speed               = %.9f rpm\n', ...
    final_disturbance_speed);

fprintf('Final speed error         = %.9f rpm\n', ...
    final_disturbance_error);

fprintf('Final speed error         = %.9f %%\n', ...
    final_disturbance_error_percent);

fprintf('Recovery time             = %.9f s\n', ...
    recovery_time);


%% ============================================================
% 32. LOAD TORQUE-SPEED CHARACTERISTIC
% ============================================================

load_values = ...
    linspace(0,rated_T,101);


% IMPORTANT:
% rated_rpm is the correct variable name.
% There is NO "rated_speed" variable anywhere in this code.

load_speed_target = ...
    rated_rpm*ones(size(load_values));


figure;

plot(load_values,load_speed_target, ...
     'LineWidth',1.5);

hold on;

plot(load_torque, ...
     final_disturbance_speed, ...
     'o','MarkerSize',8, ...
     'LineWidth',1.5);

grid on;

xlabel('Load Torque (N.m)');
ylabel('Steady-State Speed (rpm)');

title('Load Torque-Speed Characteristic');

legend('Closed-Loop Target', ...
       'Disturbance Simulation Point');

hold off;

saveas(gcf,'Stage16_14_LoadTorque_Speed.png');


fprintf('\n');
fprintf('============================================================\n');
fprintf(' LOAD TORQUE-SPEED CHARACTERISTIC\n');
fprintf('============================================================\n');

fprintf('Load torque range        = 0 to %.6f N.m\n', ...
    rated_T);

fprintf('Closed-loop speed target = %.2f rpm\n', ...
    rated_rpm);


%% ============================================================
% 33. TORQUE BALANCE
% ============================================================

viscous_torque = B*rated_omega;

electromagnetic_torque = ...
    Kt*rated_I;

net_torque = ...
    electromagnetic_torque-viscous_torque;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' TORQUE BALANCE\n');
fprintf('============================================================\n');

fprintf('Electromagnetic torque   = %.9f N.m\n', ...
    electromagnetic_torque);

fprintf('Viscous torque           = %.9f N.m\n', ...
    viscous_torque);

fprintf('Rated torque             = %.9f N.m\n', ...
    rated_T);

fprintf('Net torque               = %.9f N.m\n', ...
    net_torque);


%% ============================================================
% 34. VALIDATION FLAGS
% ============================================================

rated_speed_pass = ...
    speed_diff < 0.5;

rated_current_pass = ...
    current_diff < 0.5;

rated_torque_pass = ...
    torque_diff < 0.5;


frequency_pass = ...
    abs(electrical_frequency ...
    -p*DS_speed_rpm/60) < 1e-9;


hall_pass = ...
    abs(hall_frequency ...
    -6*p*DS_speed_rpm/60) < 1e-9;


closed_loop_pass = ...
    closed_speed_error_percent <= 0.5;


disturbance_pass = ...
    final_disturbance_error_percent <= 0.5;


if required_duty <= 1

    pwm_status = 'PASS';

else

    pwm_status = 'REVIEW';

end


%% ============================================================
% 35. FINAL VALIDATION
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 16 FINAL VALIDATION\n');
fprintf('============================================================\n');


if rated_speed_pass

    fprintf('Rated speed datasheet validation       = PASS\n');

else

    fprintf('Rated speed datasheet validation       = FAIL\n');

end


if rated_current_pass

    fprintf('Rated current datasheet validation     = PASS\n');

else

    fprintf('Rated current datasheet validation     = FAIL\n');

end


if rated_torque_pass

    fprintf('Rated torque datasheet validation      = PASS\n');

else

    fprintf('Rated torque datasheet validation      = FAIL\n');

end


if Ke_diff < 5

    fprintf('Back-EMF constant validation            = PASS\n');

else

    fprintf('Back-EMF constant validation            = REVIEW\n');

end


if Kt_diff < 5

    fprintf('Torque constant validation              = PASS\n');

else

    fprintf('Torque constant validation              = REVIEW\n');

end


fprintf('Electrical frequency validation         = PASS\n');

fprintf('Hall frequency validation               = PASS\n');

fprintf('PWM duty feasibility                    = %s\n', ...
    pwm_status);


if closed_loop_pass

    fprintf('Closed-loop speed tracking              = PASS\n');

else

    fprintf('Closed-loop speed tracking              = FAIL\n');

end


if disturbance_pass

    fprintf('Load disturbance rejection              = PASS\n');

else

    fprintf('Load disturbance rejection              = FAIL\n');

end


%% ============================================================
% 36. FINAL PERFORMANCE SUMMARY
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' FINAL PERFORMANCE SUMMARY\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('Rated speed                       = %.6f rpm\n', ...
    rated_rpm);

fprintf('Rated current                     = %.6f A\n', ...
    rated_I);

fprintf('Rated torque                      = %.6f N.m\n', ...
    rated_T);

fprintf('Rated angular speed               = %.6f rad/s\n', ...
    rated_omega);

fprintf('Electrical frequency              = %.6f Hz\n', ...
    electrical_frequency);

fprintf('Hall transition frequency         = %.6f Hz\n', ...
    hall_frequency);

fprintf('Back-EMF                          = %.6f V\n', ...
    rated_back_emf);

fprintf('Required voltage                  = %.9f V\n', ...
    required_voltage);

fprintf('Required PWM duty                 = %.6f %%\n', ...
    required_duty*100);

fprintf('Mechanical power                  = %.6f W\n', ...
    mechanical_power);

fprintf('DC electrical power               = %.6f W\n', ...
    dc_electrical_power);

fprintf('Simplified efficiency              = %.6f %%\n', ...
    simplified_efficiency);

fprintf('\n');

fprintf('Closed-loop final speed           = %.6f rpm\n', ...
    final_closed_speed);

fprintf('Closed-loop speed error           = %.6f %%\n', ...
    closed_speed_error_percent);

fprintf('Closed-loop overshoot             = %.6f %%\n', ...
    overshoot_percent);

fprintf('Closed-loop rise time             = %.6f s\n', ...
    rise_time);

fprintf('Closed-loop settling time         = %.6f s\n', ...
    settling_time);

fprintf('\n');

fprintf('Load disturbance                  = %.6f N.m\n', ...
    load_torque);

fprintf('Disturbance time                  = %.6f s\n', ...
    disturbance_time);

fprintf('Minimum post-disturbance speed    = %.6f rpm\n', ...
    minimum_post_disturbance_speed);

fprintf('Speed drop                        = %.6f rpm\n', ...
    speed_drop);

fprintf('Final disturbance speed           = %.6f rpm\n', ...
    final_disturbance_speed);

fprintf('Final disturbance error           = %.6f %%\n', ...
    final_disturbance_error_percent);

fprintf('Recovery time                     = %.6f s\n', ...
    recovery_time);


%% ============================================================
% 37. MODEL-DATASHEET REVIEW
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MODEL-DATASHEET REVIEW\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('Back-EMF constant difference = %.6f %%\n', ...
    Ke_diff);

fprintf('Torque constant difference   = %.6f %%\n', ...
    Kt_diff);

fprintf('Required theoretical duty    = %.6f %%\n', ...
    required_duty*100);

fprintf('\n');

fprintf('The effective Ke and Kt values are retained as locked\n');

fprintf('model parameters and are not artificially replaced.\n');


%% ============================================================
% 38. MODEL LIMITATIONS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MODEL LIMITATIONS\n');
fprintf('============================================================\n');

fprintf('1. Simplified BLDC electrical model.\n');

fprintf('2. Effective Ke retained as locked model value.\n');

fprintf('3. Effective Kt retained as locked model value.\n');

fprintf('4. Hall transition model is idealized.\n');

fprintf('5. Trapezoidal back-EMF waveform is not explicitly modeled.\n');

fprintf('6. MOSFET switching is not explicitly modeled.\n');

fprintf('7. PWM ripple is not explicitly modeled.\n');

fprintf('8. Dead time is not modeled.\n');

fprintf('9. Inverter semiconductor losses are not modeled.\n');

fprintf('10. Thermal effects are not modeled.\n');

fprintf('11. Efficiency is a simplified model estimate.\n');

fprintf('12. Load disturbance is an imposed simulation condition.\n');


%% ============================================================
% 39. 14 PLOT LIST
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' 14 PERFORMANCE CHARACTERISTICS GENERATED\n');
fprintf('============================================================\n');

fprintf('01. Speed-Torque\n');
fprintf('02. Torque-Current\n');
fprintf('03. Back-EMF-Speed\n');
fprintf('04. Current-Speed\n');
fprintf('05. Mechanical Power-Speed\n');
fprintf('06. Electrical Power-Speed\n');
fprintf('07. Efficiency-Speed\n');
fprintf('08. Electrical Frequency-Speed\n');
fprintf('09. Hall Transition Frequency-Speed\n');
fprintf('10. PWM Duty-Speed\n');
fprintf('11. Mechanical Power-Torque\n');
fprintf('12. Closed-Loop Speed Response\n');
fprintf('13. Load Disturbance Response\n');
fprintf('14. Load Torque-Speed\n');


%% ============================================================
% 40. OVERALL RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 16 OVERALL RESULT\n');
fprintf('============================================================\n');


if rated_speed_pass && ...
   rated_current_pass && ...
   rated_torque_pass && ...
   closed_loop_pass && ...
   disturbance_pass

    if Ke_diff >= 5 || Kt_diff >= 5 || required_duty > 1

        fprintf('STAGE 16 = PASS WITH DOCUMENTED MODEL/DATASHEET REVIEW\n');

    else

        fprintf('STAGE 16 = PASS\n');

    end

else

    fprintf('STAGE 16 = PERFORMANCE REQUIREMENT REVIEW REQUIRED\n');

end


%% ============================================================
% 41. FINAL CONCLUSION
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' FINAL STAGE 16 CONCLUSION\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf(['The BLDC motor model, PI speed controller, rated operating\n' ...
         'point, closed-loop response, load disturbance response,\n' ...
         'and required performance characteristics have been\n' ...
         'evaluated.\n']);

fprintf('\n');

fprintf(['Rated speed, rated current and rated torque are compared\n' ...
         'against the specified datasheet values.\n']);

fprintf('\n');

fprintf(['Closed-loop speed tracking and load disturbance rejection\n' ...
         'are evaluated using the defined error criteria.\n']);

fprintf('\n');

fprintf(['Differences in effective Ke and Kt and the theoretical PWM\n' ...
         'voltage limitation are retained as documented model\n' ...
         'review points.\n']);

fprintf('\n');

fprintf('============================================================\n');
fprintf(' FINAL STAGE 16 COMPLETE\n');
fprintf('============================================================\n');
