clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 0;
import lib.*

N = 1000;
K = 4;
for M = [5 10 20 50 ];

sz_group = N/M;

G_idx = [];
for m = 1:M
    G_idx = [G_idx ; m*ones(sz_group,1)];
end
fname = strcat('./Data/data_text/dblp_anomaly_',int2str(M),'.mat');
load(fname);

%% do something to make multi-nomial
pr = full(lib.mnormalize(X,2));
[~,max_idx] = max(pr,[],2);
X = mnrnd(10000,pr);
X = X+1;

V = size(X,2);

%%
data.X = X;
data.Y = Y;

hyper_para.alpha = ones(1,M) * 0.01;
hyper_para.B = eye(M,M)*0.8 + 0.1;
hyper_para.beta = lib.mnormalize(rand(K,V),2);
hyper_para.theta = lib.mnormalize(rand(K,M),1);
hyper_para.nC = 1;

tic;
[var_para_glad , hyper_para_glad] = GLAD2.train(data,hyper_para);
run_time = toc;
[~,R_idx_glad]= max(var_para_glad.mu);
[~,G_idx_glad]= max(var_para_glad.lambda);

[ scores_glad ] = lib.anomaly_score_rd( G_idx_glad, R_idx_glad, M,K  );

%%
save(strcat('./Result/gladDBLP_',int2str(M),'.mat'),'scores_glad','R_idx_glad','G_idx_glad');
fprintf('GLAD: M = %d Finished\n',M);
end
