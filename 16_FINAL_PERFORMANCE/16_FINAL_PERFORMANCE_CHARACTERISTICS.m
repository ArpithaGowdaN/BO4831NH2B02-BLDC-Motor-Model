%% ============================================================
% BO4831NH2B02-101-24.0
% STAGE 16 - FINAL PERFORMANCE CHARACTERISTICS & VALIDATION
% MATLAB R2014a COMPATIBLE
% ============================================================

clear;
clc;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 16 - FINAL PERFORMANCE CHARACTERISTICS & VALIDATION\n');
fprintf('============================================================\n');


%% ============================================================
% 1. LOCKED MOTOR PARAMETERS
% ============================================================

Vdc = 24.0;
R   = 0.080;
L   = 8.0e-5;

Ke  = 0.02801800;
Kt  = 0.02539800;

J   = 3.060e-5;
B   = 1.0e-5;

p   = 7;

rated_rpm = 7700;
rated_I   = 17.60;
rated_T   = 0.447;

% PI controller
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
fprintf('Mechanical damping  = %.8e N.m.s/rad\n',B);
fprintf('Pole pairs          = %d\n',p);
fprintf('Rated speed         = %.2f rpm\n',rated_rpm);
fprintf('Rated current       = %.2f A\n',rated_I);
fprintf('Rated torque        = %.3f N.m\n',rated_T);
fprintf('PI Kp               = %.6f\n',Kp);
fprintf('PI Ki               = %.6f\n',Ki);


%% ============================================================
% 2. DATASHEET REFERENCE VALUES
% ============================================================

ds_V  = 24.0;
ds_R  = 0.080;

% Datasheet back-EMF constant
% Given back EMF = 2.4 mV/rpm

ds_Ke = 0.0024 * 60/(2*pi);

ds_Kt  = 0.0225;
ds_J   = 3.060e-5;
ds_p   = 7;

ds_rpm = 7700;
ds_I   = 17.60;
ds_T   = 0.447;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' DATASHEET REFERENCE VALUES\n');
fprintf('============================================================\n');

fprintf('Datasheet voltage       = %.6f V\n',ds_V);
fprintf('Datasheet resistance    = %.8f Ohm\n',ds_R);
fprintf('Datasheet Ke            = %.8f V.s/rad\n',ds_Ke);
fprintf('Datasheet Kt            = %.8f N.m/A\n',ds_Kt);
fprintf('Datasheet inertia       = %.8e kg.m^2\n',ds_J);
fprintf('Datasheet pole pairs    = %d\n',ds_p);
fprintf('Datasheet rated speed   = %.2f rpm\n',ds_rpm);
fprintf('Datasheet rated current = %.2f A\n',ds_I);
fprintf('Datasheet rated torque  = %.3f N.m\n',ds_T);


%% ============================================================
% 3. MODEL VS DATASHEET COMPARISON
% ============================================================

Ke_diff = abs(Ke-ds_Ke)/ds_Ke*100;
Kt_diff = abs(Kt-ds_Kt)/ds_Kt*100;

rpm_diff = abs(rated_rpm-ds_rpm)/ds_rpm*100;
I_diff   = abs(rated_I-ds_I)/ds_I*100;
T_diff   = abs(rated_T-ds_T)/ds_T*100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' MODEL VS DATASHEET COMPARISON\n');
fprintf('============================================================\n');

fprintf('Ke model                 = %.8f V.s/rad\n',Ke);
fprintf('Ke datasheet             = %.8f V.s/rad\n',ds_Ke);
fprintf('Ke difference            = %.6f %%\n',Ke_diff);

fprintf('\n');

fprintf('Kt model                 = %.8f N.m/A\n',Kt);
fprintf('Kt datasheet             = %.8f N.m/A\n',ds_Kt);
fprintf('Kt difference            = %.6f %%\n',Kt_diff);

fprintf('\n');

fprintf('Rated speed difference   = %.6f %%\n',rpm_diff);
fprintf('Rated current difference = %.6f %%\n',I_diff);
fprintf('Rated torque difference  = %.6f %%\n',T_diff);


%% ============================================================
% 4. BASIC SPEED AND CURRENT ARRAYS
% ============================================================

rpm = linspace(0,rated_rpm,300);

omega = rpm*2*pi/60;


%% ============================================================
% 5. SPEED-TORQUE CHARACTERISTIC
% ============================================================

T_speed = rated_T*(1-rpm/rated_rpm);

% Avoid negative torque
T_speed(T_speed < 0) = 0;


figure;

plot(rpm,T_speed,'LineWidth',2);

grid on;

xlabel('Speed (rpm)');
ylabel('Torque (N.m)');

title('Speed-Torque Characteristic');


%% ============================================================
% 6. TORQUE-CURRENT CHARACTERISTIC
% ============================================================

I_range = linspace(0,rated_I,300);

T_current = Kt*I_range;


figure;

plot(I_range,T_current,'LineWidth',2);

grid on;

xlabel('Current (A)');
ylabel('Torque (N.m)');

title('Torque-Current Characteristic');


%% ============================================================
% 7. BACK-EMF-SPEED CHARACTERISTIC
% ============================================================

BackEMF = Ke*omega;


figure;

plot(rpm,BackEMF,'LineWidth',2);

grid on;

xlabel('Speed (rpm)');
ylabel('Back EMF (V)');

title('Back EMF-Speed Characteristic');


%% ============================================================
% 8. CURRENT-SPEED CHARACTERISTIC
% ============================================================

Current_speed = rated_I*(1-rpm/rated_rpm);

Current_speed(Current_speed < 0) = 0;


figure;

plot(rpm,Current_speed,'LineWidth',2);

grid on;

xlabel('Speed (rpm)');
ylabel('Current (A)');

title('Current-Speed Characteristic');


%% ============================================================
% 9. MECHANICAL POWER-SPEED CHARACTERISTIC
% ============================================================

MechanicalPower = T_speed.*omega;


figure;

plot(rpm,MechanicalPower,'LineWidth',2);

grid on;

xlabel('Speed (rpm)');
ylabel('Mechanical Power (W)');

title('Mechanical Power-Speed Characteristic');


%% ============================================================
% 10. ELECTRICAL POWER-SPEED CHARACTERISTIC
% ============================================================

ElectricalPower = Vdc.*Current_speed;


figure;

plot(rpm,ElectricalPower,'LineWidth',2);

grid on;

xlabel('Speed (rpm)');
ylabel('Electrical Power (W)');

title('Electrical Power-Speed Characteristic');


%% ============================================================
% 11. EFFICIENCY-SPEED CHARACTERISTIC
% ============================================================

Efficiency = zeros(size(rpm));

for k = 1:length(rpm)

    if ElectricalPower(k) > 0

        Efficiency(k) = ...
            MechanicalPower(k)/ElectricalPower(k)*100;

    else

        Efficiency(k) = 0;

    end

end


figure;

plot(rpm,Efficiency,'LineWidth',2);

grid on;

xlabel('Speed (rpm)');
ylabel('Efficiency (%)');

title('Efficiency-Speed Characteristic');


%% ============================================================
% 12. ELECTRICAL FREQUENCY-SPEED CHARACTERISTIC
% ============================================================

ElectricalFrequency = p*rpm/60;


figure;

plot(rpm,ElectricalFrequency,'LineWidth',2);

grid on;

xlabel('Speed (rpm)');
ylabel('Electrical Frequency (Hz)');

title('Electrical Frequency-Speed Characteristic');


%% ============================================================
% 13. HALL TRANSITION FREQUENCY-SPEED CHARACTERISTIC
% ============================================================

HallFrequency = 6*ElectricalFrequency;


figure;

plot(rpm,HallFrequency,'LineWidth',2);

grid on;

xlabel('Speed (rpm)');
ylabel('Hall Transition Frequency (Hz)');

title('Hall Transition Frequency-Speed Characteristic');


%% ============================================================
% 14. PWM DUTY-SPEED CHARACTERISTIC
% ============================================================

RequiredVoltage = R*Current_speed + Ke*omega;

RequiredDuty = RequiredVoltage/Vdc;


figure;

plot(rpm,RequiredDuty*100,'LineWidth',2);

grid on;

xlabel('Speed (rpm)');
ylabel('PWM Duty (%)');

title('PWM Duty-Speed Characteristic');


%% ============================================================
% 15. MECHANICAL POWER-TORQUE CHARACTERISTIC
% ============================================================

Torque_range = linspace(0,rated_T,300);

Power_torque = ...
    Torque_range*rated_rpm*2*pi/60;


figure;

plot(Torque_range,Power_torque,'LineWidth',2);

grid on;

xlabel('Torque (N.m)');
ylabel('Mechanical Power (W)');

title('Mechanical Power-Torque Characteristic');


%% ============================================================
% 16. RATED OPERATING POINT
% ============================================================

rated_w = rated_rpm*2*pi/60;

rated_fe = p*rated_rpm/60;

rated_E = Ke*rated_w;

IR_drop = rated_I*R;

RequiredVoltage_rated = rated_E + IR_drop;

RequiredDuty_rated = RequiredVoltage_rated/Vdc;

CalculatedTorque = Kt*rated_I;

RatedMechanicalPower = rated_T*rated_w;

RatedElectricalPower = Vdc*rated_I;

SimplifiedEfficiency = ...
    RatedMechanicalPower/RatedElectricalPower*100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED OPERATING POINT\n');
fprintf('============================================================\n');

fprintf('Rated speed             = %.6f rpm\n',rated_rpm);

fprintf('Mechanical speed        = %.6f rad/s\n',rated_w);

fprintf('Mechanical frequency    = %.6f Hz\n',rated_rpm/60);

fprintf('Electrical frequency    = %.6f Hz\n',rated_fe);

fprintf('Electrical speed        = %.6f rad/s\n',rated_fe*2*pi);

fprintf('Rated back-EMF          = %.6f V\n',rated_E);

fprintf('I*R voltage drop        = %.6f V\n',IR_drop);

fprintf('Required voltage        = %.9f V\n',RequiredVoltage_rated);

fprintf('Required duty           = %.9f\n',RequiredDuty_rated);

fprintf('Required duty           = %.6f %%\n', ...
    100*RequiredDuty_rated);

fprintf('Calculated torque       = %.9f N.m\n',CalculatedTorque);

fprintf('Rated mechanical power  = %.9f W\n',RatedMechanicalPower);

fprintf('DC electrical power     = %.9f W\n',RatedElectricalPower);

fprintf('Simplified efficiency   = %.6f %%\n', ...
    SimplifiedEfficiency);


%% ============================================================
% 17. BLDC MOTOR TRANSFER FUNCTION
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
% 18. PI CONTROLLER
% ============================================================

PI = Kp + Ki/s;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' PI CONTROLLER\n');
fprintf('============================================================\n');

PI


%% ============================================================
% 19. CLOSED-LOOP SPEED RESPONSE
% ============================================================

Tclosed = feedback(PI*Gmotor,1);


figure;

step(Tclosed);

grid on;

xlabel('Time (s)');
ylabel('Normalized Speed');

title('Closed-Loop Speed Response');


[y,t] = step(Tclosed);

FinalSpeed = y(end);

DCGain = dcgain(Tclosed);

SpeedError = abs(1-FinalSpeed);

SpeedErrorPercent = SpeedError*100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP SPEED RESPONSE\n');
fprintf('============================================================\n');

fprintf('Closed-loop DC gain     = %.9f\n',DCGain);

fprintf('Final simulated speed   = %.9f\n',FinalSpeed);

fprintf('Final speed error       = %.9f\n',SpeedError);

fprintf('Final speed error       = %.9f %%\n', ...
    SpeedErrorPercent);


%% ============================================================
% 20. CLOSED-LOOP PERFORMANCE PARAMETERS
% ============================================================

try

    info = stepinfo(Tclosed);

    fprintf('\n');
    fprintf('Closed-loop performance:\n');

    fprintf('Rise time               = %.6f s\n',info.RiseTime);

    fprintf('Settling time           = %.6f s\n',info.SettlingTime);

    fprintf('Overshoot               = %.6f %%\n',info.Overshoot);

catch

    fprintf('\n');
    fprintf('Step performance information unavailable.\n');

end


%% ============================================================
% 21. LOAD DISTURBANCE SIMULATION
% ============================================================

disturbance_time = 1.0;

load_torque = 0.20;

% Initial conditions
%
% x(1) = motor angular speed rad/s
% x(2) = integral of speed error

x0 = [0;0];


% ------------------------------------------------------------
% Anonymous function for MATLAB R2014a
% ------------------------------------------------------------

odefun = @(t,x) [ ...
    ( ...
    Kt * ...
    min( ...
        max( ...
            Kp*(rated_w-x(1)) + Ki*x(2), ...
            0), ...
        min( ...
            rated_I, ...
            max((Vdc-Ke*x(1))/R,0) ...
            ) ...
        ) ...
    - ...
    (t >= disturbance_time)*load_torque ...
    - B*x(1) ...
    )/J ; ...
    rated_w-x(1) ...
    ];


% ------------------------------------------------------------
% ODE45 simulation
% ------------------------------------------------------------

[t_load,x_load] = ...
    ode45(odefun,[0 3],x0);


% ------------------------------------------------------------
% Convert rad/s to rpm
% ------------------------------------------------------------

omega_load = x_load(:,1);

Speed_load_rpm = ...
    omega_load*60/(2*pi);


% ------------------------------------------------------------
% Plot load disturbance response
% ------------------------------------------------------------

figure;

plot(t_load,Speed_load_rpm,'LineWidth',2);

grid on;

xlabel('Time (s)');
ylabel('Speed (rpm)');

title('Load Disturbance Response');


% ------------------------------------------------------------
% Calculate disturbance characteristics
% ------------------------------------------------------------

pre_index = find(t_load < disturbance_time);

if isempty(pre_index)

    PreSpeed = Speed_load_rpm(1);

else

    PreSpeed = Speed_load_rpm(pre_index(end));

end


post_index = find(t_load >= disturbance_time);

MinPostSpeed = min(Speed_load_rpm(post_index));

SpeedDrop = PreSpeed-MinPostSpeed;

FinalDistSpeed = Speed_load_rpm(end);

FinalDistError = ...
    abs(rated_rpm-FinalDistSpeed);

FinalDistErrorPercent = ...
    FinalDistError/rated_rpm*100;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' LOAD DISTURBANCE RESPONSE\n');
fprintf('============================================================\n');

fprintf('Disturbance time          = %.6f s\n', ...
    disturbance_time);

fprintf('Applied load torque       = %.9f N.m\n', ...
    load_torque);

fprintf('Pre-disturbance speed     = %.9f rpm\n', ...
    PreSpeed);

fprintf('Minimum post-disturbance = %.9f rpm\n', ...
    MinPostSpeed);

fprintf('Speed drop                = %.9f rpm\n', ...
    SpeedDrop);

fprintf('Final speed               = %.9f rpm\n', ...
    FinalDistSpeed);

fprintf('Final speed error         = %.9f rpm\n', ...
    FinalDistError);

fprintf('Final speed error         = %.9f %%\n', ...
    FinalDistErrorPercent);


%% ============================================================
% 22. LOAD TORQUE / TORQUE BALANCE
% ============================================================

ViscousTorque = B*rated_w;

RequiredSteadyTorque = ...
    load_torque + ViscousTorque;

RequiredCurrent = ...
    RequiredSteadyTorque/Kt;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' LOAD TORQUE / TORQUE BALANCE\n');
fprintf('============================================================\n');

fprintf('Applied load torque       = %.9f N.m\n', ...
    load_torque);

fprintf('Viscous torque            = %.9f N.m\n', ...
    ViscousTorque);

fprintf('Required steady torque    = %.9f N.m\n', ...
    RequiredSteadyTorque);

fprintf('Required steady current   = %.9f A\n', ...
    RequiredCurrent);


%% ============================================================
% 23. FINAL VALIDATION
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 16 FINAL VALIDATION\n');
fprintf('============================================================\n');


% Rated speed validation

if rpm_diff <= 1

    fprintf('Rated speed datasheet validation       = PASS\n');

else

    fprintf('Rated speed datasheet validation       = REVIEW\n');

end


% Rated current validation

if I_diff <= 1

    fprintf('Rated current datasheet validation     = PASS\n');

else

    fprintf('Rated current datasheet validation     = REVIEW\n');

end


% Rated torque validation

if T_diff <= 1

    fprintf('Rated torque datasheet validation      = PASS\n');

else

    fprintf('Rated torque datasheet validation      = REVIEW\n');

end


% Ke validation

if Ke_diff <= 1

    fprintf('Back-EMF constant validation           = PASS\n');

else

    fprintf('Back-EMF constant validation           = REVIEW\n');

end


% Kt validation

if Kt_diff <= 1

    fprintf('Torque constant validation             = PASS\n');

else

    fprintf('Torque constant validation             = REVIEW\n');

end


% PWM duty validation

if RequiredDuty_rated <= 1

    fprintf('PWM duty feasibility                   = PASS\n');

else

    fprintf('PWM duty feasibility                   = REVIEW\n');

end


fprintf('\n');
fprintf('============================================================\n');
fprintf(' FINAL STAGE 16 COMPLETE\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf('The BLDC motor performance characteristics,\n');
fprintf('closed-loop response, load disturbance response,\n');
fprintf('and datasheet comparison have been completed.\n');
fprintf('\n');


%% ============================================================
% END OF STAGE 16
% ============================================================
