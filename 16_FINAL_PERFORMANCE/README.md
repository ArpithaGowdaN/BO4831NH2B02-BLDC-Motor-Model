
============================================================
 BO4831NH2B02-101-24.0
 STAGE 16 - FINAL PERFORMANCE CHARACTERISTICS & VALIDATION
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
Mechanical damping  = 1.00000000e-05 N.m.s/rad
Pole pairs          = 7
Rated speed         = 7700.00 rpm
Rated current       = 17.60 A
Rated torque        = 0.447 N.m
PI Kp               = 0.150000
PI Ki               = 8.000000

============================================================
 DATASHEET REFERENCE VALUES
============================================================
Datasheet voltage       = 24.000000 V
Datasheet resistance    = 0.08000000 Ohm
Datasheet Ke            = 0.02291831 V.s/rad
Datasheet Kt            = 0.02250000 N.m/A
Datasheet inertia       = 3.06000000e-05 kg.m^2
Datasheet pole pairs    = 7
Datasheet rated speed   = 7700.00 rpm
Datasheet rated current = 17.60 A
Datasheet rated torque  = 0.447 N.m

============================================================
 MODEL VS DATASHEET COMPARISON
============================================================
Ke model                 = 0.02801800 V.s/rad
Ke datasheet             = 0.02291831 V.s/rad
Ke difference            = 22.251587 %

Kt model                 = 0.02539800 N.m/A
Kt datasheet             = 0.02250000 N.m/A
Kt difference            = 12.880000 %

Rated speed difference   = 0.000000 %
Rated current difference = 0.000000 %
Rated torque difference  = 0.000000 %

============================================================
 RATED OPERATING POINT
============================================================
Rated speed             = 7700.000000 rpm
Mechanical speed        = 806.342114 rad/s
Mechanical frequency    = 128.333333 Hz
Electrical frequency    = 898.333333 Hz
Electrical speed        = 5644.394801 rad/s
Rated back-EMF          = 22.592093 V
I*R voltage drop        = 1.408000 V
Required voltage        = 24.000093362 V
Required duty           = 1.000003890
Required duty           = 100.000389 %
Calculated torque       = 0.447004800 N.m
Rated mechanical power  = 360.434925146 W
DC electrical power     = 422.400000000 W
Simplified efficiency   = 85.330238 %

============================================================
 MOTOR TRANSFER FUNCTION
============================================================

Gmotor =
 
                  0.0254
  ---------------------------------------
  2.448e-09 s^2 + 2.449e-06 s + 0.0007124
 
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
 CLOSED-LOOP SPEED RESPONSE
============================================================
Closed-loop DC gain     = 1.000000000
Final simulated speed   = 0.995612692
Final speed error       = 0.004387308
Final speed error       = 0.438730804 %

Closed-loop performance:
Rise time               = 0.001222 s
Settling time           = 0.042321 s
Overshoot               = 13.548731 %

============================================================
 LOAD DISTURBANCE RESPONSE
============================================================
Disturbance time          = 1.000000 s
Applied load torque       = 0.200000000 N.m
Pre-disturbance speed     = 7699.769618875 rpm
Minimum post-disturbance = 7366.717410162 rpm
Speed drop                = 333.052208713 rpm
Final speed               = 7699.797658016 rpm
Final speed error         = 0.202341984 rpm
Final speed error         = 0.002627818 %

============================================================
 LOAD TORQUE / TORQUE BALANCE
============================================================
Applied load torque       = 0.200000000 N.m
Viscous torque            = 0.008063421 N.m
Required steady torque    = 0.208063421 N.m
Required steady current   = 8.192118322 A

============================================================
 STAGE 16 FINAL VALIDATION
============================================================
Rated speed datasheet validation       = PASS
Rated current datasheet validation     = PASS
Rated torque datasheet validation      = PASS
Back-EMF constant validation           = REVIEW
Torque constant validation             = REVIEW
PWM duty feasibility                   = REVIEW

============================================================
 FINAL STAGE 16 COMPLETE
============================================================

The BLDC motor performance characteristics,
closed-loop response, load disturbance response,
and datasheet comparison have been completed.

<img width="1665" height="900" alt="image" src="https://github.com/user-attachments/assets/16adf266-0a45-465c-b640-4ea0b63e0d43" />
<img width="1612" height="927" alt="image" src="https://github.com/user-attachments/assets/379e10c1-e31d-4d55-b42b-46d02add5384" />

