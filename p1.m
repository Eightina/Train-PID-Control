%% params
T = 0.9;   
v_tar = 80;   % target velocity
kp = 0.6;
ki = 0.05;
kd = 0.1;   % p, i, d params
iterations= 15; % max iterations
if_plot = 1;

[Tr, overshoot, Ts, Ess] = pid_calculate(T, v_tar, kp, ki, kd, iterations, if_plot);