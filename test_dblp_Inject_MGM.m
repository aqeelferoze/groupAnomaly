clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

import lib.*;
% for M = 10: 2: 20
for M = 20;
K = 4;
sz_group = 100;
N = sz_group *M;
G_idx = [];
for m = 1:M
    G_idx = [G_idx ; m*ones(sz_group,1)];
end
fname = strcat('./Data/data_text/dblp_anomaly_',int2str(M),'.mat');
load(fname);

%%

const_idx = [689 816 884  931 943  1081 1212  1555  1572 ...
1575  1576  1626  1657  1788  1799  1800  1863  1868  1942  1976];

X(:,const_idx) =[];

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