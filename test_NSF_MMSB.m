clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

import lib.*;

N = 500;
for M = [5 10 20];
    K = 4;
    sz_group =N/M;
    G_idx = [];
    for m = 1:M
        G_idx = [G_idx ; m*ones(sz_group,1)];
    end


    fname = strcat('./Data/data_text/NSF_anomaly_',int2str(M),'.mat');
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
    
    X = X(:,1:1000);

     %% MMSB   
    V = size(X,2);
    hyper_para.alpha = ones(1,M) * 0.01;
    hyper_para.B = eye(M,M)*0.8 + 0.1;
    hyper_para.beta = lib.mnormalize(rand(K,V),2);
    hyper_para.theta = lib.mnormalize(rand(K,M),1);
    hyper_para.nC = 1;
    import MMSB.*; 

    [hyper_para_mmsb,var_para_mmsb] = MMSB.mmsb(Y,hyper_para);
    [~, G_idx_mmsb] = max(var_para_mmsb.gama);
    G_idx_mmsb = G_idx_mmsb';
    
    fprintf('*******Done with MMSB ******* \n');
    
    %% MMSB-LDA
    import LDA.*

    options = struct('n_try', 3, 'para', false, 'verbose', true, ...
            'epsilon', 1e-2, 'max_iter', 20, 'ridge', 1e-2);
    [lda_g Like_lda_g]= LDA.Train(X, G_idx_mmsb, K, options);
    [~,R_idx_mmsb_lda]= max(lda_g.phi,[],2);
    [ scores_mmsb_lda ] = lib.anomaly_score_rd( G_idx_mmsb, R_idx_mmsb_lda, M,K  );    
    
    fprintf('*******Done with MMSB-LDA ******* \n');

    %% MMSB-MGM
    
    if(N <V)
        V = N-1;
    end

    import MGM.*;
    options = struct('n_try', 3, 'para', false, 'verbose',true, ...
            'epsilon', 1e-2, 'max_iter', 20, 'ridge', 1e-2);
    T = 2;
    G_idx_mmsb = reshape(G_idx_mmsb,[length(G_idx_mmsb),1]);
    if(numel(unique(G_idx_mmsb))==1)
        G_idx_mmsb = crossvalind('Kfold', length(G_idx_mmsb), M);
    end
    
    [mgm Like_mgm]= MGM.Train1(X(:,1:V), G_idx_mmsb, T, K, options);
    [~,R_idx_mmsb_mgm]= max(mgm.phi,[],2);
    [ scores_mmsb_mgm ] = lib.anomaly_score_rd( G_idx_mmsb, R_idx_mmsb_mgm, M,K  );
        
    %%
    save(strcat('./Result/mmsbNSF_',int2str(M),'.mat'),'scores_mmsb_mgm','scores_mmsb_lda','R_idx_mmsb_mgm','R_idx_mmsb_lda','G_idx_mmsb');
 
    fprintf('MGM: M = %d Finished\n',M);

end
