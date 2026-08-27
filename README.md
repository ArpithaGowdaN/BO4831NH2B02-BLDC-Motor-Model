# BO4831NH2B02-101-24.0 BLDC Motor Mathematical Model

Mathematical modeling, transfer-function development, PI speed control,
and validation of the BO4831NH2B02-101-24.0 sensored BLDC outer-rotor motor.

## Project Overview

This project develops a mathematical model of the BO4831NH2B02-101-24.0
24 V BLDC motor and evaluates its electrical, mechanical, and
closed-loop speed-control behavior using MATLAB.

The project includes:

- Motor parameter identification
- Electrical and mechanical mathematical modeling
- Voltage-to-speed transfer-function derivation
- PI controller design and validation
- Closed-loop stability analysis
- Rated operating-point verification
- Load disturbance testing
- Current and voltage saturation testing
- Speed-reference variation testing
- Final overall validation

## Motor

| Parameter | Value |
|---|---:|
| Motor | BO4831NH2B02-101-24.0 |
| Rated Voltage | 24 V |
| Rated Speed | 7700 rpm |
| Rated Current | 17.6 A |
| Rated Torque | 0.447 N.m |
| Phase Resistance | 0.08 Ohm |
| Phase Inductance | 80 uH |
| Back-EMF Constant | 0.028018 V.s/rad |
| Torque Constant | 0.025398 N.m/A |
| Rotor Inertia | 3.06e-5 kg.m^2 |
| Viscous Friction Coefficient | 1.9033e-5 N.m.s/rad |
| Pole Pairs | 7 |

## Mathematical Model

The electrical equation is represented as:

L di/dt + Ri + Ke*w = V

The mechanical equation is:

J dw/dt = Te - TL - B*w

The electromagnetic torque is:

Te = Kt*i

The resulting voltage-to-speed transfer function is:

G(s) = Kt /
       [LJ*s^2 + (LB + RJ)*s + (RB + Ke*Kt)]

For the selected motor:

G(s) =
0.025398 /
(2.448e-9*s^2 +
 2.44952264e-6*s +
 7.13123804e-4)

## PI Controller

The speed controller used in the final model is:

C(s) = Kp + Ki/s

where:

Kp = 0.15
Ki = 8.0

The closed-loop system was evaluated for stability,
steady-state error, transient response, and disturbance rejection.

## Validation Results

### Closed-loop response at 7700 rpm

- Final speed: 7700 rpm
- Steady-state error: 0 %
- Rise time: approximately 1.3 ms
- Settling time: approximately 42.3 ms
- Overshoot: approximately 13.5 %
- Closed-loop DC gain: 1.0
- Closed-loop stability: PASS

### Electrical limits

- DC bus voltage: 24 V
- Current limit: 17.6 A
- Voltage limit: 24 V

The controller respected the specified limits in the tested operating cases.

## Rated-load limitation

The manufacturer's rated operating point is:

7700 rpm
0.447 N.m
17.6 A
24 V

Using the simplified model with explicit viscous friction, maintaining
7700 rpm at 0.447 N.m requires approximately:

18.204 A

This exceeds the specified 17.6 A current limit.

Therefore, the rated-load operating point is treated as a
model limitation rather than being artificially forced into the simulation.

## Final Conclusion

The mathematical BLDC plant model is consistent with the available
motor parameters.

The voltage-to-speed transfer function was successfully derived and
validated.

The PI-controlled system is stable and provides closed-loop speed
regulation.

Current and voltage limits were respected in the tested operating
conditions.

The model also identifies a limitation in reproducing the manufacturer's
rated torque-speed point under the simplified model assumptions.

## Software

- MATLAB
- MATLAB/Control System Toolbox
- MATLAB R2014a compatibility considered

## Project Status

**Completed**

Motor parameters: LOCKED  
Mathematical model: VALIDATED  
Transfer function: VALIDATED  
PI controller: VALIDATED  
Closed-loop stability: PASS  
Load disturbance test: COMPLETED  
Saturation test: COMPLETED  
Speed variation test: COMPLETED  
Final validation: COMPLETED

Final Conclusion

A mathematical and simulation-based model of the BO4831NH2B02-101-24.0, 24-V BLDC motor was developed and analyzed using its electrical and mechanical parameters. The model incorporates the motor resistance, inductance, back-EMF constant, torque constant, rotor inertia, mechanical damping, pole-pair number, rated speed, current, and torque. The electrical and mechanical equations were used to establish the motor transfer function and its dynamic behavior.

A PI speed controller with \(K_p=0.15\) and \(K_i=8\) was implemented to regulate the motor speed. The final closed-loop simulation achieved a speed of 7699.84 rpm for a 7700-rpm reference, corresponding to only 0.00203% steady-state error. The response exhibited 0% overshoot, a rise time of 14.45 ms, and a settling time of 50.90 ms.

The robustness of the controller was further evaluated by applying a 0.2-N·m load disturbance at 1 s. The motor speed decreased by approximately 54.29 rpm but recovered to approximately 7700 rpm, resulting in a final speed error of only 0.000288%. This demonstrates effective speed regulation and disturbance rejection.

Fourteen performance characteristics were generated to analyze the motor's speed, torque, current, back-EMF, power, efficiency, electrical frequency, Hall transition frequency, PWM duty, closed-loop response, and load behavior. The rated speed, current, torque, electrical frequency, and Hall frequency were successfully validated against the specified motor data.

However, differences of 22.25% in the effective back-EMF constant and 12.88% in the effective torque constant were identified and documented as model-to-datasheet review points. The calculated rated operating voltage of 24.00009 V also results in a theoretical PWM duty of approximately 100.0004%, indicating that the rated operating point is effectively at the 24-V supply limit. These discrepancies are retained transparently rather than artificially modifying the locked model parameters.

Overall, the project successfully demonstrates mathematical modeling, MATLAB/Simulink implementation, PI-based speed control, transient-performance evaluation, disturbance rejection, performance-characteristic analysis, and datasheet-based validation of the selected BLDC motor.
