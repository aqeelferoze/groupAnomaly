clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

load 'acm_complete.mat';
T = 10;
M= 5;
K = 5;



for t = 2
    X =  doc_bow{t};
    Y = author_adj{t};

     %% MMSB     
    [N, V] = size(X);
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
    
    %% do something to remove constant column
    V0 = size(X,2);
    const_idx = [];
    for v = 1:V0
        if(numel(unique(X(:,v)))==1)
            const_idx = [const_idx,v];
        end
    end

    X(:,const_idx)=[];
    
    V = size(X,2);
    if(N <V)
        V = N-1;
    end
    %% MMSB-MGM 
    
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

    fprintf('*******Done with MMSB-MGM******* \n');
    
    %% predict
    X =  doc_bow_100{t+1};
    Y = author_adj_100{t+1};
    
        V0 = size(X,2);
    const_idx = [];
    for v = 1:V0
        if(numel(unique(X(:,v)))==1)
            const_idx = [const_idx,v];
        end
    end

    X(:,const_idx)=[];
    
    V = size(X,2);
    if(N <V)
        V = N-1;
    end
    
    gmm = GMM.Train(X(:,1:V), K);
    mus = gmm.means; 
    sigmas = gmm.covars;
    lnpdf = gmm.GetProb(X(:,1:V), true); % N*K 
    [L] = Likelihood(mgm, X(:,1:V), lnpdf, G_idx_mmsb);
end