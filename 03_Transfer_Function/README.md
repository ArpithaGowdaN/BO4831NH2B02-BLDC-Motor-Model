# Stage 3 - BLDC Transfer Function

## Motor

BO4831NH2B02-101-24.0

## Objective

This stage derives and implements the voltage-to-speed transfer function of the selected BLDC motor.

The mathematical model established in Stage 2 is converted into a continuous-time transfer function suitable for MATLAB control-system analysis.

## Mathematical Derivation

Electrical equation:

V = L(di/dt) + R*i + Ke*omega

Mechanical equation:

J(domega/dt) = Kt*i - B*omega - TL

For the no-load transfer function:

TL = 0

The resulting voltage-to-speed transfer function is:

G(s) = Omega(s) / V(s)

G(s) = Kt /
       [LJ*s^2 + (LB + RJ)*s + (RB + Ke*Kt)]

## Locked Motor Parameters

| Parameter | Value |
|---|---:|
| DC Voltage | 24 V |
| Resistance | 0.08 Ohm |
| Inductance | 80 uH |
| Effective Ke | 0.028018 V.s/rad |
| Effective Kt | 0.025398 N.m/A |
| Rotor Inertia | 3.060e-05 kg.m² |
| Viscous Coefficient | 1.9033e-05 N.m.s/rad |
| Rated Speed | 7700 rpm |
| Rated Current | 17.6 A |
| Rated Torque | 0.447 N.m |

## Transfer Function Coefficients

LJ:

2.448e-09

LB + RJ:

2.44952264e-06

RB + Ke*Kt:

7.13123804e-04

Therefore:

G(s) = 0.025398 /
       [2.448e-09*s²
       + 2.44952264e-06*s
       + 7.13123804e-04]

## Plant Poles

The plant poles are approximately:

- -500.3109967 + 202.4787644j
- -500.3109967 - 202.4787644j

Both poles have negative real parts, so the open-loop plant is stable.

## DC Gain

DC gain:

35.6151342271 (rad/s)/V

## 24 V Steady-State Prediction

At 24 V:

Predicted speed:

854.763221 rad/s

Equivalent speed:

8162.387512 rpm

Compared with the manufacturer's rated speed of 7700 rpm, the simplified transfer-function prediction differs by approximately:

6.005033 %

## Rated-Point Electrical Check

At 7700 rpm and 17.6 A:

Back EMF:

22.592093 V

IR drop:

1.408000 V

E + IR:

24.000093 V

This agrees closely with the 24 V DC supply.

## Validation Status

Transfer-function coefficients: PASS

Plant stability: PASS

Rated-point electrical relationship: VALIDATED

## Important Note

The transfer function represents the simplified continuous-time voltage-to-speed BLDC model.

The manufacturer rated operating point and the later closed-loop simulations are evaluated separately. The transfer function should not be interpreted as a complete switching-level BLDC inverter model.

## Next Stage

Stage 4 will introduce the PI controller and evaluate the closed-loop speed-control system.

output ::

============================================
 BO4831NH2B02-101-24.0
 STAGE 3 - BLDC TRANSFER FUNCTION
============================================

============================================
 MOTOR PARAMETERS
============================================
DC voltage              = 24.000000 V
Resistance              = 0.08000000 Ohm
Inductance              = 8.00000000e-05 H
Effective Ke            = 0.02801800 V.s/rad
Effective Kt            = 0.02539800 N.m/A
Rotor inertia           = 3.06000000e-05 kg.m^2
Viscous coefficient     = 1.90330000e-05 N.m.s/rad

Rated speed             = 7700.00 rpm
Rated current           = 17.60 A
Rated torque            = 0.447000 N.m

============================================
 TRANSFER FUNCTION COEFFICIENTS
============================================
LJ       = 2.448000000000e-09
LB + RJ  = 2.449522640000e-06
RB + KeKt = 7.131238040000e-04

============================================
 VOLTAGE TO SPEED TRANSFER FUNCTION
============================================

G(s) = Kt / [LJ*s^2 + (LB+RJ)*s + (RB+KeKt)]

G =

  tf with properties:

             num: {[0 0 0.0254]}
             den: {[2.4480e-09 2.4495e-06 7.1312e-04]}
        Variable: 's'
         ioDelay: 0
      InputDelay: 0
     OutputDelay: 0
              Ts: 0
        TimeUnit: 'seconds'
       InputName: {''}
       InputUnit: {''}
      InputGroup: [1x1 struct]
      OutputName: {''}
      OutputUnit: {''}
     OutputGroup: [1x1 struct]
            Name: ''
           Notes: {}
        UserData: []
    SamplingGrid: [1x1 struct]


============================================
 SYSTEM POLES
============================================
Pole 1 = -500.3109967320 + 202.4787643509j
Pole 2 = -500.3109967320 - 202.4787643509j

============================================
 PLANT STABILITY
============================================
Plant stability = STABLE

============================================
 DC GAIN
============================================
DC gain = 35.6151342271 (rad/s)/V

============================================
 24 V STEADY-STATE RESULT
============================================
Applied voltage      = 24.0000 V
Predicted speed      = 854.763221 rad/s
Predicted speed      = 8162.387512 rpm
Rated speed           = 7700.00 rpm
Speed error           = 6.005033 %

============================================
 RATED-POINT ELECTRICAL CHECK
============================================
Rated angular speed   = 806.342114 rad/s
Back EMF              = 22.592093 V
IR voltage drop       = 1.408000 V
E + IR                = 24.000093 V
DC bus voltage        = 24.000000 V

============================================
 FINAL TRANSFER FUNCTION RESULT
============================================
Voltage-to-speed model generated successfully.

G(s) = Kt / [LJ*s^2 + (LB+RJ)*s + (RB+KeKt)]

Numerator = 0.02539800

Denominator:
[ 2.448000000000e-09   2.449522640000e-06   7.131238040000e-04 ]

============================================
 TRANSFER FUNCTION VALIDATION
============================================
Transfer-function coefficients = PASS
Plant stability                = PASS

============================================
 STAGE 3 TRANSFER FUNCTION COMPLETE
============================================
Motor parameters remain LOCKED.
Transfer function established.
Plant poles calculated.
DC gain calculated.
24 V steady-state speed evaluated.
Validation completed.
============================================
<img width="547" height="417" alt="image" src="https://github.com/user-attachments/assets/d18b3755-ead2-4888-9a34-f6afff634049" />
