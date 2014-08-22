clear; clc;
import GLAD.*; 
import lib.*
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 1;

import lib.*
data.X = load('./Data/data_adams/activity.txt');
data.X = lib.rescale(data.X,1,20);

data.Y= load('./Data/data_adams/E.txt');
data.Y = double (data.Y>0);
% data.X = data.X(1:5,:);
% data.Y = data.Y(1:5,1:5);
truth =  load('./Data/data_adams/truth.txt');
%%
M = 10; K = 3; 
repeat_num = 5;

for n = 1:repeat_num   
     %% Graph
    import graphcut.* ;
    import lib.*
    [G_idx_graph,Pi,cost]= grPartition(data.Y,M);
    fprintf('*******Done with Graph******* \n');
    %% Graph-LDA
    import LDA.*;
    import lib.*;
    options = struct('n_try', 3, 'para', false, 'verbose', false, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    G_idx_graph = reshape(G_idx_graph,[length(G_idx_graph),1]);

    [lda_g Like_lda_g]= LDA.Train(data.X, G_idx_graph, K, options);
    [~,R_idx_graph_lda]= max(lda_g.phi,[],2);
    R_idx_graph_lda = R_idx_graph_lda';
    [ scores_graph_lda] = lib.anomaly_score(G_idx_graph,R_idx_graph_lda, M,K);

    fprintf('*******Done with Graph-LDA******* \n');
    %% Graph-MGM
    import MGM.*;
    import lib.*;
    options = struct('n_try', 3, 'para', false, 'verbose', true, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    T = 1;
    if(numel(unique(G_idx_graph))==1)
        G_idx_graph = crossvalind('Kfold',length(G_idx_graph),M);
    end
    G_idx_graph = reshape(G_idx_graph,[length(G_idx_graph),1]);
    
    [mgm_g Like_mgm_g]= MGM.Train1(data.X, G_idx_graph, T, K, options);
    [~,R_idx_graph_mgm]= max(mgm_g.phi,[],2);
    R_idx_graph_mgm = R_idx_graph_mgm';
    [ scores_graph_mgm] = lib.anomaly_score(G_idx_graph,R_idx_graph_mgm, M,K);
    fprintf('*******Done with Graph-MGM******* \n');
%%
    save(strcat('./NewResult/graphAdams_',int2str(n),'.mat'),'G_idx_graph','R_idx_graph_lda','R_idx_graph_mgm','scores_graph_lda','scores_graph_mgm');
end
  
%%

exit;


