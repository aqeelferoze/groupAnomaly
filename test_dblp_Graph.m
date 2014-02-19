clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

import lib.*;

N = 500;
K = 4;
for conf_idx = [1 17 19]
for M = [5 10 20 50 ];

    sz_group = N/M;

    G_idx = [];
    for m = 1:M
        G_idx = [G_idx ; m*ones(sz_group,1)];
    end
    fname = strcat('./Data/data_text/dblp_anomaly_',int2str(M),'_',int2str(conf_idx),'.mat');
    load(fname);
    X = X(:,1:1000);

    %% Graph
    import graphcut.* ;
    [G_idx_graph,Pi,cost]= grPartition(Y,M);
    fprintf('*******Done with Graph ******* \n');
       
    
    %% Graph-LDA
    import LDA.*

    options = struct('n_try', 3, 'para', false, 'verbose', true, ...
            'epsilon', 1e-2, 'max_iter', 20, 'ridge', 1e-2);
    [lda_g Like_lda_g]= LDA.Train(X, G_idx_graph, K, options);
    [~,R_idx_graph_lda]= max(lda_g.phi,[],2);
    [ scores_graph_lda ] = lib.anomaly_score_rd( G_idx_graph, R_idx_graph_lda, M,K  );    
    
    %% do something to remove constant column
    V0 = size(X,2);
    const_idx = [];
    for v = 1:V0
        if(numel(unique(X(:,v)))==1)
            const_idx = [const_idx,v];
        end
    end

    X(:,const_idx)=[];

    %% Graph-MGM
    V = size(X,2);
    if(N <V)
        V = N-1;
    end

    import MGM.*;
    options = struct('n_try', 3, 'para', false, 'verbose',false, ...
            'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
    T = 2;
    [mgm Like_mgm]= MGM.Train1(X(:,1:V), G_idx_graph, T, K, options);
    [~,R_idx_graph_mgm]= max(mgm.phi,[],2);
    [ scores_graph_mgm ] = lib.anomaly_score_rd( G_idx_graph, R_idx_graph_mgm, M,K  );
       
    
    %%
    save(strcat('./Result/graphDBLP_',int2str(M),'_',int2str(conf_idx),'.mat'),'scores_graph_mgm','scores_graph_lda','R_idx_graph_mgm','R_idx_graph_lda','G_idx_graph');
 
    fprintf('MGM: M = %d Finished\n',M);
end
end