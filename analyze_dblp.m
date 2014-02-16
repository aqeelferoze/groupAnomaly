%% topics sketch

load('dblp_4area_abstract.mat');
beta = hyper_para_glad.beta;
[~,order] = sort(beta,2,'descend');

top_num = 20;
K = 4;


for k = 1:K
    idx = order(k,1:top_num);
    for i = idx
        fprintf('%s ', name.term_name{i});
    end
    fprintf('\n');
end

%%
import lib.*;
import Cal.*;

Ms= [10:2:20];
thres = 0.2;
for i = 1:6
    M = Ms(i);
    Rstname = strcat('./Result/dblpGlad_',int2str(M),'.mat');
    load(Rstname);
    Datname =strcat('./Data/data_text/dblp_anomaly_',int2str(M),'.mat');
    load(Datname);

  
    prec_glad(i) = cal_anomaly_prec( bad_idx, scores_glad, thres );
end

plot(prec_glad);
mean(prec_glad);

% prec_mgm = cal_anomaly_prec( bad_idx, scores_mgm, thres );


