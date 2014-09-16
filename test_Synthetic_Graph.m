%clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 1;

repeat_num = 3;
for n = 1:repeat_num
    
    fprintf('Graph M=%d dataNo=%d/%d\n', M, n, repeat_num);
    fname = strcat('./Data/synth/syn',int2str(M),'_',int2str(n),'.mat');
    load (fname);
    [K, V] = size(hyper_para.beta);  

    %% Graph
    import graphcut.* ;
    import lib.*
    [G_idx_graph,Pi,cost]= grPartition(data.Y,M);
    
%     G_aggregate = lib.aggregate_assignment(data.G, M);
%     G_idx_graph = lib.align_index (G_idx_graph,G_aggregate)';

    fprintf('*******Done with Graph******* \n');
    %% Graph-LDA
    import LDA.*;
    import lib.*;
    options = struct('n_try', 3, 'para', false, 'verbose', false, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    X_aggregate = lib.aggregate_activity( data.X, V);
    [lda_g Like_lda_g]= LDA.Train(X_aggregate, G_idx_graph, K, options);
    [~,R_idx_graph_lda]= max(lda_g.phi,[],2);
    R_idx_graph_lda = R_idx_graph_lda';
    
%     % do role alignment
%     R_aggregate = lib.aggregate_assignment(data.R, K);
%     R_idx_graph_lda = lib.align_index (R_idx_graph_lda,R_aggregate);

    %[score_ldagraph]= lda.score_var(G_idx_graph);

    [ scores_graph_lda] = lib.anomaly_score(G_idx_graph,R_idx_graph_lda, M,K);

    fprintf('*******Done with Graph-LDA******* \n');
    %% Graph-MGM
    import MGM.*;
    import lib.*;
    options = struct('n_try', 3, 'para', false, 'verbose', false, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    T = 1;
    [mgm_g Like_mgm_g]= MGM.Train1(X_aggregate, G_idx_graph, T, K, options);
    [~,R_idx_graph_mgm]= max(mgm_g.phi,[],2);
    R_idx_graph_mgm = R_idx_graph_mgm';
    %[score_mgmgraph] = mgm_g.ScoreVar(data.X, G_idx_graph');
%     R_idx_graph_mgm = lib.align_index (R_idx_graph_mgm,R_aggregate);

    [ scores_graph_mgm] = lib.anomaly_score(G_idx_graph,R_idx_graph_mgm, M,K);

    fprintf('*******Done with Graph-MGM******* \n');
%%
    save(strcat('./NewResult/graphScore',int2str(M),'_',int2str(n),'.mat'),'G_idx_graph','R_idx_graph_lda','R_idx_graph_mgm','scores_graph_lda','scores_graph_mgm');
 end


exit;


