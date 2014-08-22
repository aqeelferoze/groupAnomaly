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
data.X = data.X(1:5,:);
data.Y = data.Y(1:5,1:5);
truth =  load('./Data/data_adams/truth.txt');
%%
M = 10; K = 3; 
repeat_num = 5;

for n = 1:repeat_num   
    %% MMSB
    import MMSB.*; 
    hyper_para_init.alpha = 0.1*ones(1,M);
    hyper_para_init.B = 0.1.*eye(M)+0.3.*ones(M,M);
    [hyper_para_mmsb,var_para_mmsb] = MMSB.mmsb(data.Y,hyper_para_init);
    [~, G_idx_mmsb] = max(var_para_mmsb.gama);
    fprintf('*******Done with MMSB ******* \n');
    
    %% MMSB-LDA 
    import LDA.*;
    import lib.*
    options = struct('n_try', 3, 'para', false, 'verbose', false, ...
        'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
     G_idx_mmsb = reshape(G_idx_mmsb, [length(G_idx_mmsb),1]);
    [lda Like_lda]= LDA.Train(data.Y, G_idx_mmsb, K, options);
    [~,R_idx_mmsb_lda]= max(lda.phi,[],2);
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
    [ scores_mmsb_mgm] = lib.anomaly_score(G_idx_mmsb,R_idx_mmsb_mgm, M,K);

    fprintf('*******Done with MMSB-MGM******* \n');
%%

    save(strcat('./NewResult/mmsbAdams_',int2str(n),'.mat'),'G_idx_mmsb','R_idx_mmsb_lda','R_idx_mmsb_mgm','scores_mmsb_lda','scores_mmsb_mgm');
end
  
%%

exit;


