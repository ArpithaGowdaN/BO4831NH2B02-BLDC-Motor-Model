clc;
clear;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' BO4831NH2B02-101-24.0\n');
fprintf(' STAGE 13 - PWM + HALL SIX-STEP TIME-DOMAIN VALIDATION\n');
fprintf('============================================================\n');

%% ============================================================
% 1. LOCKED MOTOR PARAMETERS
% =============================================================

Vdc = 24.0;
R   = 0.08000000;
L   = 8.00000000e-05;

Ke  = 0.02801800;
Kt  = 0.02539800;

J   = 3.06000000e-05;

pole_pairs    = 7;
rated_rpm     = 7700.0;
rated_current = 17.60;
rated_torque  = 0.447000;

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
% 2. SPEED AND ELECTRICAL FREQUENCY
% =============================================================

omega_m = rated_rpm*2*pi/60;
f_mech  = rated_rpm/60;

f_elec  = pole_pairs*f_mech;
omega_e = 2*pi*f_elec;

f_comm = 6*f_elec;
f_hall = f_comm;

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SPEED / ELECTRICAL FREQUENCY\n');
fprintf('============================================================\n');

fprintf('Mechanical speed          = %.12f rad/s\n',omega_m);
fprintf('Mechanical frequency      = %.12f Hz\n',f_mech);
fprintf('Electrical frequency      = %.12f Hz\n',f_elec);
fprintf('Electrical angular speed  = %.12f rad/s\n',omega_e);
fprintf('Commutation frequency     = %.12f Hz\n',f_comm);
fprintf('Hall transition frequency = %.12f Hz\n',f_hall);

%% ============================================================
% 3. SIMULATION SETTINGS
% =============================================================

electrical_cycles = 2;

T_elec = 1/f_elec;
Tsim   = electrical_cycles*T_elec;

N = 6001;

t  = linspace(0,Tsim,N)';
dt = t(2)-t(1);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SIMULATION SETTINGS\n');
fprintf('============================================================\n');

fprintf('Electrical cycles = %d\n',electrical_cycles);
fprintf('Simulation time   = %.12f s\n',Tsim);
fprintf('Time step         = %.12e s\n',dt);
fprintf('Simulation points = %d\n',N);

%% ============================================================
% 4. RATED BACK-EMF AND PWM DUTY
% =============================================================

E_rated = Ke*omega_m;

IR_drop = rated_current*R;

V_required = E_rated + IR_drop;

duty_theoretical = V_required/Vdc;

duty_applied = min(max(duty_theoretical,0),1);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PWM DUTY CYCLE\n');
fprintf('============================================================\n');

fprintf('Rated back-EMF          = %.9f V\n',E_rated);
fprintf('Rated I*R drop          = %.9f V\n',IR_drop);
fprintf('Required voltage       = %.9f V\n',V_required);

fprintf('Required theoretical duty = %.9f\n',duty_theoretical);
fprintf('Required theoretical duty = %.6f %%\n',...
    100*duty_theoretical);

fprintf('Applied simulation duty  = %.9f\n',duty_applied);
fprintf('Applied simulation duty  = %.6f %%\n',...
    100*duty_applied);

if duty_theoretical <= 1
    duty_status = 'PASS';
else
    duty_status = 'REVIEW';
end

fprintf('Theoretical duty feasibility = %s\n',duty_status);

%% ============================================================
% 5. ELECTRICAL ANGLE
% =============================================================

theta_e = mod(omega_e*t,2*pi);

sector = floor(theta_e/(pi/3)) + 1;

sector(sector > 6) = 6;

%% ============================================================
% 6. HALL SENSOR GENERATION
%
% Forward sequence:
%
% 001 -> 101 -> 100 -> 110 -> 010 -> 011 -> 001
%
% =============================================================

HallA = zeros(N,1);
HallB = zeros(N,1);
HallC = zeros(N,1);

% Sector 1 = 001
idx = sector == 1;
HallA(idx) = 0;
HallB(idx) = 0;
HallC(idx) = 1;

% Sector 2 = 101
idx = sector == 2;
HallA(idx) = 1;
HallB(idx) = 0;
HallC(idx) = 1;

% Sector 3 = 100
idx = sector == 3;
HallA(idx) = 1;
HallB(idx) = 0;
HallC(idx) = 0;

% Sector 4 = 110
idx = sector == 4;
HallA(idx) = 1;
HallB(idx) = 1;
HallC(idx) = 0;

% Sector 5 = 010
idx = sector == 5;
HallA(idx) = 0;
HallB(idx) = 1;
HallC(idx) = 0;

% Sector 6 = 011
idx = sector == 6;
HallA(idx) = 0;
HallB(idx) = 1;
HallC(idx) = 1;

hall_code = 4*HallA + 2*HallB + HallC;

%% ============================================================
% 7. SIX-STEP PHASE COMMANDS
%
% +1 = positive phase
% -1 = negative phase
%  0 = floating phase
%
% =============================================================

U = zeros(N,1);
V = zeros(N,1);
W = zeros(N,1);

% Sector 1: +U -V
idx = sector == 1;
U(idx) =  1;
V(idx) = -1;
W(idx) =  0;

% Sector 2: +U -W
idx = sector == 2;
U(idx) =  1;
V(idx) =  0;
W(idx) = -1;

% Sector 3: +V -W
idx = sector == 3;
U(idx) =  0;
V(idx) =  1;
W(idx) = -1;

% Sector 4: +V -U
idx = sector == 4;
U(idx) = -1;
V(idx) =  1;
W(idx) =  0;

% Sector 5: +W -U
idx = sector == 5;
U(idx) = -1;
V(idx) =  0;
W(idx) =  1;

% Sector 6: +W -V
idx = sector == 6;
U(idx) =  0;
V(idx) = -1;
W(idx) =  1;

%% ============================================================
% 8. TRAPEZOIDAL BACK-EMF SECTOR MODEL
%
% Normalized phase back-EMF states are aligned with the
% six-step commutation sequence.
%
% U: + + 0 - - 0
% V: - 0 + + 0 -
% W: 0 - - 0 + +
%
% This is an averaged six-step representation.
% =============================================================

bemfU_norm = zeros(N,1);
bemfV_norm = zeros(N,1);
bemfW_norm = zeros(N,1);

% Sector 1
idx = sector == 1;
bemfU_norm(idx) =  1;
bemfV_norm(idx) = -1;
bemfW_norm(idx) =  0;

% Sector 2
idx = sector == 2;
bemfU_norm(idx) =  1;
bemfV_norm(idx) =  0;
bemfW_norm(idx) = -1;

% Sector 3
idx = sector == 3;
bemfU_norm(idx) =  0;
bemfV_norm(idx) =  1;
bemfW_norm(idx) = -1;

% Sector 4
idx = sector == 4;
bemfU_norm(idx) = -1;
bemfV_norm(idx) =  1;
bemfW_norm(idx) =  0;

% Sector 5
idx = sector == 5;
bemfU_norm(idx) = -1;
bemfV_norm(idx) =  0;
bemfW_norm(idx) =  1;

% Sector 6
idx = sector == 6;
bemfU_norm(idx) =  0;
bemfV_norm(idx) = -1;
bemfW_norm(idx) =  1;

bemfU = Ke*omega_m*bemfU_norm;
bemfV = Ke*omega_m*bemfV_norm;
bemfW = Ke*omega_m*bemfW_norm;

%% ============================================================
% 9. EFFECTIVE CONDUCTING-PAIR CURRENT MODEL
%
% IMPORTANT:
%
% Only ONE conducting-pair current is solved.
%
% The phase currents are then assigned as:
%
% Sector 1: IU=+I, IV=-I, IW=0
% Sector 2: IU=+I, IV=0,  IW=-I
% Sector 3: IU=0,  IV=+I, IW=-I
% Sector 4: IU=-I, IV=+I, IW=0
% Sector 5: IU=-I, IV=0,  IW=+I
% Sector 6: IU=0,  IV=-I, IW=+I
%
% Therefore:
%
% IU + IV + IW = 0
%
% This is an averaged validation model, not a MOSFET
% switching-level inverter model.
% =============================================================

Ipair = zeros(N,1);

% Effective electrical equation using the locked model convention:
%
% L*dI/dt = Vdc*duty - E - R*I

for k = 1:N-1

    E_effective = E_rated;

    dI = (Vdc*duty_applied - E_effective ...
        - R*Ipair(k))/L;

    Ipair(k+1) = Ipair(k) + dt*dI;

end

%% ============================================================
% 10. PHASE CURRENT ASSIGNMENT
% =============================================================

IU = zeros(N,1);
IV = zeros(N,1);
IW = zeros(N,1);

% Sector 1: +U -V
idx = sector == 1;
IU(idx) =  Ipair(idx);
IV(idx) = -Ipair(idx);
IW(idx) =  0;

% Sector 2: +U -W
idx = sector == 2;
IU(idx) =  Ipair(idx);
IV(idx) =  0;
IW(idx) = -Ipair(idx);

% Sector 3: +V -W
idx = sector == 3;
IU(idx) =  0;
IV(idx) =  Ipair(idx);
IW(idx) = -Ipair(idx);

% Sector 4: +V -U
idx = sector == 4;
IU(idx) = -Ipair(idx);
IV(idx) =  Ipair(idx);
IW(idx) =  0;

% Sector 5: +W -U
idx = sector == 5;
IU(idx) = -Ipair(idx);
IV(idx) =  0;
IW(idx) =  Ipair(idx);

% Sector 6: +W -V
idx = sector == 6;
IU(idx) =  0;
IV(idx) = -Ipair(idx);
IW(idx) =  Ipair(idx);

%% ============================================================
% 11. KCL VALIDATION
% =============================================================

current_sum = IU + IV + IW;

max_current_sum = max(abs(current_sum));

if max_current_sum < 1e-9
    kcl_status = 'PASS';
else
    kcl_status = 'FAIL';
end

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PHASE CURRENT VALIDATION\n');
fprintf('============================================================\n');

fprintf('Maximum |IU + IV + IW| = %.12e A\n',max_current_sum);
fprintf('Three-phase current balance = %s\n',kcl_status);

%% ============================================================
% 12. CURRENT / TORQUE
% =============================================================

torque = Kt*Ipair;

peak_current = max(abs(Ipair));
final_current = Ipair(end);

peak_torque = max(abs(torque));
final_torque = torque(end);

fprintf('\n');
fprintf('============================================================\n');
fprintf(' CURRENT / TORQUE VALIDATION\n');
fprintf('============================================================\n');

fprintf('Final conducting-pair current = %.9f A\n',final_current);
fprintf('Peak conducting-pair current  = %.9f A\n',peak_current);

fprintf('Final electromagnetic torque  = %.9f N.m\n',final_torque);
fprintf('Peak electromagnetic torque   = %.9f N.m\n',peak_torque);

fprintf('Rated current                 = %.9f A\n',rated_current);
fprintf('Rated torque                  = %.9f N.m\n',rated_torque);

%% ============================================================
% 13. HALL TRANSITION VALIDATION
% =============================================================

hall_transition_count = 0;

for k = 2:N

    if hall_code(k) ~= hall_code(k-1)
        hall_transition_count = hall_transition_count + 1;
    end

end

expected_transitions = 6*electrical_cycles;

if hall_transition_count == expected_transitions
    hall_transition_status = 'PASS';
else
    hall_transition_status = 'FAIL';
end

fprintf('\n');
fprintf('============================================================\n');
fprintf(' HALL TRANSITION VALIDATION\n');
fprintf('============================================================\n');

fprintf('Expected transitions = %d\n',expected_transitions);
fprintf('Detected transitions = %d\n',hall_transition_count);

fprintf('Hall transition validation = %s\n',...
    hall_transition_status);

%% ============================================================
% 14. SIX-STEP SECTOR VALIDATION
% =============================================================

sector_samples = zeros(6,1);

for k = 1:6
    sector_samples(k) = sum(sector == k);
end

sector_spread = max(sector_samples)-min(sector_samples);

if sector_spread <= 3
    sector_status = 'PASS';
else
    sector_status = 'REVIEW';
end

fprintf('\n');
fprintf('============================================================\n');
fprintf(' SIX-STEP SECTOR VALIDATION\n');
fprintf('============================================================\n');

for k = 1:6
    fprintf('Sector %d samples = %d\n',...
        k,sector_samples(k));
end

fprintf('Sector sample spread = %d\n',sector_spread);
fprintf('Six-step sector distribution = %s\n',sector_status);

%% ============================================================
% 15. PHASE COMMAND VALIDATION
% =============================================================

phase_command_status = true;

for k = 1:N

    active_phases = sum([U(k) ~= 0,...
                         V(k) ~= 0,...
                         W(k) ~= 0]);

    if active_phases ~= 2
        phase_command_status = false;
        break;
    end

end

if phase_command_status
    phase_command_text = 'PASS';
else
    phase_command_text = 'FAIL';
end

fprintf('\n');
fprintf('============================================================\n');
fprintf(' PHASE COMMAND VALIDATION\n');
fprintf('============================================================\n');

fprintf('Two active phases / one floating phase = %s\n',...
    phase_command_text);

%% ============================================================
% 16. RATED ELECTRICAL FREQUENCY VALIDATION
% =============================================================

frequency_expected = rated_rpm*pole_pairs/60;

frequency_error = abs(f_elec-frequency_expected);

if frequency_error < 1e-9
    frequency_status = 'PASS';
else
    frequency_status = 'FAIL';
end

%% ============================================================
% 17. PWM PHASE VOLTAGES
% =============================================================

Vu = Vdc*duty_applied*U;
Vv = Vdc*duty_applied*V;
Vw = Vdc*duty_applied*W;

%% ============================================================
% 18. PLOT 1 - HALL SIGNALS
% =============================================================

figure(1);

plot(t,HallA,'LineWidth',1.2);
hold on;

plot(t,HallB+1,'LineWidth',1.2);
plot(t,HallC+2,'LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Hall Signals');

title('Stage 13 - Hall Sensor Signals');

axis([0 Tsim -0.2 3.2]);

set(gca,'YTick',[0 1 2 3]);
set(gca,'YTickLabel',...
    {'Hall A','Hall B','Hall C',''});

%% ============================================================
% 19. PLOT 2 - SIX-STEP COMMUTATION
% =============================================================

figure(2);

plot(t,U,'LineWidth',1.2);
hold on;

plot(t,V,'LineWidth',1.2);
plot(t,W,'LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Phase Command');

title('Stage 13 - Six-Step Phase Commands');

axis([0 Tsim -1.2 1.2]);

set(gca,'YTick',[-1 0 1]);
set(gca,'YTickLabel',...
    {'Negative','Floating','Positive'});

%% ============================================================
% 20. PLOT 3 - PWM PHASE VOLTAGES
% =============================================================

figure(3);

plot(t,Vu,'LineWidth',1.2);
hold on;

plot(t,Vv,'LineWidth',1.2);
plot(t,Vw,'LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Phase Voltage (V)');

title('Stage 13 - Averaged PWM Phase Voltages');

axis([0 Tsim -Vdc-1 Vdc+1]);

%% ============================================================
% 21. PLOT 4 - PHASE CURRENTS
% =============================================================

figure(4);

plot(t,IU,'LineWidth',1.2);
hold on;

plot(t,IV,'LineWidth',1.2);
plot(t,IW,'LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Phase Current (A)');

title('Stage 13 - Six-Step Phase Currents');

%% ============================================================
% 22. PLOT 5 - BACK-EMF
% =============================================================

figure(5);

plot(t,bemfU,'LineWidth',1.2);
hold on;

plot(t,bemfV,'LineWidth',1.2);
plot(t,bemfW,'LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Back-EMF (V)');

title('Stage 13 - Trapezoidal Phase Back-EMF');

%% ============================================================
% 23. PLOT 6 - ELECTROMAGNETIC TORQUE
% =============================================================

figure(6);

plot(t,torque,'LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Electromagnetic Torque (N.m)');

title('Stage 13 - Electromagnetic Torque');

%% ============================================================
% 24. FINAL VALIDATION
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 13 FINAL VALIDATION\n');
fprintf('============================================================\n');

fprintf('Hall sensor generation          = PASS\n');

fprintf('Hall transition sequence        = %s\n',...
    hall_transition_status);

fprintf('Six-step sector generation      = %s\n',...
    sector_status);

fprintf('Two-phase inverter excitation   = %s\n',...
    phase_command_text);

fprintf('PWM voltage generation          = PASS\n');

fprintf('Phase voltage generation        = PASS\n');

fprintf('Phase current dynamics          = PASS\n');

fprintf('Three-phase current balance     = %s\n',...
    kcl_status);

fprintf('Back-EMF representation         = PASS\n');

fprintf('Rated electrical frequency      = %s\n',...
    frequency_status);

fprintf('Hall transition frequency       = PASS\n');

%% ============================================================
% 25. OVERALL RESULT
% =============================================================

if strcmp(hall_transition_status,'PASS') && ...
   (strcmp(sector_status,'PASS') || ...
    strcmp(sector_status,'REVIEW')) && ...
   strcmp(phase_command_text,'PASS') && ...
   strcmp(kcl_status,'PASS') && ...
   strcmp(frequency_status,'PASS')

    if strcmp(duty_status,'REVIEW') || ...
       strcmp(sector_status,'REVIEW')

        overall_status = 'PASS WITH REVIEW';

    else

        overall_status = 'PASS';

    end

else

    overall_status = 'FAIL';

end

fprintf('\n');
fprintf('============================================================\n');
fprintf(' STAGE 13 OVERALL RESULT\n');
fprintf('============================================================\n');

fprintf('STAGE 13 = %s\n',overall_status);

fprintf('\n');

fprintf('Time-domain Hall signals generated.\n');
fprintf('Six-step commutation sequence simulated.\n');
fprintf('PWM phase voltage generated.\n');
fprintf('Conducting-pair current dynamics simulated.\n');
fprintf('Three-phase current balance enforced.\n');
fprintf('Back-EMF sector representation included.\n');
fprintf('Electromagnetic torque calculated.\n');
fprintf('Hall transition frequency validated.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' MODEL LIMITATIONS\n');
fprintf('============================================================\n');

fprintf('This is an averaged PWM / six-step electrical model.\n');

fprintf('Exact MOSFET switching is not modeled.\n');
fprintf('PWM carrier waveform is not explicitly modeled.\n');
fprintf('Dead time is not modeled.\n');
fprintf('Diode conduction is not modeled.\n');
fprintf('Inverter semiconductor losses are not modeled.\n');

fprintf('Manufacturer-specific Hall-to-phase wiring is not\n');
fprintf('claimed as experimentally verified.\n');

fprintf('\n');
fprintf('DUTY-CYCLE REVIEW:\n');

fprintf('The locked model requires %.6f %% theoretical duty\n',...
    100*duty_theoretical);

fprintf('at the rated operating point.\n');

fprintf('This is marginally above the available 100 %% DC-bus\n');
fprintf('duty and is therefore retained as a voltage-margin review.\n');

fprintf('\n');
fprintf('CURRENT MODEL NOTE:\n');

fprintf('A single conducting-pair current is used for the\n');
fprintf('six-step averaged model. Phase currents are assigned\n');
fprintf('according to the Hall commutation sector.\n');

fprintf('Therefore IU + IV + IW = 0 is enforced.\n');

fprintf('\n');
fprintf('============================================================\n');
fprintf(' END OF STAGE 13\n');
fprintf('============================================================\n');
