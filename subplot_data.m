function [Tr, overshoot, Ts, Ess, v_arr] = subplot_data(kp, ki, kd, iterations)

    %% variables
    T=0.9; 
    v_tar=80;   
    err_arr = []; % err_arror recording
    err_arr(1) = 0; 
    v_arr = [];   % velocity recording
    v_cur = 78;   % current velocity
    v_arr(1) = v_cur;  
    U = []; % acceleration recording

    %% calculate v_arr & err_arr
    for k = 1:iterations
        err_arr(k + 1) = (v_tar - v_arr(k)) / 3.6;  % new error (m/s)
        delta_err = (err_arr(k + 1) - err_arr(k));
        U(k) = kp * err_arr(k + 1) + ki * sum(err_arr) + kd * delta_err;   % new acceleration
        v_arr(k + 1) = v_arr(k) + U(k) * T * 3.6;   % new velocity (km/h)
    end

    %% plot

    iter = 0:iterations;    % x axis
    time = iter * T; 
    

    
    %% calculate Tr (system not steady : use the time of its first time reaching the 100% final value)
    for k = 1:iterations
            if (v_arr(k) <= 78+(v_tar-78)*0.9) && (v_arr(k + 1) >=  78+(v_tar-78)*0.9)  % linear interpolation finding Tr
                Tr = time(k) + (78+(v_tar-78)*0.9- v_arr(k)) / 3.6 / (U(k));
                break
            end
    end



    %% overshoot
    v_max = -1;
    max_loc = -1;
    for ss = 1:length(v_arr)
        if (v_arr(ss) > v_tar) && (v_arr(ss)>v_max)
            v_max = v_arr(ss);
            max_loc = ss;
        end
    end
    overshoot = ((v_max - v_tar) / v_tar) * 100;

    %% adjustment time Ts (lest time to reach and maintain whithin the ±5/2% range of final value)
    % 2%
    if (v_max < 1.02 * 80) % maintain in the range all the time
        for k = 1:iterations    
            if(v_arr(k) <= v_tar*(1 - 0.02))&&(v_arr(k + 1) >= v_tar*(1 - 0.02))
                Ts = time(k) + (v_tar * (1 - 0.02) - v_arr(k)) / 3.6 / (U(k));
            end 
        end
    else
        for k = max_loc:iterations    
            if(v_arr(k) >= v_tar*(1 + 0.02)) && (v_arr(k + 1) <= v_tar*(1 + 0.02))
                Ts = time(k) + (v_tar * (1 - 0.02) - v_arr(k)) / 3.6 / (U(k));
            end 
        end
    end

    %% steady-state error Ess
    Ess = v_arr(length(v_arr)) - v_tar;

end


