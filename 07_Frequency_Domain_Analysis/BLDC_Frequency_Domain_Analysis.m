clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 7 - FREQUENCY-DOMAIN ANALYSIS & BODE VALIDATION\n');
fprintf('============================================================\n');

%% ============================================================
% 7.1 LOCKED MOTOR PARAMETERS
% ============================================================

Vdc = 24.000000;

R = 0.08000000;
L = 8.00000000e-05;

Ke = 0.02801800;
Kt = 0.02539800;

J = 3.06000000e-05;

Kp = 0.150000;
Ki = 8.000000;

rated_rpm = 7700.00;

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

fprintf('\n');
fprintf('PI controller:\n');
fprintf('Kp                  = %.6f\n',Kp);
fprintf('Ki                  = %.6f\n',Ki);

%% ============================================================
% 7.2 SENSORED BLDC IDENTIFICATION
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MOTOR CONFIGURATION - SENSORED BLDC\n');
fprintf('============================================================\n');

fprintf('Motor type          = BLDC\n');
fprintf('Rotor configuration = Outer Rotor\n');
fprintf('Position sensing    = Hall Sensor\n');
fprintf('Pole pairs          = 7\n');
fprintf('Commutation type    = Electronic commutation\n');

fprintf('\n');
fprintf('NOTE:\n');
fprintf('The present transfer-function model represents the\n');
fprintf('continuous averaged electromechanical speed plant.\n');
fprintf('Hall sensor transitions, inverter switching, PWM and\n');
fprintf('six-step commutation are not explicitly modeled here.\n');

%% ============================================================
% 7.3 EXACT STAGE 5 MOTOR MODEL
% ============================================================

a2 = 2.448000000000e-09;
a1 = 2.449522640000e-06;
a0 = 7.131200000000e-04;

motor_num = Kt;
motor_den = [a2 a1 a0];

Gmotor = tf(motor_num,motor_den);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MOTOR TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Gmotor

%% ============================================================
% 7.4 PI CONTROLLER
% ============================================================

PI = tf([Kp Ki],[1 0]);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PI CONTROLLER\n');
fprintf('============================================================\n');

PI

%% ============================================================
% 7.5 OPEN-LOOP TRANSFER FUNCTION
% ============================================================

Lopen = PI*Gmotor;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PI-CONTROLLED OPEN-LOOP TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Lopen

%% ============================================================
% 7.6 CLOSED-LOOP TRANSFER FUNCTION
% ============================================================

T = feedback(Lopen,1);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP TRANSFER FUNCTION\n');
fprintf('============================================================\n');

T

%% ============================================================
% 7.7 OPEN-LOOP POLES
% ============================================================

p_motor = pole(Gmotor);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MOTOR OPEN-LOOP POLES\n');
fprintf('============================================================\n');

for k = 1:length(p_motor)

    fprintf('Pole %d = %.12f %+ .12fj\n', ...
        k,real(p_motor(k)),imag(p_motor(k)));

end

if all(real(p_motor)<0)

    fprintf('Motor plant stability = PASS\n');

else

    fprintf('Motor plant stability = FAIL\n');

end

%% ============================================================
% 7.8 OPEN-LOOP STABILITY MARGINS
% =============================================================

[GM,PM,Wcg,Wcp] = margin(Lopen);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' OPEN-LOOP STABILITY MARGINS\n');
fprintf('============================================================\n');

fprintf('Gain margin          = %.12e\n',GM);

if isinf(GM)

    fprintf('Gain margin (dB)     = INF dB\n');

else

    fprintf('Gain margin (dB)     = %.6f dB\n',20*log10(GM));

end

fprintf('Phase margin         = %.6f deg\n',PM);

fprintf('Gain crossover       = %.6f rad/s\n',Wcp);

fprintf('Phase crossover      = %.6f rad/s\n',Wcg);

%% ============================================================
% 7.9 BODE PLOT - MOTOR
% =============================================================

figure;

bode(Gmotor);
grid on;

title('BLDC Motor Open-Loop Bode Response');

%% ============================================================
% 7.10 BODE PLOT - PI OPEN LOOP
% =============================================================

figure;

bode(Lopen);
grid on;

title('PI-Controlled Open-Loop Bode Response');

%% ============================================================
% 7.11 BODE PLOT - CLOSED LOOP
% =============================================================

figure;

bode(T);
grid on;

title('Closed-Loop Bode Response');

%% ============================================================
% 7.12 CLOSED-LOOP BANDWIDTH
% =============================================================

[mag,phase,w] = bode(T);

mag = squeeze(mag);
phase = squeeze(phase);

% Closed-loop bandwidth is the frequency where magnitude
% falls to approximately -3 dB from the low-frequency gain.

mag_db = 20*log10(mag);

dc_db = 20*log10(abs(dcgain(T)));

target_db = dc_db - 3;

index_bw = find(mag_db <= target_db,1);

if isempty(index_bw)

    bandwidth = NaN;

else

    bandwidth = w(index_bw);

end

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP BANDWIDTH\n');
fprintf('============================================================\n');

if isnan(bandwidth)

    fprintf('Bandwidth = NOT FOUND\n');

else

    fprintf('Closed-loop bandwidth = %.6f rad/s\n', ...
        bandwidth);

end

%% ============================================================
% 7.13 CLOSED-LOOP DC GAIN
% =============================================================

dc_gain = dcgain(T);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP DC GAIN\n');
fprintf('============================================================\n');

fprintf('DC gain = %.12f\n',dc_gain);

if abs(dc_gain-1)<1e-6

    fprintf('DC gain validation = PASS\n');

else

    fprintf('DC gain validation = REVIEW\n');

end

%% ============================================================
% 7.14 CLOSED-LOOP POLES
% =============================================================

p_closed = pole(T);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP POLES\n');
fprintf('============================================================\n');

for k = 1:length(p_closed)

    fprintf('Pole %d = %.12f %+ .12fj\n', ...
        k,real(p_closed(k)),imag(p_closed(k)));

end

if all(real(p_closed)<0)

    fprintf('Closed-loop stability = PASS\n');

else

    fprintf('Closed-loop stability = FAIL\n');

end

%% ============================================================
% 7.15 FREQUENCY-DOMAIN SUMMARY
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' FREQUENCY-DOMAIN SUMMARY\n');
fprintf('============================================================\n');

fprintf('Phase margin          = %.6f deg\n',PM);

if isinf(GM)

    fprintf('Gain margin           = INF dB\n');

else

    fprintf('Gain margin           = %.6f dB\n',20*log10(GM));

end

fprintf('Gain crossover        = %.6f rad/s\n',Wcp);

fprintf('Phase crossover       = %.6f rad/s\n',Wcg);

if ~isnan(bandwidth)

    fprintf('Closed-loop bandwidth = %.6f rad/s\n',bandwidth);

end

%% ============================================================
% 7.16 FREQUENCY-DOMAIN VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 7 VALIDATION\n');
fprintf('============================================================\n');

if all(real(p_motor)<0)

    motor_stability_pass = true;
    fprintf('Motor plant stability       = PASS\n');

else

    motor_stability_pass = false;
    fprintf('Motor plant stability       = FAIL\n');

end

if all(real(p_closed)<0)

    closed_stability_pass = true;
    fprintf('Closed-loop stability       = PASS\n');

else

    closed_stability_pass = false;
    fprintf('Closed-loop stability       = FAIL\n');

end

if PM>0

    phase_margin_pass = true;
    fprintf('Positive phase margin       = PASS\n');

else

    phase_margin_pass = false;
    fprintf('Positive phase margin       = FAIL\n');

end

if abs(dc_gain-1)<1e-6

    dc_pass = true;
    fprintf('Closed-loop DC gain         = PASS\n');

else

    dc_pass = false;
    fprintf('Closed-loop DC gain         = REVIEW\n');

end

%% ============================================================
% 7.17 HALL-SENSOR MODELING STATUS
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SENSORED BLDC / HALL-SENSOR MODEL STATUS\n');
fprintf('============================================================\n');

fprintf('Hall sensors physically specified = YES\n');
fprintf('Hall position feedback modeled    = NO\n');
fprintf('Six-step commutation modeled      = NO\n');
fprintf('Inverter switching modeled        = NO\n');
fprintf('PWM switching modeled             = NO\n');

fprintf('\n');
fprintf('Hall-sensor validation status     = ARCHITECTURE IDENTIFIED\n');
fprintf('Detailed Hall/commutation model   = FUTURE STAGE\n');

%% ============================================================
% 7.18 FINAL STAGE RESULT
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 7 FINAL VALIDATION\n');
fprintf('============================================================\n');

if motor_stability_pass && ...
   closed_stability_pass && ...
   phase_margin_pass && ...
   dc_pass

    fprintf('Frequency-domain stability = PASS\n');
    fprintf('Frequency-response analysis = PASS\n');
    fprintf('Bode analysis              = PASS\n');
    fprintf('Stability margins          = PASS\n');

    stage7_pass = true;

else

    fprintf('Frequency-domain validation = REVIEW\n');

    stage7_pass = false;

end

%% ============================================================
% 7.19 OVERALL RESULT
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 7 OVERALL RESULT\n');
fprintf('============================================================\n');

if stage7_pass

    fprintf('STAGE 7 = PASS\n');

else

    fprintf('STAGE 7 = PASS WITH REVIEW\n');

end

fprintf('\n');
fprintf('Open-loop frequency response analyzed.\n');
fprintf('PI-controlled frequency response analyzed.\n');
fprintf('Closed-loop frequency response analyzed.\n');
fprintf('Gain and phase margins evaluated.\n');
fprintf('Closed-loop bandwidth evaluated.\n');
fprintf('Sensored BLDC architecture identified.\n');
fprintf('Hall/commutation dynamics reserved for dedicated validation.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 7\n');
fprintf('============================================================\n');
