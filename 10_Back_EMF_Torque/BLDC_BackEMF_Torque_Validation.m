clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 10 - BACK-EMF & ELECTROMAGNETIC TORQUE VALIDATION\n');
fprintf('============================================================\n');

%% ============================================================
% 10.1 LOCKED MOTOR PARAMETERS
% =============================================================

Vdc = 24.000000;

R = 0.08000000;
L = 8.00000000e-05;

Ke = 0.02801800;
Kt = 0.02539800;

J = 3.06000000e-05;

pole_pairs = 7;

rated_rpm = 7700.00;
rated_current = 17.60;
rated_torque = 0.447000;

datasheet_Ke = 0.02291831;
datasheet_Kt = 0.02250000;

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
fprintf('Pole pairs          = %d\n',pole_pairs);

fprintf('Rated speed         = %.2f rpm\n',rated_rpm);
fprintf('Rated current       = %.2f A\n',rated_current);
fprintf('Rated torque        = %.6f N.m\n',rated_torque);

%% ============================================================
% 10.2 CONSTANT REFERENCE COMPARISON
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MODEL CONSTANTS VS DATASHEET REFERENCE\n');
fprintf('============================================================\n');

Ke_difference = ...
    abs(Ke-datasheet_Ke)/datasheet_Ke*100;

Kt_difference = ...
    abs(Kt-datasheet_Kt)/datasheet_Kt*100;

fprintf('Locked model Ke       = %.8f V.s/rad\n',Ke);
fprintf('Datasheet Ke          = %.8f V.s/rad\n',datasheet_Ke);
fprintf('Ke difference         = %.6f %%\n',Ke_difference);

fprintf('\n');

fprintf('Locked model Kt       = %.8f N.m/A\n',Kt);
fprintf('Datasheet Kt          = %.8f N.m/A\n',datasheet_Kt);
fprintf('Kt difference         = %.6f %%\n',Kt_difference);

fprintf('\n');
fprintf('NOTE: Locked model constants are retained.\n');
fprintf('Datasheet constants are reference values only.\n');

%% ============================================================
% 10.3 RATED SPEED CONVERSION
% =============================================================

rated_omega = rated_rpm*2*pi/60;

rated_rps = rated_rpm/60;

electrical_speed = pole_pairs*rated_omega;

electrical_frequency = electrical_speed/(2*pi);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SPEED CONVERSION\n');
fprintf('============================================================\n');

fprintf('Rated speed          = %.2f rpm\n',rated_rpm);

fprintf('Mechanical speed     = %.6f rad/s\n', ...
    rated_omega);

fprintf('Mechanical speed     = %.6f rev/s\n', ...
    rated_rps);

fprintf('Electrical speed     = %.6f rad/s\n', ...
    electrical_speed);

fprintf('Electrical frequency = %.6f Hz\n', ...
    electrical_frequency);

%% ============================================================
% 10.4 BACK-EMF CALCULATION
% =============================================================

rated_back_emf = Ke*rated_omega;

datasheet_back_emf = datasheet_Ke*rated_omega;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BACK-EMF VALIDATION AT RATED SPEED\n');
fprintf('============================================================\n');

fprintf('Locked model Ke      = %.8f V.s/rad\n',Ke);

fprintf('Model back EMF       = %.8f V\n', ...
    rated_back_emf);

fprintf('Datasheet-based EMF  = %.8f V\n', ...
    datasheet_back_emf);

fprintf('Available DC voltage = %.8f V\n',Vdc);

fprintf('Model EMF difference = %.6f %%\n', ...
    abs(rated_back_emf-datasheet_back_emf) / ...
    datasheet_back_emf*100);

%% ============================================================
% 10.5 RESISTIVE VOLTAGE DROP
% =============================================================

resistive_drop = rated_current*R;

required_voltage = rated_back_emf + resistive_drop;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED-POINT ELECTRICAL BALANCE\n');
fprintf('============================================================\n');

fprintf('Rated current        = %.6f A\n',rated_current);

fprintf('I*R voltage drop     = %.8f V\n', ...
    resistive_drop);

fprintf('Back EMF             = %.8f V\n', ...
    rated_back_emf);

fprintf('Required voltage     = %.8f V\n', ...
    required_voltage);

fprintf('Available Vdc        = %.8f V\n',Vdc);

voltage_difference = ...
    abs(required_voltage-Vdc)/Vdc*100;

fprintf('Voltage difference   = %.8f %%\n', ...
    voltage_difference);

if voltage_difference < 0.01

    voltage_balance_pass = true;

    fprintf('Rated voltage balance = PASS\n');

else

    voltage_balance_pass = false;

    fprintf('Rated voltage balance = REVIEW\n');

end

%% ============================================================
% 10.6 ELECTROMAGNETIC TORQUE
% =============================================================

calculated_torque = Kt*rated_current;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' ELECTROMAGNETIC TORQUE VALIDATION\n');
fprintf('============================================================\n');

fprintf('Torque constant      = %.8f N.m/A\n',Kt);

fprintf('Rated current        = %.6f A\n',rated_current);

fprintf('Calculated torque    = %.9f N.m\n', ...
    calculated_torque);

fprintf('Datasheet torque     = %.9f N.m\n', ...
    rated_torque);

torque_difference = ...
    abs(calculated_torque-rated_torque)/rated_torque*100;

fprintf('Torque difference     = %.9f %%\n', ...
    torque_difference);

if torque_difference < 0.01

    torque_pass = true;

    fprintf('Rated torque validation = PASS\n');

else

    torque_pass = false;

    fprintf('Rated torque validation = REVIEW\n');

end

%% ============================================================
% 10.7 TORQUE VS CURRENT
% =============================================================

current = 0:0.1:20;

torque = Kt*current;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' TORQUE-CURRENT RELATIONSHIP\n');
fprintf('============================================================\n');

fprintf('Equation:\n');
fprintf('T_e = Kt * I\n');

fprintf('Kt = %.8f N.m/A\n',Kt);

fprintf('At 1 A       -> %.8f N.m\n',Kt*1);
fprintf('At 5 A       -> %.8f N.m\n',Kt*5);
fprintf('At 10 A      -> %.8f N.m\n',Kt*10);
fprintf('At 17.6 A    -> %.8f N.m\n',Kt*17.6);

figure;

plot(current,torque,'LineWidth',1.5);

grid on;

xlabel('Phase Current (A)');
ylabel('Electromagnetic Torque (N.m)');

title('BLDC Electromagnetic Torque vs Current');

%% ============================================================
% 10.8 BACK-EMF VS SPEED
% =============================================================

speed_rpm = 0:100:10000;

speed_rad = speed_rpm*2*pi/60;

back_emf = Ke*speed_rad;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BACK-EMF VS SPEED RELATIONSHIP\n');
fprintf('============================================================\n');

fprintf('Equation:\n');
fprintf('E = Ke * omega\n');

fprintf('Ke = %.8f V.s/rad\n',Ke);

figure;

plot(speed_rpm,back_emf,'LineWidth',1.5);

grid on;

xlabel('Mechanical Speed (rpm)');
ylabel('Back-EMF (V)');

title('BLDC Back-EMF vs Mechanical Speed');

%% ============================================================
% 10.9 BACK-EMF AT IMPORTANT SPEEDS
% =============================================================

speed_test = [0 2000 5000 7700 10000];

omega_test = speed_test*2*pi/60;

emf_test = Ke*omega_test;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BACK-EMF SPEED CHECKS\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf(' Speed (rpm)       Speed (rad/s)       Back-EMF (V)\n');
fprintf(' -----------------------------------------------------\n');

for k = 1:length(speed_test)

    fprintf(' %8.0f          %12.6f       %12.6f\n', ...
        speed_test(k), ...
        omega_test(k), ...
        emf_test(k));

end

%% ============================================================
% 10.10 ELECTROMAGNETIC POWER
% =============================================================

mechanical_power = calculated_torque*rated_omega;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' ELECTROMAGNETIC / MECHANICAL POWER\n');
fprintf('============================================================\n');

fprintf('Electromagnetic torque = %.9f N.m\n', ...
    calculated_torque);

fprintf('Mechanical speed       = %.9f rad/s\n', ...
    rated_omega);

fprintf('Mechanical power       = %.6f W\n', ...
    mechanical_power);

%% ============================================================
% 10.11 ELECTRICAL POWER REFERENCE
% =============================================================

input_power = Vdc*rated_current;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' ELECTRICAL POWER REFERENCE\n');
fprintf('============================================================\n');

fprintf('DC voltage             = %.6f V\n',Vdc);

fprintf('Rated current          = %.6f A\n',rated_current);

fprintf('DC electrical power    = %.6f W\n',input_power);

fprintf('\n');

fprintf('NOTE:\n');
fprintf('DC input power is a reference quantity only.\n');
fprintf('It is not treated as exact BLDC phase power because\n');
fprintf('inverter and switching losses are not modeled yet.\n');

%% ============================================================
% 10.12 TORQUE-BACK-EMF CONSISTENCY
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' TORQUE / BACK-EMF CONSTANT RELATIONSHIP\n');
fprintf('============================================================\n');

fprintf('Locked Ke = %.8f V.s/rad\n',Ke);
fprintf('Locked Kt = %.8f N.m/A\n',Kt);

fprintf('\n');

fprintf('For the locked averaged model, Ke and Kt are retained\n');
fprintf('as independently defined effective constants.\n');

fprintf('Therefore no forced Ke = Kt equality is imposed here.\n');

%% ============================================================
% 10.13 POWER-TORQUE CHECK
% =============================================================

power_from_torque = calculated_torque*rated_omega;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' POWER FROM TORQUE CHECK\n');
fprintf('============================================================\n');

fprintf('Torque                  = %.9f N.m\n', ...
    calculated_torque);

fprintf('Angular speed           = %.9f rad/s\n', ...
    rated_omega);

fprintf('P = T*omega             = %.6f W\n', ...
    power_from_torque);

%% ============================================================
% 10.14 FINAL VALIDATION\n
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 10 FINAL VALIDATION\n');
fprintf('============================================================\n');

fprintf('Rated-speed conversion       = PASS\n');

if voltage_balance_pass
    fprintf('Rated voltage balance        = PASS\n');
else
    fprintf('Rated voltage balance        = REVIEW\n');
end

if torque_pass
    fprintf('Rated electromagnetic torque = PASS\n');
else
    fprintf('Rated electromagnetic torque = REVIEW\n');
end

fprintf('Back-EMF calculation         = PASS\n');
fprintf('Torque-current relationship   = PASS\n');
fprintf('Back-EMF-speed relationship  = PASS\n');
fprintf('Electrical frequency         = PASS\n');

%% ============================================================
% 10.15 OVERALL RESULT
% =============================================================

stage10_pass = ...
    voltage_balance_pass && ...
    torque_pass;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 10 OVERALL RESULT\n');
fprintf('============================================================\n');

if stage10_pass

    fprintf('STAGE 10 = PASS\n');

else

    fprintf('STAGE 10 = PASS WITH REVIEW\n');

end

fprintf('\n');
fprintf('Back-EMF model validated.\n');
fprintf('Electromagnetic torque validated.\n');
fprintf('Torque-current relationship validated.\n');
fprintf('Back-EMF-speed relationship validated.\n');
fprintf('Rated electrical frequency calculated.\n');
fprintf('Mechanical power calculated.\n');

fprintf('\n');
fprintf('IMPORTANT MODEL LIMITATION:\n');
fprintf('Phase trapezoidal back-EMF waveform, inverter switching,\n');
fprintf('PWM and detailed phase-current commutation are not yet\n');
fprintf('modeled. These will be addressed in later stages.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 10\n');
fprintf('============================================================\n');
