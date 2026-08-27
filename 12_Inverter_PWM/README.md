
============================================================
 BO4831NH2B02-101-24.0
 STAGE 12 - INVERTER & PWM VALIDATION
============================================================

============================================================
 LOCKED MOTOR PARAMETERS
============================================================
DC voltage          = 24.000000 V
Resistance          = 0.08000000 Ohm
Inductance          = 8.00000000e-05 H
Effective Ke        = 0.02801800 V.s/rad
Effective Kt        = 0.02539800 N.m/A
Rotor inertia       = 3.06000000e-05 kg.m^2
Pole pairs          = 7
Rated speed         = 7700.00 rpm
Rated current       = 17.60 A
Rated torque        = 0.447000 N.m

============================================================
 MOTOR CONFIGURATION
============================================================
Motor type          = Sensored BLDC
Rotor configuration = Outer Rotor
Position sensing    = 3 Hall sensors
Commutation         = Six-step electronic commutation
Inverter            = 3-phase voltage-source inverter
PWM                 = Duty-cycle based voltage control

============================================================
 HALL STATE SEQUENCE
============================================================
Sector 1 = 001
Sector 2 = 101
Sector 3 = 100
Sector 4 = 110
Sector 5 = 010
Sector 6 = 011

============================================================
 SIX-STEP INVERTER SWITCHING TABLE
============================================================

 Sector   Hall      High Phase   Low Phase   Floating Phase
 -----------------------------------------------------------
   1      001          +U          -V            W
   2      101          +U          -W            V
   3      100          +V          -W            U
   4      110          +V          -U            W
   5      010          +W          -U            V
   6      011          +W          -V            U

============================================================
 INVERTER STRUCTURE VALIDATION
============================================================
Two-phase excitation structure = PASS

============================================================
 PHASE PARTICIPATION VALIDATION
============================================================
Phase U participates in 4 / 6 sectors
Phase V participates in 4 / 6 sectors
Phase W participates in 4 / 6 sectors
Phase participation symmetry = PASS

============================================================
 PWM DUTY-CYCLE / AVERAGE VOLTAGE RELATIONSHIP
============================================================

 Duty Cycle       Average Voltage (V)
 ------------------------------------
    0.25               6.000000
    0.50               12.000000
    0.75               18.000000
    1.00               24.000000

============================================================
 PWM VALIDATION
============================================================
0% duty cycle      = 0.000000 V
50% duty cycle     = 12.000000 V
100% duty cycle    = 24.000000 V
PWM average-voltage relationship = PASS

============================================================
 RATED-SPEED BACK-EMF
============================================================
Rated mechanical speed = 806.342114 rad/s
Back-EMF               = 22.592093362 V

============================================================
 RATED-POINT PWM VOLTAGE REQUIREMENT
============================================================
Back-EMF             = 22.592093362 V
I*R voltage drop     = 1.408000000 V
Required voltage     = 24.000093362 V
Available DC voltage = 24.000000000 V
Required duty cycle  = 1.000003890
Required duty cycle  = 100.000389 %

============================================================
 PWM DUTY-CYCLE FEASIBILITY
============================================================
Required duty cycle = 100.000389 %
Duty-cycle margin   = -0.000389 %
Rated operating point within 0-100% duty range = FAIL

============================================================
 PWM + PHASE CURRENT CHECK
============================================================
Effective voltage = 1.407906638 V
Predicted current = 17.598832977 A
Rated current     = 17.600000000 A
Current error     = 0.001167023 A
Current error     = 0.006630814 %
Rated current consistency = PASS

============================================================
 COMMUTATION FREQUENCY
============================================================
Rated mechanical speed = 128.333333 rev/s
Electrical frequency    = 898.333333 Hz
Commutation frequency   = 5390.000000 Hz

============================================================
 SENSORED BLDC INVERTER CONTROL FLOW
============================================================

Hall A/B/C
     |
     v
Hall state detection
     |
     v
Electrical sector identification
     |
     v
Six-step commutation table
     |
     v
PWM duty-cycle command
     |
     v
3-phase inverter
     |
     v
Phase voltage
     |
     v
Phase R-L current dynamics
     |
     v
Electromagnetic torque
     |
     v
Mechanical speed

============================================================
 STAGE 12 FINAL VALIDATION
============================================================
Six-step inverter structure       = PASS
Phase participation symmetry      = PASS
PWM average-voltage relationship  = PASS
Rated-point duty feasibility      = FAIL
Rated current consistency         = PASS
Hall-to-inverter architecture     = PASS
Commutation frequency calculation = PASS

============================================================
 STAGE 12 OVERALL RESULT
============================================================
STAGE 12 = PASS WITH REVIEW

Three-phase inverter structure validated.
Six-step phase excitation validated.
PWM duty-cycle relationship validated.
Rated-point duty-cycle feasibility evaluated.
Rated-speed electrical frequency calculated.
Hall-to-inverter control architecture verified.

IMPORTANT MODEL LIMITATION:
This stage uses an averaged inverter voltage model.
Individual MOSFET switching losses, dead time,
device voltage drops and detailed PWM carrier
switching are not modeled yet.

============================================================
<img width="1122" height="510" alt="image" src="https://github.com/user-attachments/assets/ebcbf9db-0c88-44ea-83bd-0ae00cc53763" />

 END OF STAGE 12
============================================================
>> 
