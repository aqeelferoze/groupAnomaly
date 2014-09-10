% Analyze new model results
clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

import Cal.*
Ms = 2;
Me = 9;
group_num = 10;
repeat_num = 3;
thres = 0.2;

prec_glad = zeros(group_num, repeat_num);
prec_graph_lda =zeros(group_num, repeat_num);
prec_graph_mgm =zeros(group_num, repeat_num);
prec_mmsb_lda =zeros(group_num, repeat_num);
prec_mmsb_mgm =zeros(group_num, repeat_num);
for m= Ms:Me
    for n = 1:repeat_num  
        Datname = strcat('./Data/synth/syn',int2str(m),'_',int2str(n),'.mat');
        load(Datname);
       
        
        Rstname = strcat('./NewResult/gladModel',int2str(m),'_',int2str(n),'.mat');
        load(Rstname);

        scores_glad  = cal_anomaly_score_glad (hyper_para_glad, var_para_glad);
        prec_glad(n,m) = cal_anomaly_prec( bad_idx, scores_glad, thres ) ; 
        
     end
end

%% 

for m =Ms:Me
    Rstname = strcat('./NewResult/mmsbScore',int2str(m),'_',int2str(n),'.mat');
    load (Rstname);
    Rstname = strcat('./NewResult/graphScore',int2str(m),'_',int2str(n),'.mat');
    load (Rstname);

    prec_graph_lda(n,m) = cal_anomaly_prec( bad_idx, scores_graph_lda, thres );
    prec_graph_mgm(n,m) = cal_anomaly_prec( bad_idx, scores_graph_mgm, thres ); 

    prec_mmsb_lda(n,m) = cal_anomaly_prec( bad_idx, scores_mmsb_lda, thres ) ;
    prec_mmsb_mgm(n,m) = cal_anomaly_prec( bad_idx, scores_mmsb_mgm, thres ) ;
end

%%
mean_glad = mean(prec_glad);
std_glad = std(prec_glad);

mean_graph_lda= mean(prec_graph_lda);
std_graph_lda = std(prec_graph_lda);

mean_graph_mgm= mean(prec_graph_mgm);
std_graph_mgm = std(prec_graph_mgm);

mean_mmsb_lda= mean(prec_mmsb_lda);
std_mmsb_lda = std(prec_mmsb_lda);

mean_mmsb_mgm= mean(prec_graph_mgm);
std_mmsb_mgm = std(prec_mmsb_mgm);

hold all;
errorbar(1:Me, [mean_glad],std_glad);

errorbar(1:Me, [mean_graph_lda],std_graph_lda);
errorbar(1:Me, [mean_graph_mgm],std_graph_mgm);

errorbar(1:Me, [mean_mmsb_lda],std_mmsb_lda);
errorbar(1:Me, [mean_mmsb_mgm],std_mmsb_mgm);

legend('GLAD','Graph-LDA','Graph-MGM', 'MMSB-LDA','MMSB-MGM');
hold off;
