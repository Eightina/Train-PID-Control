clear;clc;
%% loops and subplots
T=0.9;
v_tar = 80;
Tr_arr = zeros(8);
overshoot_arr = zeros(8);
Ts_arr = zeros(8);
Ess_arr = zeros(8);

for k = 1:8
    kp = 0.1 *k;
    ki = 0.05;
    kd = 0.1;

    iteration = 0:50;   
    time = iteration*T;
    subplot(2, 4, k);
    xlabel('Time (s)');
    ylabel('Velocity (km/h)');
    
    [Tr, overshoot, Ts, Ess, v_arr] = subplot_data(kp, ki, kd, 50);
    Tr_arr(k) = Tr;
    overshoot_arr(k) = overshoot;
    Ts_arr(k) = Ts;
    Ess_arr(k) = Ess;
    target(1:length(v_arr)) = v_tar;
    
    plot(time, v_arr, time, target, '-'), legend('Speed',  'Target Speed','Location','South'), title(sprintf('kp = %.1f', kp))
end
    

