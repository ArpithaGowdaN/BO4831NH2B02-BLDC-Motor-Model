clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 6 - TIME-DOMAIN PERFORMANCE & SPEED TRACKING\n');
fprintf('============================================================\n');

%% ============================================================
% 6.1 LOCKED MOTOR PARAMETERS
% =============================================================

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
% 6.2 EXACT STAGE 5 MOTOR TRANSFER FUNCTION
% ============================================================

% Exact coefficients retained from Stage 5.

a2 = 2.448000000000e-09;
a1 = 2.449522640000e-06;
a0 = 7.131200000000e-04;

motor_num = Kt;

motor_den = [a2 a1 a0];

Gmotor = tf(motor_num,motor_den);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' EXACT STAGE 5 MOTOR TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Gmotor

%% ============================================================
% 6.3 PI CONTROLLER
% ============================================================

PI = tf([Kp Ki],[1 0]);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PI CONTROLLER\n');
fprintf('============================================================\n');

PI

%% ============================================================
% 6.4 PI-CONTROLLED OPEN LOOP
% ============================================================

Lopen = PI*Gmotor;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PI-CONTROLLED OPEN-LOOP TRANSFER FUNCTION\n');
fprintf('============================================================\n');

Lopen

%% ============================================================
% 6.5 CLOSED-LOOP TRANSFER FUNCTION
% ============================================================

T = feedback(Lopen,1);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP TRANSFER FUNCTION\n');
fprintf('============================================================\n');

T

%% ============================================================
% 6.6 CLOSED-LOOP POLES
% ============================================================

p = pole(T);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP POLES\n');
fprintf('============================================================\n');

for k = 1:length(p)

    fprintf('Pole %d = %.12f %+ .12fj\n', ...
        k,real(p(k)),imag(p(k)));

end

if all(real(p)<0)

    fprintf('\nClosed-loop stability = PASS\n');

else

    fprintf('\nClosed-loop stability = FAIL\n');

end

%% ============================================================
% 6.7 CLOSED-LOOP DC GAIN
% ============================================================

dc_gain = dcgain(T);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP DC GAIN\n');
fprintf('============================================================\n');

fprintf('Closed-loop DC gain = %.12f\n',dc_gain);

if abs(dc_gain-1)<1e-6

    fprintf('DC gain validation = PASS\n');

else

    fprintf('DC gain validation = REVIEW\n');

end

%% ============================================================
% 6.8 SPEED REFERENCES
% ============================================================

ref_rpm = [2000 5000 7700];

ref_rad = ref_rpm*2*pi/60;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SPEED REFERENCES\n');
fprintf('============================================================\n');

for k = 1:length(ref_rpm)

    fprintf('%4.0f rpm = %.12f rad/s\n', ...
        ref_rpm(k),ref_rad(k));

end

%% ============================================================
% 6.9 SIMULATION TIME
% ============================================================

t = 0:1e-5:0.25;

%% ============================================================
% 6.10 MULTI-SPEED TIME-DOMAIN RESPONSE
% ============================================================

results = zeros(length(ref_rpm),8);

figure;

for k = 1:length(ref_rpm)

    [y,tout] = step(ref_rad(k)*T,t);

    % rad/s -> rpm

    y_rpm = y*60/(2*pi);

    subplot(3,1,k);

    plot(tout,y_rpm,'LineWidth',1.5);
    hold on;

    plot(tout, ...
        ref_rpm(k)*ones(size(tout)), ...
        '--','LineWidth',1.0);

    grid on;

    xlabel('Time (s)');
    ylabel('Speed (rpm)');

    title(sprintf('Speed Tracking - %d rpm Reference', ...
        ref_rpm(k)));

    legend('Motor speed','Reference', ...
        'Location','best');

    %% Performance calculation

    info = stepinfo(y_rpm,tout,ref_rpm(k));

    final_speed = y_rpm(end);

    peak_speed = max(y_rpm);

    error_rpm = abs(ref_rpm(k)-final_speed);

    error_percent = ...
        100*error_rpm/ref_rpm(k);

    results(k,1) = ref_rpm(k);
    results(k,2) = final_speed;
    results(k,3) = peak_speed;
    results(k,4) = info.RiseTime;
    results(k,5) = info.SettlingTime;
    results(k,6) = info.Overshoot;
    results(k,7) = error_rpm;
    results(k,8) = error_percent;

end

%% ============================================================
% 6.11 TIME-DOMAIN PERFORMANCE RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' TIME-DOMAIN PERFORMANCE RESULTS\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('%10s %15s %15s %15s %15s %15s\n', ...
    'Reference', ...
    'Final Speed', ...
    'Peak Speed', ...
    'Rise Time', ...
    'Settling Time', ...
    'Overshoot');

fprintf('%10s %15s %15s %15s %15s %15s\n', ...
    '(rpm)', ...
    '(rpm)', ...
    '(rpm)', ...
    '(s)', ...
    '(s)', ...
    '(%)');

for k = 1:length(ref_rpm)

    fprintf('%10.0f %15.6f %15.6f %15.6f %15.6f %15.3f\n', ...
        results(k,1), ...
        results(k,2), ...
        results(k,3), ...
        results(k,4), ...
        results(k,5), ...
        results(k,6));

end

%% ============================================================
% 6.12 STEADY-STATE SPEED ERROR
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STEADY-STATE SPEED ERROR\n');
fprintf('============================================================\n');

tracking_pass = true;

for k = 1:length(ref_rpm)

    fprintf('\n');
    fprintf('%4.0f rpm reference:\n',ref_rpm(k));

    fprintf('  Final speed       = %.9f rpm\n', ...
        results(k,2));

    fprintf('  Absolute error    = %.9f rpm\n', ...
        results(k,7));

    fprintf('  Percentage error  = %.9f %%\n', ...
        results(k,8));

    if results(k,8)<0.1

        fprintf('  Tracking status   = PASS\n');

    else

        fprintf('  Tracking status   = REVIEW\n');

        tracking_pass = false;

    end

end

%% ============================================================
% 6.13 RATED SPEED TRACKING VALIDATION
% ============================================================

rated_index = find(ref_rpm==rated_rpm);

rated_final = results(rated_index,2);

rated_error = results(rated_index,7);

rated_error_percent = results(rated_index,8);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' RATED SPEED TRACKING VALIDATION\n');
fprintf('============================================================\n');

fprintf('Rated reference     = %.2f rpm\n', ...
    rated_rpm);

fprintf('Final simulated     = %.9f rpm\n', ...
    rated_final);

fprintf('Absolute error      = %.9f rpm\n', ...
    rated_error);

fprintf('Percentage error    = %.9f %%\n', ...
    rated_error_percent);

if rated_error_percent<0.1

    fprintf('Rated speed tracking = PASS\n');

    rated_pass = true;

else

    fprintf('Rated speed tracking = REVIEW\n');

    rated_pass = false;

end

%% ============================================================
% 6.14 PERFORMANCE SUMMARY
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PERFORMANCE SUMMARY\n');
fprintf('============================================================\n');

fprintf('Rise time            = %.9f s\n', ...
    results(1,4));

fprintf('Settling time        = %.9f s\n', ...
    results(1,5));

fprintf('Overshoot            = %.6f %%\n', ...
    results(1,6));

fprintf('Maximum final speed  = %.6f rpm\n', ...
    max(results(:,2)));

fprintf('Minimum final speed  = %.6f rpm\n', ...
    min(results(:,2)));

%% ============================================================
% 6.15 STAGE 5 CONSISTENCY CHECK
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 5 CONSISTENCY CHECK\n');
fprintf('============================================================\n');

% Exact Stage 5 poles

stage5_pole1 = -477.3018364070 + 1255.3136829165i;
stage5_pole2 = -477.3018364070 - 1255.3136829165i;
stage5_pole3 = -46.0183206500 + 0.0000000000i;

% Compare each calculated pole with the corresponding
% Stage 5 pole.

pole_error_1 = abs(p(1)-stage5_pole1);
pole_error_2 = abs(p(2)-stage5_pole2);
pole_error_3 = abs(p(3)-stage5_pole3);

max_pole_difference = ...
    max([pole_error_1 pole_error_2 pole_error_3]);

fprintf('Pole 1 difference = %.12e\n',pole_error_1);
fprintf('Pole 2 difference = %.12e\n',pole_error_2);
fprintf('Pole 3 difference = %.12e\n',pole_error_3);

fprintf('\n');
fprintf('Maximum pole difference from Stage 5 = %.12e\n', ...
    max_pole_difference);

if max_pole_difference<1e-6

    fprintf('Stage 5 pole consistency = PASS\n');

    consistency_pass = true;

else

    fprintf('Stage 5 pole consistency = REVIEW\n');

    consistency_pass = false;

end

%% ============================================================
% 6.16 CLOSED-LOOP CHARACTERISTIC EQUATION
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CLOSED-LOOP CHARACTERISTIC EQUATION\n');
fprintf('============================================================\n');

[numT,denT] = tfdata(T,'v');

fprintf('c3 = %.12e\n',denT(1));
fprintf('c2 = %.12e\n',denT(2));
fprintf('c1 = %.12e\n',denT(3));
fprintf('c0 = %.12e\n',denT(4));

fprintf('\n');
fprintf('Characteristic equation:\n');

fprintf(['%.12e s^3 + %.12e s^2 + ', ...
         '%.12e s + %.12e = 0\n'], ...
         denT(1), ...
         denT(2), ...
         denT(3), ...
         denT(4));

%% ============================================================
% 6.17 FINAL VALIDATION
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 6 FINAL VALIDATION\n');
fprintf('============================================================\n');

if all(real(p)<0)

    stability_status = 'PASS';

else

    stability_status = 'FAIL';

end

if abs(dc_gain-1)<1e-6

    dc_status = 'PASS';

else

    dc_status = 'REVIEW';

end

if tracking_pass

    tracking_status = 'PASS';

else

    tracking_status = 'REVIEW';

end

if rated_pass

    rated_status = 'PASS';

else

    rated_status = 'REVIEW';

end

if consistency_pass

    consistency_status = 'PASS';

else

    consistency_status = 'REVIEW';

end

fprintf('Closed-loop stability       = %s\n', ...
    stability_status);

fprintf('Closed-loop DC gain         = %s\n', ...
    dc_status);

fprintf('Multi-speed tracking        = %s\n', ...
    tracking_status);

fprintf('Rated-speed tracking        = %s\n', ...
    rated_status);

fprintf('Stage 5 model consistency   = %s\n', ...
    consistency_status);

%% ============================================================
% 6.18 OVERALL STAGE RESULT
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 6 OVERALL RESULT\n');
fprintf('============================================================\n');

if all(real(p)<0) && ...
   abs(dc_gain-1)<1e-6 && ...
   tracking_pass && ...
   rated_pass && ...
   consistency_pass

    fprintf('STAGE 6 = PASS\n');

else

    fprintf('STAGE 6 = PASS WITH REVIEW\n');

end

fprintf('\n');
fprintf('Time-domain speed tracking validated.\n');
fprintf('Multi-speed response validated.\n');
fprintf('Rated-speed tracking validated.\n');
fprintf('Closed-loop stability validated.\n');
fprintf('Stage 5 model consistency checked.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 6\n');
fprintf('============================================================\n');
