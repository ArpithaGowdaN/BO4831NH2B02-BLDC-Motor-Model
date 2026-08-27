
============================================================
 BO4831NH2B02-101-24.0
 STAGE 14 - SENSORED BLDC CLOSED-LOOP PERFORMANCE SWEEP
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

PI controller:
Kp                  = 0.150000
Ki                  = 8.000000

============================================================
 MOTOR TRANSFER FUNCTION
============================================================

Gmotor =
 
                  0.0254
  ---------------------------------------
  2.448e-09 s^2 + 2.448e-06 s + 0.0007116
 
Continuous-time transfer function.


============================================================
 PI CONTROLLER
============================================================

PI =
 
  0.15 s + 8
  ----------
      s
 
Continuous-time transfer function.


============================================================
 CLOSED-LOOP TRANSFER FUNCTION
============================================================

Tclosed =
 
                  0.00381 s + 0.2032
  ---------------------------------------------------
  2.448e-09 s^3 + 2.448e-06 s^2 + 0.004521 s + 0.2032
 
Continuous-time transfer function.


============================================================
 CLOSED-LOOP POLES
============================================================
Pole 1 = -476.983087775509 +1255.192882596360j
Pole 2 = -476.983087775509 -1255.192882596360j
Pole 3 = -46.033824448982 +0.000000000000j
Closed-loop stability = PASS

============================================================
 SPEED REFERENCES
============================================================
2000 rpm = 209.439510239320 rad/s
5000 rpm = 523.598775598299 rad/s
7700 rpm = 806.342114421380 rad/s

============================================================
 SIMULATION SETTINGS
============================================================
Simulation time = 0.150000 s
Time step       = 0.00001000 s
Simulation points = 15001

============================================================
 CLOSED-LOOP SPEED RESPONSE SWEEP
============================================================

2000 rpm reference:
  Final speed       = 1999.719020033 rpm
  Peak speed        = 2271.586561408 rpm
  Rise time         = 0.001220000 s
  Settling time     = 0.042290000 s
  Overshoot         = 13.579328 %
  Steady-state error= 0.280979967 rpm
  Error percentage  = 0.014048998 %

5000 rpm reference:
  Final speed       = 4999.297550083 rpm
  Peak speed        = 5678.966403520 rpm
  Rise time         = 0.001220000 s
  Settling time     = 0.042290000 s
  Overshoot         = 13.579328 %
  Steady-state error= 0.702449917 rpm
  Error percentage  = 0.014048998 %

7700 rpm reference:
  Final speed       = 7698.918227128 rpm
  Peak speed        = 8745.608261421 rpm
  Rise time         = 0.001220000 s
  Settling time     = 0.042290000 s
  Overshoot         = 13.579328 %
  Steady-state error= 1.081772872 rpm
  Error percentage  = 0.014048998 %

============================================================
 MULTI-SPEED TRACKING VALIDATION
============================================================
2000 rpm tracking = PASS
5000 rpm tracking = PASS
7700 rpm tracking = PASS

============================================================
 RATED SPEED VALIDATION
============================================================
Rated reference     = 7700.00 rpm
Final simulated     = 7698.918227128 rpm
Absolute error      = 1.081772872 rpm
Percentage error    = 0.014048998 %
Rated speed tracking = PASS

============================================================
 CLOSED-LOOP DC GAIN
============================================================
Closed-loop DC gain = 1.000000000000
DC gain validation = PASS

============================================================
 RATED-POINT PWM DUTY CHECK
============================================================
Rated back-EMF       = 22.592093362 V
Rated I*R drop        = 1.408000000 V
Required voltage      = 24.000093362 V
Available DC voltage  = 24.000000000 V
Required duty         = 1.000003890
Required duty         = 100.000389 %
Duty-cycle feasibility = REVIEW

============================================================
 RATED CURRENT / TORQUE CHECK
============================================================
Rated current          = 17.600000 A
Calculated torque      = 0.447004800 N.m
Datasheet torque       = 0.447000000 N.m
Torque difference      = 0.001073826 %
Rated torque validation = PASS

============================================================
 SENSORED BLDC CLOSED-LOOP ARCHITECTURE
============================================================

Speed reference
      |
      v
 PI speed controller
      |
      v
 PWM duty command
      |
      v
 3-phase inverter
      |
      v
 Six-step commutation
      |
      v
 BLDC phase currents
      |
      v
 Electromagnetic torque
      |
      v
 Mechanical speed
      |
      v
 Hall sensors
      |
      +-------- feedback --------+

============================================================
 PERFORMANCE SUMMARY
============================================================

 Reference    Final Speed    Peak Speed    Rise Time    Settling Time    Overshoot
   (rpm)         (rpm)          (rpm)          (s)            (s)            (%)
    2000     1999.719020    2271.586561      0.001220         0.042290      13.579328
    5000     4999.297550    5678.966404      0.001220         0.042290      13.579328
    7700     7698.918227    8745.608261      0.001220         0.042290      13.579328

============================================================
 STAGE 14 FINAL VALIDATION
============================================================
Closed-loop stability       = PASS
Closed-loop DC gain         = PASS
Multi-speed tracking        = PASS
Rated-speed tracking        = PASS
Rated torque consistency    = PASS
PWM duty feasibility        = REVIEW

============================================================
 STAGE 14 OVERALL RESULT
============================================================
STAGE 14 = PASS WITH REVIEW

Sensored BLDC closed-loop speed response evaluated.
PI speed control validated.
Multi-speed tracking evaluated.
Rated-speed tracking evaluated.
Closed-loop stability verified.
Rated-point PWM duty requirement evaluated.
Rated torque consistency evaluated.

IMPORTANT MODEL LIMITATION:
This stage uses the validated averaged electromechanical
plant together with the sensored BLDC architecture.
Exact MOSFET switching, PWM carrier ripple, dead time,
device voltage drops and manufacturer-specific Hall-to-
phase wiring are not experimentally verified.

============================================================
<img width="550" height="501" alt="image" src="https://github.com/user-attachments/assets/73545103-c2af-4ea0-9599-b42ef733fdf9" />

 END OF STAGE 14
============================================================
>> 
