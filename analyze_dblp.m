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

Ms = [5 10  20];% 100 200];
thres = 0.2;

for i = 1:length(Ms)
    M = Ms(i);
    
    Datname =strcat('./Data/data_text/dblp2_anomaly_',int2str(M),'.mat');
    load(Datname);
    
    Rstname = strcat('./Result/gladDBLP_',int2str(M),'.mat');
    load(Rstname);
    
    
    
    Rstname = strcat('./Result/graphDBLP_',int2str(M),'.mat');
    load(Rstname);

%     
%     
%     Rstname = strcat('./Result/mmsbDBLP_',int2str(M),'.mat');
%     load(Rstname);
   
    
    prec_glad(i) = cal_anomaly_prec( bad_idx, scores_glad, thres );
    prec_graph_lda(i) = cal_anomaly_prec( bad_idx, scores_graph_lda, thres);
    
  
    prec_graph_mgm(i) = cal_anomaly_prec( bad_idx, scores_graph_mgm, thres);

    
end

% plot(prec_glad);
% plot(prec_lda);
% plot(prec_mgm);

mean(prec_glad)
mean(prec_graph_lda)
mean(prec_graph_mgm)

% prec_mgm = cal_anomaly_prec( bad_idx, scores_mgm, thres );


