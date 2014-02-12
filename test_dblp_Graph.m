clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

import +lib.*;
import +GLAD2.*


data = load('dblp_P2.mat');

M = 4;
K = 4;

V = size(data.X,2);
hyper_para.alpha = ones(1,M) * 0.01;
hyper_para.B = eye(M,M)*0.8 + 0.1;
hyper_para.beta = lib.mnormalize(rand(K,V),2);
hyper_para.theta = lib.mnormalize(rand(K,M),1);
hyper_para.nC = 1;

tic;
import graphcut.* ;
[G_idx_graph,Pi,cost]= grPartition(data.Y,M);
%% LDA
import LDA.*;
import lib.*;
options = struct('n_try', 3, 'para', false, 'verbose', false, ...
    'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
[lda_g Like_lda_g]= LDA.Train(data.X, G_idx_graph, K, options);
[~,R_idx_graph_lda]= max(lda_g.phi,[],2);
R_idx_graph_lda = R_idx_graph_lda';

run_time_lda = toc;
fprintf('*******Done with Graph-LDA******* \n');
%% Graph-MGM
import MGM.*;
import lib.*;
options = struct('n_try', 3, 'para', false, 'verbose', true, ...
    'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
T = 2;
if(numel(unique(G_idx_graph))==1)
G_idx_graph = crossvalind('Kfold',length(G_idx_graph),M);
end
G_idx_graph = reshape(G_idx_graph,[length(G_idx_graph),1]);
[mgm_g Like_mgm_g]= MGM.Train1(data.X, G_idx_graph, T, K, options);
[~,R_idx_graph_mgm]= max(mgm_g.phi,[],2);
R_idx_graph_mgm = R_idx_graph_mgm';

run_time_mgm = toc;
save(strcat('./Result/dblp_Graph.mat'),'R_idx_graph_lda','R_idx_graph_mgm','G_idx_graph','lda_g','mgm_g');
exit;
