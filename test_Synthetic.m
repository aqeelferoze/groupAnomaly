clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 0;

% for M =  [5,10,20,50,100]
for M = [5,10]
    fname = strcat('./Data/syn',int2str(M),'.mat');
    load (fname);
    K = 2;


    %% 
    import GLAD2.*; 
    var_para_glad = GLAD2.train(data,hyper_para);
    [~,G_idx_glad]= max(var_para_glad.lambda);
    [~,R_idx_glad]= max(var_para_glad.mu);
    [ scores_glad ] = lib.anomaly_score(G_idx_glad,R_idx_glad, M,K);

    %% MMSB
    import MMSB.*; 

    [hyper_para_mmsb,var_para_mmsb] = MMSB.mmsb(data.Y,hyper_para);
    [~, G_idx_mmsb] = max(var_para_mmsb.gama);
    G_idx_mmsb = lib.align_index (G_idx_mmsb,data.G);

    %% Graph
    import graphcut.* ;
    [G_idx_graph,Pi,cost]= grPartition(data.Y,M);
    G_idx_graph = G_idx_graph';
    G_idx_graph = lib.align_index (G_idx_graph,data.G);

    fprintf('*******Done with Graph******* \n');

    %% MMSB-LDA 
    import LDA.*;
    options = struct('n_try', 3, 'para', false, 'verbose', false, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    [lda Like_lda]= LDA.Train(data.X, G_idx_mmsb', K, options);
    [~,R_idx_mmsb_lda]= max(lda.phi,[],2);
    R_idx_mmsb_lda = R_idx_mmsb_lda';
    R_idx_mmsb_lda = lib.align_index (R_idx_mmsb_lda,data.R);

    % [score_lda]= lda.score_var(G_idx_mmsb');
    [ scores_mmsb_lda ] = lib.anomaly_score(G_idx_mmsb,R_idx_mmsb_lda, M,K);
    fprintf('*******Done with MMSB-LDA******* \n');

    %% MMSB-MGM 
    import MGM.*;
    options = struct('n_try', 3, 'para', false, 'verbose', false, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    T = 1;
    [mgm Like_mgm]= MGM.Train1(data.X, G_idx_mmsb', T, K, options);
    [~,R_idx_mmsb_mgm]= max(mgm.phi,[],2);
    R_idx_mmsb_mgm = R_idx_mmsb_mgm';
    R_idx_mmsb_mgm = lib.align_index (R_idx_mmsb_mgm,data.R);

    % [score_mgm] = mgm.ScoreVar(data.X, G_idx_mmsb');

    [ scores_mmsb_mgm] = lib.anomaly_score(G_idx_mmsb,R_idx_mmsb_mgm, M,K);

    fprintf('*******Done with MMSB-MGM******* \n');

    %% Graph-LDA
    import LDA.*;
    import lib.*;
    options = struct('n_try', 3, 'para', false, 'verbose', false, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    [lda_g Like_lda_g]= LDA.Train(data.X, G_idx_graph', K, options);
    [~,R_idx_graph_lda]= max(lda_g.phi,[],2);
    R_idx_graph_lda = R_idx_graph_lda';
    % do role alignment
    R_idx_graph_lda = lib.align_index (R_idx_graph_lda,data.R);

    %[score_ldagraph]= lda.score_var(G_idx_graph);

    [ scores_graph_lda] = lib.anomaly_score(G_idx_graph,R_idx_graph_lda, M,K);

    fprintf('*******Done with Graph-LDA******* \n');
    %% Graph-MGM
    import MGM.*;
    options = struct('n_try', 3, 'para', false, 'verbose', true, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    T = 1;
    [mgm_g Like_mgm_g]= MGM.Train1(data.X, G_idx_graph', T, K, options);
    [~,R_idx_graph_mgm]= max(mgm_g.phi,[],2);
    R_idx_graph_mgm = R_idx_graph_mgm';
    %[score_mgmgraph] = mgm_g.ScoreVar(data.X, G_idx_graph');
    R_idx_graph_mgm = lib.align_index (R_idx_graph_mgm,data.R);
    [ scores_graph_mgm] = lib.anomaly_score(G_idx_graph,R_idx_graph_mgm, M,K);


    fprintf('*******Done with Graph-MGM******* \n');
%%
    save(strcat('./Result/synScore',int2str(M),'_2.mat'),'scores_glad','scores_mmsb_lda','scores_mmsb_mgm',...
        'scores_graph_lda','scores_graph_mgm');
end

exit;


