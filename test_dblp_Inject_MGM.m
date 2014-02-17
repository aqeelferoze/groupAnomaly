clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

import lib.*;

for M = [50 100 200];
K = 4;
sz_group = 20;
N = sz_group *M;
G_idx = [];
for m = 1:M
    G_idx = [G_idx ; m*ones(sz_group,1)];
end
fname = strcat('./Data/data_text/dblp_anomaly_',int2str(M),'.mat');
load(fname);

%% Graph
import graphcut.* ;
[G_idx_graph,Pi,cost]= grPartition(Y,M);

%% do something to remove constant column
V0 = size(X,2);
const_idx = [];
for v = 1:V0
    if(numel(unique(X(:,v)))==1)
        const_idx = [const_idx,v];
    end
end

X(:,const_idx)=[];

%%
V = size(X,2);
if(N <V)
    V = N-1;
end

import MGM.*;
options = struct('n_try', 3, 'para', false, 'verbose',false, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
T = 2;

[mgm Like_mgm]= MGM.Train1(X(:,1:V), G_idx_graph, T, K, options);
[~,R_idx_mgm]= max(mgm.phi,[],2);
[ scores_mgm ] = lib.anomaly_score_rd( G_idx, R_idx_mgm, M,K  );

save(strcat('./Result/dblpMGM_',int2str(M),'.mat'),'scores_mgm');
fprintf('MGM: M = %d Finished\n',M);
end