%% topics sketch

% load('dblp_4area_abstract.mat');
% beta = hyper_para_glad.beta;
% [~,order] = sort(beta,2,'descend');
% 
% top_num = 20;
% K = 4;
% 
% 
% for k = 1:K
%     idx = order(k,1:top_num);
%     for i = idx
%         fprintf('%s ', name.term_name{i});
%     end
%     fprintf('\n');
% end

%%

clc;
clear;
import lib.*;
import Cal.*;

Ms = [5 10 20];% 50 100 200];
thres = 0.2;

for i = 1:length(Ms)
    M = Ms(i);
    
    Datname =strcat('./Data/data_text/dblp_anomaly_',int2str(M),'.mat');
    load(Datname);
    
    Rstname = strcat('./Result/dblpGlad_',int2str(M),'.mat');
    load(Rstname);
    
    
    
    Rstname = strcat('./Result/dblpLDA_',int2str(M),'.mat');
    load(Rstname);

    
    
    Rstname = strcat('./Result/dblpMGM_',int2str(M),'.mat');
    load(Rstname);
   
    
    prec_glad(i) = cal_anomaly_prec( bad_idx, scores_glad, thres );
    prec_lda(i) = cal_anomaly_prec( bad_idx, scores_lda, thres);
    
  
    prec_mgm(i) = cal_anomaly_prec( bad_idx, scores_mgm, thres);

    
end
hold all;
% plot(prec_glad);
% plot(prec_lda);
plot(prec_mgm);

mean(prec_glad)
mean(prec_lda);

% prec_mgm = cal_anomaly_prec( bad_idx, scores_mgm, thres );


