clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 0;

import Cal.*
thres = 0.2;

prec_glad = [];
prec_graph_lda = [];
prec_graph_mgm = [];
prec_mmsb_mgm = [];
prec_mmsb_lda = [];

for M =  [5,10,20,50]
    Rstname = strcat('./Result/synScore',int2str(M),'.mat');
    load (Rstname);
    Datname = strcat('./Data/syn',int2str(M),'.mat');
    load(Datname);
    prec_glad = [prec_glad, cal_anomaly_prec( bad_idx, scores_glad, thres )];
    prec_graph_lda = [prec_graph_lda cal_anomaly_prec( bad_idx, scores_graph_lda, thres )];
    prec_graph_mgm = [prec_graph_mgm cal_anomaly_prec( bad_idx, scores_graph_mgm, thres )];
    prec_mmsb_mgm = [prec_mmsb_mgm cal_anomaly_prec( bad_idx, scores_mmsb_mgm, thres )];
    prec_mmsb_lda = [prec_mmsb_lda cal_anomaly_prec( bad_idx, scores_mmsb_lda, thres )];
end

plot([prec_glad',prec_graph_lda',prec_graph_mgm',prec_mmsb_mgm',prec_mmsb_lda']);
legend('GLAD','Graph-LDA','Graph-MGM','MMSB-MGM','MMSB-LDA');


%%

clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 0;

import Cal.*
thres = 0.2;

prec_glad = zeros(5,4);
prec_graph_lda = [];
prec_graph_mgm = [];


for M =  [5,10,20,50]
    for n = 1:5
    Rstname = strcat('./Result/gladScore',int2str(M),'_',int2str(n),'.mat');
    load (Rstname);
    Rstname = strcat('./Result/graphScore',int2str(M),'_',int2str(n),'.mat');

    load (Rstname);
    Datname = strcat('./Data/syn',int2str(M),'_',int2str(n),'.mat');
    load(Datname);
    prec_glad(n,M) = cal_anomaly_prec( bad_idx, scores_glad, thres ) ;  
    prec_graph_lda(n,M) = cal_anomaly_prec( bad_idx, scores_graph_lda, thres );
    prec_graph_mgm(n,M) = cal_anomaly_prec( bad_idx, scores_graph_mgm, thres );  
    end
end

mean_glad = mean(prec_glad);
std_glad = std(prec_glad);

mean_graph_lda= mean(prec_graph_lda);
std_graph_lda = std(prec_graph_lda);

mean_graph_mgm= mean(prec_graph_mgm);
std_graph_mgm = std(prec_graph_mgm);

errorbar([5,10,20,50], [mean_glad],std_glad);
legend('GLAD','Graph-LDA','Graph-MGM');



    
    