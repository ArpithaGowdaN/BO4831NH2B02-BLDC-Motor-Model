| Parameter            |         Result |
| -------------------- | -------------: |
| Rated speed          |       7700 rpm |
| Mechanical speed     |  806.342 rad/s |
| Electrical frequency |     898.333 Hz |
| Model back-EMF       |      22.5921 V |
| Rated current        |         17.6 A |
| Calculated torque    |  0.4470048 N·m |
| Datasheet torque     |  0.4470000 N·m |
| Torque error         | **0.00107%** ✅ |
| Mechanical power     |      360.439 W |
| DC input reference   |        422.4 W |


============================================================
 BO4831NH2B02-101-24.0
 STAGE 10 - BACK-EMF & ELECTROMAGNETIC TORQUE VALIDATION
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
 MODEL CONSTANTS VS DATASHEET REFERENCE
============================================================
Locked model Ke       = 0.02801800 V.s/rad
Datasheet Ke          = 0.02291831 V.s/rad
Ke difference         = 22.251597 %

Locked model Kt       = 0.02539800 N.m/A
Datasheet Kt          = 0.02250000 N.m/A
Kt difference         = 12.880000 %

NOTE: Locked model constants are retained.
Datasheet constants are reference values only.

============================================================
 SPEED CONVERSION
============================================================
Rated speed          = 7700.00 rpm
Mechanical speed     = 806.342114 rad/s
Mechanical speed     = 128.333333 rev/s
Electrical speed     = 5644.394801 rad/s
Electrical frequency = 898.333333 Hz

============================================================
 BACK-EMF VALIDATION AT RATED SPEED
============================================================
Locked model Ke      = 0.02801800 V.s/rad
Model back EMF       = 22.59209336 V
Datasheet-based EMF  = 18.47999854 V
Available DC voltage = 24.00000000 V
Model EMF difference = 22.251597 %

============================================================
 RATED-POINT ELECTRICAL BALANCE
============================================================
Rated current        = 17.600000 A
I*R voltage drop     = 1.40800000 V
Back EMF             = 22.59209336 V
Required voltage     = 24.00009336 V
Available Vdc        = 24.00000000 V
Voltage difference   = 0.00038901 %
Rated voltage balance = PASS

============================================================
 ELECTROMAGNETIC TORQUE VALIDATION
============================================================
Torque constant      = 0.02539800 N.m/A
Rated current        = 17.600000 A
Calculated torque    = 0.447004800 N.m
Datasheet torque     = 0.447000000 N.m
Torque difference     = 0.001073826 %
Rated torque validation = PASS

============================================================
 TORQUE-CURRENT RELATIONSHIP
============================================================
Equation:
T_e = Kt * I
Kt = 0.02539800 N.m/A
At 1 A       -> 0.02539800 N.m
At 5 A       -> 0.12699000 N.m
At 10 A      -> 0.25398000 N.m
At 17.6 A    -> 0.44700480 N.m

============================================================
 BACK-EMF VS SPEED RELATIONSHIP
============================================================
Equation:
E = Ke * omega
Ke = 0.02801800 V.s/rad

============================================================
 BACK-EMF SPEED CHECKS
============================================================

 Speed (rpm)       Speed (rad/s)       Back-EMF (V)
 -----------------------------------------------------
        0              0.000000           0.000000
     2000            209.439510           5.868076
     5000            523.598776          14.670190
     7700            806.342114          22.592093
    10000           1047.197551          29.340381

============================================================
 ELECTROMAGNETIC / MECHANICAL POWER
============================================================
Electromagnetic torque = 0.447004800 N.m
Mechanical speed       = 806.342114421 rad/s
Mechanical power       = 360.438796 W

============================================================
 ELECTRICAL POWER REFERENCE
============================================================
DC voltage             = 24.000000 V
Rated current          = 17.600000 A
DC electrical power    = 422.400000 W

NOTE:
DC input power is a reference quantity only.
It is not treated as exact BLDC phase power because
inverter and switching losses are not modeled yet.

============================================================
 TORQUE / BACK-EMF CONSTANT RELATIONSHIP
============================================================
Locked Ke = 0.02801800 V.s/rad
Locked Kt = 0.02539800 N.m/A

For the locked averaged model, Ke and Kt are retained
as independently defined effective constants.
Therefore no forced Ke = Kt equality is imposed here.

============================================================
 POWER FROM TORQUE CHECK
============================================================
Torque                  = 0.447004800 N.m
Angular speed           = 806.342114421 rad/s
P = T*omega             = 360.438796 W

============================================================
 STAGE 10 FINAL VALIDATION
============================================================
Rated-speed conversion       = PASS
Rated voltage balance        = PASS
Rated electromagnetic torque = PASS
Back-EMF calculation         = PASS
Torque-current relationship   = PASS
Back-EMF-speed relationship  = PASS
Electrical frequency         = PASS

============================================================
 STAGE 10 OVERALL RESULT
============================================================
STAGE 10 = PASS

Back-EMF model validated.
Electromagnetic torque validated.
Torque-current relationship validated.
Back-EMF-speed relationship validated.
Rated electrical frequency calculated.
Mechanical power calculated.

IMPORTANT MODEL LIMITATION:
Phase trapezoidal back-EMF waveform, inverter switching,
PWM and detailed phase-current commutation are not yet
modeled. These will be addressed in later stages.

============================================================
 END OF STAGE 10
============================================================
<img width="1112" height="512" alt="image" src="https://github.com/user-attachments/assets/b83bde86-7cfa-4ce2-a701-b84478ac714e" />
