# Mathematical Model

This folder establishes the mathematical model of the
BO4831NH2B02-101-24.0 BLDC motor.

## Electrical Equation

V = L(di/dt) + R i + Ke omega

Therefore:

di/dt = (V - R i - Ke omega) / L

## Electromagnetic Torque

Te = Kt i

## Mechanical Equation

J(domega/dt) = Te - B omega - TL

Therefore:

domega/dt = (Te - B omega - TL) / J

## State Variables

The model uses:

- Phase current `i`
- Rotor angular speed `omega`

The motor parameters are kept identical to the locked
parameter set defined in `01_Motor_Parameters`.

## Status

Mathematical model established and ready for transfer-function derivation.
