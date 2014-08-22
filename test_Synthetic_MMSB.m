%clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 1;

%Ms = 2:10;
%repeat_num = 10;
for M = Ms:Me
    for n = 1: repeat_num
    fprintf('MMSB M=%d dataNo=%d/%d\n', M, n, repeat_num);
    fname = strcat('./Data/synth/syn',int2str(M),'_',int2str(n),'.mat');
    load (fname);
    [K, V] = size(hyper_para.beta);  

    %% MMSB
    import MMSB.*; 
    hyper_para_init.alpha = 0.1*ones(1,M);
    hyper_para_init.B = 0.1.*eye(M)+0.3.*ones(M,M);
    [hyper_para_mmsb,var_para_mmsb] = MMSB.mmsb(data.Y,hyper_para_init);
    [~, G_idx_mmsb] = max(var_para_mmsb.gama);
    G_aggregate = lib.aggregate_assignment(data.G, M);
    G_idx_mmsb = lib.align_index (G_idx_mmsb,G_aggregate);% 1 x N vector
    fprintf('*******Done with MMSB ******* \n');
    
    %% MMSB-LDA 
    import LDA_bow.*;
    import lib.*
%     options = struct('n_try', 3, 'para', false, 'verbose', false, ...
%         'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
%      X_aggregate = lib.aggregate_activity( data.X , V);
%      G_idx_mmsb = reshape(G_idx_mmsb, [length(G_idx_mmsb),1]);
%     [lda Like_lda]= LDA.Train(X_aggregate, G_idx_mmsb, K, options);
%     [~,R_idx_mmsb_lda]= max(lda.phi,[],2);
    R_idx_mmsb_lda = lda_group(X_aggregate,G_idx_mmsb,K);
    R_idx_mmsb_lda = R_idx_mmsb_lda';
    
    R_aggregate = lib.aggregate_assignment(data.R, K);
    R_idx_mmsb_lda = lib.align_index (R_idx_mmsb_lda,R_aggregate);

    % [score_lda]= lda.score_var(G_idx_mmsb');
    [ scores_mmsb_lda ] = lib.anomaly_score(G_idx_mmsb,R_idx_mmsb_lda, M,K);
    fprintf('*******Done with MMSB-LDA******* \n');

    %% MMSB-MGM 
    import MGM.*;
    options = struct('n_try', 3, 'para', false, 'verbose', false, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    T = 1;
    if(numel(unique(G_idx_mmsb))==1)
        G_idx_mmsb = crossvalind('Kfold', length(G_idx_mmsb), M);
    end
    G_idx_mmsb = reshape(G_idx_mmsb,[length(G_idx_mmsb),1]);
    [mgm Like_mgm]= MGM.Train1(X_aggregate, G_idx_mmsb, T, K, options);
    [~,R_idx_mmsb_mgm]= max(mgm.phi,[],2);
    R_idx_mmsb_mgm = R_idx_mmsb_mgm';
    
    R_aggregate = lib.aggregate_assignment(data.R, K);
    R_idx_mmsb_mgm = lib.align_index (R_idx_mmsb_mgm,R_aggregate);

    % [score_mgm] = mgm.ScoreVar(data.X, G_idx_mmsb');

    [ scores_mmsb_mgm] = lib.anomaly_score(G_idx_mmsb,R_idx_mmsb_mgm, M,K);

    fprintf('*******Done with MMSB-MGM******* \n');
%%

    save(strcat('./NewResult/mmsbScore',int2str(M),'_',int2str(n),'.mat'),'G_idx_mmsb','R_idx_mmsb_lda','R_idx_mmsb_mgm','scores_mmsb_lda','scores_mmsb_mgm');
    end
end

exit;


