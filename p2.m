
%% params 
T = 0.9; 
v_tar = 80;   
v_now=78; 
iterations = 100;

rounds = 100;
res  = zeros(rounds^3, 4);
params  = zeros(rounds^3, 3);
if_plot = 0;
cnt = 1;

%% do grid searching
for i=1:rounds
    for j=1:rounds
        for k=1:rounds
            kp = 1.5 / rounds * i;
            ki = 0.3 /rounds * j;
            kd = 0.3 /rounds * k;
            [Tr, overshoot, Ts, Ess] = pid_calculate(T, v_tar, kp, ki, kd, iterations, if_plot);
            res(cnt,:) = [Tr, overshoot, Ts, Ess];
            params(cnt,:) = [kp, ki, kd];
            cnt = cnt + 1;
        end
    end
end

%% normalization
res_og = res(:,:);
for cnt =  1:4
    cur_col = res(1:end, cnt);
    res(1:end, cnt)=(cur_col - min(cur_col)) / (max(cur_col) - min(cur_col));
end


%% find best params
min_goal = 9999;
min_row = -1;
% search for min record
for cnt = 1:length(res(:,1))
    cur_cal = res(cnt,:);
    goal = cur_cal(1)^1/2 +  cur_cal(2)^1/2 + cur_cal(3)^1/2 + cur_cal(4)^1/2;
    if (goal < min_goal)
        min_goal = goal;
        min_row = cnt;
    end
end
a = params(min_row, 1:end);
best_kp = a(1);
best_ki = a(2);
best_kd = a(3);
[Tr, overshoot, Ts, Ess] = pid_calculate(T, v_tar, best_kp, best_ki, best_kd, iterations, 1);

% best kp=1.0950, ki=0.0030, kd=0.0150


