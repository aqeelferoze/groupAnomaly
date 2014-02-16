clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

import lib.*;

for M = [50,80,100]
K = 4;
sz_group = 100;
N = sz_group *M;
G_idx = [];
for m = 1:M
    G_idx = [G_idx ; m*ones(sz_group,1)];
end
fname = strcat('./Data/data_text/dblp_anomaly_',int2str(M),'.mat');
load(fname);

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

import MGM.*;
options = struct('n_try', 3, 'para', false, 'verbose', true, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
T = 2;
V = N;

[mgm Like_mgm]= MGM.Train1(X(:,1:V-1), G_idx, T, K, options);
[~,R_idx_mgm]= max(mgm.phi,[],2);
[ scores_mgm ] = lib.anomaly_score_rd( G_idx, R_idx_mgm, M,K  );

save(strcat('./Result/dblpMGM_',int2str(M),'.mat'),'scores_mgm');
end