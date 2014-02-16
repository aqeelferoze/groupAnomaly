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



bad_idx = 10;
thres = 0.2;
prec_glad = cal_anomaly_prec( bad_idx, scores_glad, thres );

prec_mgm = cal_anomaly_prec( bad_idx, scores_mgm, thres );


