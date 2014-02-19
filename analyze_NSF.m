clc;
clear;
import lib.*;
import Cal.*;

Ms = [5 10  20];% 100 200];
thres = 0.2;
N = 500;
for i = 1:length(Ms)
    M = Ms(i);
    
    

    
    Datname =strcat('./Data/data_text/NSF_anomaly_',int2str(M),'.mat');
    load(Datname);
    
    Rstname = strcat('./Result/gladNSF_',int2str(M),'.mat');
    load(Rstname);
    
    
    
    Rstname = strcat('./Result/graphNSF_',int2str(M),'.mat');
    load(Rstname);

    
    
    Rstname = strcat('./Result/mmsbNSF_',int2str(M),'.mat');
    load(Rstname);
   
    
    K = 4;
    sz_group =N/M;
    G_idx = [];
    for m = 1:M
        G_idx = [G_idx ; m*ones(sz_group,1)];
    end
    [ scores_mmsb_mgm ] = lib.anomaly_score_rd( G_idx, R_idx_mmsb_mgm, M,K  );
    [ scores_mmsb_lda ] = lib.anomaly_score_rd( G_idx, R_idx_mmsb_lda, M,K  );   
    [ scores_graph_lda ] = lib.anomaly_score_rd( G_idx, R_idx_graph_lda, M,K  );    
    [ scores_graph_mgm ] = lib.anomaly_score_rd( G_idx, R_idx_graph_mgm, M,K  );
    [ scores_glad ] = lib.anomaly_score_rd( G_idx, R_idx_glad, M,K  );


    
    prec_glad(i) = cal_anomaly_prec( bad_idx, scores_glad, thres );
    prec_graph_lda(i) = cal_anomaly_prec( bad_idx, scores_graph_lda, thres);
     
    prec_graph_mgm(i) = cal_anomaly_prec( bad_idx, scores_graph_mgm, thres);
    
    
    prec_mmsb_lda(i) = cal_anomaly_prec( bad_idx, scores_mmsb_lda, thres);
     
    prec_mmsb_mgm(i) = cal_anomaly_prec( bad_idx, scores_mmsb_lda, thres);
    
end

% plot(prec_glad);
% plot(prec_lda);
% plot(prec_mgm);

mean(prec_glad)
mean(prec_graph_lda)
mean(prec_graph_mgm)
mean(prec_mmsb_lda)
mean(prec_mmsb_mgm)