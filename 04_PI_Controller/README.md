Stage 4 is officially PASS.

The output matches the validated Stage 4 model exactly.

✅ Stage 4 validation
Check	Result
PI controller	PASS
\(K_p\)	0.15
\(K_i\)	8
Closed-loop model	PASS
Closed-loop stability	PASS
Closed-loop poles	PASS
Maximum pole error	4.60 × 10⁻⁹
DC gain	1.000000
Steady-state error	0
Rise time	1.222 ms
Settling time	42.35 ms
Overshoot	13.52%
Overall Stage 4	✅ PASS
🔍 Most important result

The actual poles are:

$$ \boxed{s_{1,2}=-477.3018\pm j1255.3137} $$ $$ \boxed{s_3=-46.0183} $$

All poles have negative real parts, so the closed-loop system is stable.

The PI controller also gives:

$$ \boxed{K_p=0.15,\qquad K_i=8} $$

and

$$ \boxed{e_{ss}=0} $$

for the unit-step reference.

📈 Your plot

The response looks exactly consistent with those poles: there is an initial overshoot of about 13.5%, followed by damped oscillation and convergence to 1.0.

So we can safely mark:

STAGE 4 = COMPLETE ✅

output::


============================================
 BO4831NH2B02-101-24.0
 STAGE 4 - PI CONTROLLER & CLOSED LOOP
============================================

============================================
 MOTOR PARAMETERS
============================================
DC voltage          = 24.000000 V
Resistance          = 0.08000000 Ohm
Inductance          = 8.00000000e-05 H
Effective Ke        = 0.02801800 V.s/rad
Effective Kt        = 0.02539800 N.m/A
Rotor inertia       = 3.06000000e-05 kg.m^2
Viscous coefficient = 1.90330000e-05 N.m.s/rad

============================================
 STAGE 3 MOTOR PLANT
============================================

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
 PI CONTROLLER
============================================
Kp = 0.150000
Ki = 8.000000

PI controller transfer function:
  tf with properties:

             num: {[0.1500 8]}
             den: {[1 0]}
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
 OPEN-LOOP SYSTEM
============================================

  tf with properties:

             num: {[0 0 0.0038 0.2032]}
             den: {[2.4480e-09 2.4495e-06 7.1312e-04 0]}
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
 CLOSED-LOOP TRANSFER FUNCTION
============================================

T(s) = C(s)G(s) / [1 + C(s)G(s)]

  tf with properties:

             num: {[0 0 0.0038 0.2032]}
             den: {[2.4480e-09 2.4495e-06 0.0045 0.2032]}
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
 CLOSED-LOOP POLES
============================================
Pole 1 = -477.3018364070 + 1255.3136829165j
Pole 2 = -477.3018364070 - 1255.3136829165j
Pole 3 = -46.0183206500 + 0.0000000000j

============================================
 CLOSED-LOOP STABILITY
============================================
Closed-loop stability = STABLE

============================================
 CLOSED-LOOP DC GAIN
============================================
DC gain = 1.0000000000

============================================
 CLOSED-LOOP CHARACTERISTIC COEFFICIENTS
============================================
s^3 coefficient = 2.448000000000e-09
s^2 coefficient = 2.449522640000e-06
s^1 coefficient = 4.522823804000e-03
s^0 coefficient = 2.031840000000e-01

============================================
 POLES FROM CHARACTERISTIC EQUATION
============================================
Calculated Pole 1 = -477.3018364070 + 1255.3136829165j
Calculated Pole 2 = -477.3018364070 - 1255.3136829165j
Calculated Pole 3 = -46.0183206500 + 0.0000000000j

============================================
 CLOSED-LOOP POLE VALIDATION
============================================
Expected Pole 1 = -477.3018364100 + 1255.3136829200j
Expected Pole 2 = -477.3018364100 - 1255.3136829200j
Expected Pole 3 = -46.0183206500

Maximum pole error = 4.602178091360e-09
Closed-loop poles = PASS

============================================
 SPEED REFERENCE
============================================
Reference speed = 7700.00 rpm
Reference speed = 806.342114 rad/s

============================================
 CLOSED-LOOP STEP RESPONSE
============================================
Rise time       = 0.0012218728 s
Settling time   = 0.0423495425 s
Overshoot       = 13.5228053660 %
Peak            = 1.1352280537

============================================
 STEADY-STATE ERROR
============================================
Closed-loop DC gain = 1.0000000000
Steady-state error  = 0.0000000000e+00

============================================
 STAGE 4 VALIDATION
============================================
Closed-loop stability       = PASS
Closed-loop pole validation = PASS
Zero steady-state error     = PASS

============================================
 STAGE 4 FINAL RESULT
============================================
STAGE 4 = PASS

PI controller implemented successfully.
Kp = 0.150000
Ki = 8.000000

Closed-loop model generated.
Closed-loop poles calculated.
Stability checked.
Steady-state tracking checked.

============================================
 END OF STAGE 4
============================================

<img width="531" height="400" alt="image" src="https://github.com/user-attachments/assets/caa935ea-08f0-45fe-9e3c-4fc4fdf604ba" />
