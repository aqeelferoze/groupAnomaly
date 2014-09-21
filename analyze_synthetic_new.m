% Analyze new model results
clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

import Cal.*
import Lib.*
Ms = 2;
Me = 9;
group_num = 2:10;
repeat_num = 1:10;
thres = 0.2;
M = length(group_num);
N = length( repeat_num);
prec_glad = zeros(N,M);

for i =  1:M
    for j = 1:N
        m  = group_num(i);
        n = repeat_num(j);
        Datname = strcat('./Data/synth/syn',int2str(m),'_',int2str(n),'.mat');
        load(Datname);
       
        
        Rstname = strcat('./NewResult/gladModel',int2str(m),'_',int2str(n),'.mat');
        load(Rstname);

                
        scores_glad  = cal_anomaly_score_glad (hyper_para_glad, var_para_glad);
        prec_glad(j,i) = cal_anomaly_prec( bad_idx, scores_glad, thres ) ; 
        

     end
end

%%
mean_glad = mean(prec_glad);
std_glad = std(prec_glad);
hold all;
% plot(1:group_num, [mean_glad]);
errorbar(group_num, [mean_glad],std_glad);

