| Validation                     | Result      |
| ------------------------------ | ----------- |
| Six-step commutation structure | ✅ PASS      |
| 3-phase excitation             | ✅ PASS      |
| 2 phases energized             | ✅ PASS      |
| 1 phase floating               | ✅ PASS      |
| Phase conduction symmetry      | ✅ PASS      |
| Floating-phase distribution    | ✅ PASS      |
| 60° electrical sectors         | ✅ PASS      |
| 120° conduction                | ✅ PASS      |
| Invalid Hall states            | ✅ PASS      |
| 7 pole-pair relationship       | ✅ PASS      |
| Rated commutation frequency    | **5390 Hz** |
| Overall                        | **✅ PASS**  |



============================================================
 BO4831NH2B02-101-24.0
 STAGE 9 - SIX-STEP COMMUTATION & PHASE EXCITATION
============================================================

============================================================
 MOTOR CONFIGURATION
============================================================
Motor                = BO4831NH2B02-101-24.0
Motor type           = Sensored BLDC
Rotor configuration  = Outer Rotor
Position sensing     = Hall sensors
DC voltage           = 24.000000 V
Pole pairs           = 7
Rated speed          = 7700.00 rpm

============================================================
 HALL STATES
============================================================
Sector 1 : Hall = 001
Sector 2 : Hall = 101
Sector 3 : Hall = 100
Sector 4 : Hall = 110
Sector 5 : Hall = 010
Sector 6 : Hall = 011

============================================================
 SIX-STEP COMMUTATION TABLE
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
 COMMUTATION STRUCTURE VALIDATION
============================================================
Two-phase excitation structure = PASS

============================================================
 PHASE CONDUCTION CHECK
============================================================
Phase U participates in 4 / 6 sectors
Phase V participates in 4 / 6 sectors
Phase W participates in 4 / 6 sectors
Phase conduction symmetry = PASS

============================================================
 FLOATING PHASE VALIDATION
============================================================
U floating sectors = 2
V floating sectors = 2
W floating sectors = 2
Floating-phase distribution = PASS

============================================================
 ELECTRICAL COMMUTATION SECTORS
============================================================
Sector 1 : 0.0 deg to 60.0 deg
Sector 2 : 60.0 deg to 120.0 deg
Sector 3 : 120.0 deg to 180.0 deg
Sector 4 : 180.0 deg to 240.0 deg
Sector 5 : 240.0 deg to 300.0 deg
Sector 6 : 300.0 deg to 360.0 deg

Electrical sector angle = 60.0 deg

============================================================
 MECHANICAL / ELECTRICAL RELATIONSHIP
============================================================
Pole pairs = 7
Mechanical angle per electrical sector = 8.571429 deg

============================================================
 PHASE CONDUCTION ANGLE
============================================================
Six-step sector angle       = 60.0 deg electrical
Phase conduction angle      = 120.0 deg electrical
120-degree conduction check = PASS

============================================================
 RATED-SPEED COMMUTATION FREQUENCY
============================================================
Rated mechanical speed = 128.333333 rev/s
Electrical frequency    = 898.333333 Hz
Commutation frequency   = 5390.000000 Hz

============================================================
 SENSORED BLDC COMMUTATION FLOW
============================================================
Hall A/B/C
    |
    v
Hall state detection
    |
    v
Sector identification
    |
    v
Six-step commutation table
    |
    v
High-side / Low-side phase commands
    |
    v
Inverter
    |
    v
BLDC electromagnetic torque

============================================================
 INVALID HALL STATE VALIDATION
============================================================
000 = invalid
111 = invalid
Invalid Hall-state identification = PASS

============================================================
 STAGE 9 FINAL VALIDATION
============================================================
Six-step commutation structure = PASS
Phase conduction symmetry       = PASS
Floating phase distribution     = PASS
120-degree conduction           = PASS
Invalid Hall states             = PASS

============================================================
 STAGE 9 OVERALL RESULT
============================================================
STAGE 9 = PASS

Six-step commutation structure validated.
Three-phase excitation structure validated.
Two-phase conduction / one floating phase verified.
120-degree phase conduction verified.
Seven pole-pair relationship retained.
Rated-speed commutation frequency calculated.

IMPORTANT MODEL LIMITATION:
The phase mapping used here is a standard commutation
convention and is not claimed as manufacturer-verified.
Exact Hall-to-phase mapping requires wiring documentation
or experimental verification.

============================================================
 END OF STAGE 9
============================================================
<img width="1112" height="507" alt="image" src="https://github.com/user-attachments/assets/37599eaf-b59d-426b-a92b-9809c96a901f" />
