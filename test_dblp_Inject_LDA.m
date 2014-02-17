clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

import lib.*;


for M = [50 100 200];
K = 4;
sz_group =20;
N = sz_group *M;
G_idx = [];
for m = 1:M
    G_idx = [G_idx ; m*ones(sz_group,1)];
end


fname = strcat('./Data/data_text/dblp_anomaly_',int2str(M),'.mat');
load(fname);

V = size(X,2);

%% Graph
    import graphcut.* ;
    [G_idx_graph,Pi,cost]= grPartition(Y,M);
%%
import LDA.*

options = struct('n_try', 3, 'para', false, 'verbose', false, ...
        'epsilon', 1e-2, 'max_iter', 30, 'ridge', 1e-2);
[lda_g Like_lda_g]= LDA.Train(X(:,1:V-1), G_idx_graph, K, options);
[~,R_idx_lda]= max(lda_g.phi,[],2);
[ scores_lda ] = lib.anomaly_score_rd( G_idx, R_idx_lda, M,K  );

save(strcat('./Result/dblpLDA_',int2str(M),'.mat'),'scores_lda');
fprintf('LDA: M = %d Finished\n',M);
end
