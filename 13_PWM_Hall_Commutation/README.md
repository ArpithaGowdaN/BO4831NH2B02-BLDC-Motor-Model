
============================================================
 BO4831NH2B02-101-24.0
 STAGE 13 - PWM + HALL SIX-STEP TIME-DOMAIN VALIDATION
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
 SPEED / ELECTRICAL FREQUENCY
============================================================
Mechanical speed          = 806.342114421380 rad/s
Mechanical frequency      = 128.333333333333 Hz
Electrical frequency      = 898.333333333333 Hz
Electrical angular speed  = 5644.394800949662 rad/s
Commutation frequency     = 5390.000000000000 Hz
Hall transition frequency = 5390.000000000000 Hz

============================================================
 SIMULATION SETTINGS
============================================================
Electrical cycles = 2
Simulation time   = 0.002226345083 s
Time step         = 3.710575139147e-07 s
Simulation points = 6001

============================================================
 PWM DUTY CYCLE
============================================================
Rated back-EMF          = 22.592093362 V
Rated I*R drop          = 1.408000000 V
Required voltage       = 24.000093362 V
Required theoretical duty = 1.000003890
Required theoretical duty = 100.000389 %
Applied simulation duty  = 1.000000000
Applied simulation duty  = 100.000000 %
Theoretical duty feasibility = REVIEW

============================================================
 PHASE CURRENT VALIDATION
============================================================
Maximum |IU + IV + IW| = 0.000000000000e+00 A
Three-phase current balance = PASS

============================================================
 CURRENT / TORQUE VALIDATION
============================================================
Final conducting-pair current = 15.700313509 A
Peak conducting-pair current  = 15.700313509 A
Final electromagnetic torque  = 0.398756562 N.m
Peak electromagnetic torque   = 0.398756562 N.m
Rated current                 = 17.600000000 A
Rated torque                  = 0.447000000 N.m

============================================================
 HALL TRANSITION VALIDATION
============================================================
Expected transitions = 12
Detected transitions = 12
Hall transition validation = PASS

============================================================
 SIX-STEP SECTOR VALIDATION
============================================================
Sector 1 samples = 1001
Sector 2 samples = 1000
Sector 3 samples = 1000
Sector 4 samples = 1000
Sector 5 samples = 1000
Sector 6 samples = 1000
Sector sample spread = 1
Six-step sector distribution = PASS

============================================================
 PHASE COMMAND VALIDATION
============================================================
Two active phases / one floating phase = PASS

============================================================
 STAGE 13 FINAL VALIDATION
============================================================
Hall sensor generation          = PASS
Hall transition sequence        = PASS
Six-step sector generation      = PASS
Two-phase inverter excitation   = PASS
PWM voltage generation          = PASS
Phase voltage generation        = PASS
Phase current dynamics          = PASS
Three-phase current balance     = PASS
Back-EMF representation         = PASS
Rated electrical frequency      = PASS
Hall transition frequency       = PASS

============================================================
 STAGE 13 OVERALL RESULT
============================================================
STAGE 13 = PASS WITH REVIEW

Time-domain Hall signals generated.
Six-step commutation sequence simulated.
PWM phase voltage generated.
Conducting-pair current dynamics simulated.
Three-phase current balance enforced.
Back-EMF sector representation included.
Electromagnetic torque calculated.
Hall transition frequency validated.

============================================================
 MODEL LIMITATIONS
============================================================
This is an averaged PWM / six-step electrical model.
Exact MOSFET switching is not modeled.
PWM carrier waveform is not explicitly modeled.
Dead time is not modeled.
Diode conduction is not modeled.
Inverter semiconductor losses are not modeled.
Manufacturer-specific Hall-to-phase wiring is not
claimed as experimentally verified.

DUTY-CYCLE REVIEW:
The locked model requires 100.000389 % theoretical duty
at the rated operating point.
This is marginally above the available 100 % DC-bus
duty and is therefore retained as a voltage-margin review.

CURRENT MODEL NOTE:
A single conducting-pair current is used for the
six-step averaged model. Phase currents are assigned
according to the Hall commutation sector.
Therefore IU + IV + IW = 0 is enforced.

============================================================
 END OF STAGE 13
============================================================
<img width="1637" height="946" alt="image" src="https://github.com/user-attachments/assets/8ffc4b66-7f2f-4cab-90ce-1f8753936909" />
