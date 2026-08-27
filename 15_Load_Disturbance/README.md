
============================================================
 BO4831NH2B02-101-24.0
 STAGE 15 - LOAD DISTURBANCE & TORQUE REJECTION VALIDATION
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
Rated torque        = 0.447 N.m

PI controller:
Kp                  = 0.150000
Ki                  = 8.000000

============================================================
 SPEED CONVERSION
============================================================
Rated speed         = 7700.000000 rpm
Rated angular speed = 806.342114421380 rad/s

============================================================
 MECHANICAL DAMPING
============================================================
Viscous damping B     = 1.00000000e-05 N.m.s/rad
Status                = MODEL ASSUMPTION

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
 CLOSED-LOOP TRANSFER FUNCTION
============================================================

Tclosed =
 
                  0.00381 s + 0.2032
  ---------------------------------------------------
  2.448e-09 s^3 + 2.449e-06 s^2 + 0.004522 s + 0.2032
 
Continuous-time transfer function.


============================================================
 LOAD DISTURBANCE TRANSFER FUNCTION
============================================================

Tdisturbance =
 
                                                                  
      -1.958e-13 s^4 - 3.917e-10 s^3 - 2.529e-07 s^2 - 5.699e-05 s
                                                                  
  ---------------------------------------------------------------------
                                                                       
  5.993e-18 s^5 + 1.199e-14 s^4 + 1.881e-11 s^3 + 1.332e-08 s^2        
                                                                       
                                              + 3.719e-06 s + 0.0001447
                                                                       
 
Continuous-time transfer function.


============================================================
 CLOSED-LOOP POLES
============================================================
Pole 1 = -477.150559975858 +1255.256362253796j
Pole 2 = -477.150559975858 -1255.256362253796j
Pole 3 = -46.025677433904 +0.000000000000j
Closed-loop stability = PASS

============================================================
 DISTURBANCE SETTINGS
============================================================
Speed reference       = 7700.00 rpm
Disturbance time      = 0.075000 s
Initial load torque   = 0.000000 N.m
Applied load torque   = 0.447000 N.m
Simulation time       = 0.150000 s
Time step             = 0.00001000 s
Simulation points     = 15001

============================================================
 LOAD DISTURBANCE RESPONSE
============================================================
Pre-disturbance speed     = 7665.762367 rpm
Minimum post-disturbance  = 7546.583552 rpm
Speed drop                = 119.178816 rpm
Final speed               = 7696.522103 rpm

Final speed error         = 3.477896520 rpm
Final speed error         = 0.045167487 %

Applied load torque       = 0.447000 N.m
Final electromagnetic torque = 0.455572838 N.m
Required steady torque    = 0.455059779 N.m
Torque balance error      = 5.130584412382e-04 N.m

2% disturbance recovery time = 0.001490000 s
Speed remained within +/-2% band.

============================================================
 STAGE 15 VALIDATION
============================================================
Closed-loop disturbance stability = PASS
Load disturbance response         = PASS
Final speed tracking              = PASS
Disturbance recovery              = PASS
Torque balance                    = REVIEW

Final speed tracking criterion    = <= 0.50 %

============================================================
 STAGE 15 FINAL VALIDATION
============================================================
Closed-loop stability        = PASS
Load disturbance rejection  = PASS
Speed recovery              = PASS
Final speed tracking        = PASS
Torque balance              = REVIEW

============================================================
 STAGE 15 OVERALL RESULT
============================================================
STAGE 15 = PASS WITH REVIEW

Load disturbance response evaluated.
Speed deviation evaluated.
PI torque rejection evaluated.
Final speed tracking evaluated.
Electromagnetic torque balance evaluated.

============================================================
 SENSORED BLDC CONTROL ARCHITECTURE
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
 MODEL LIMITATIONS
============================================================
Mechanical damping is a model assumption.
Load torque is an imposed simulation disturbance.
Exact load-torque characteristics are not manufacturer verified.
Exact MOSFET switching is not modeled.
PWM carrier ripple is not modeled.
Dead time is not modeled.
Inverter semiconductor losses are not modeled.
Hall-to-phase wiring is not experimentally verified.
Thermal effects are not modeled.

============================================================
<img width="1676" height="933" alt="image" src="https://github.com/user-attachments/assets/a998f35d-0ff4-4479-9d95-658a630aede4" />


 END OF STAGE 15
============================================================
>> 
