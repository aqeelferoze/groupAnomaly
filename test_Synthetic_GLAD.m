clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 0;

for M = 2:10
    for n = 6:10

    fname = strcat('./Data/synth/syn',int2str(M),'_',int2str(n),'.mat');
    load(fname);
    K = 2;   
    %% 
    import GLAD2.*; 
    var_para_glad = GLAD2.train(data,hyper_para);
    [~,G_idx_glad]= max(var_para_glad.lambda);
    [~,R_idx_glad]= max(var_para_glad.mu);
    [ scores_glad ] = lib.anomaly_score(G_idx_glad,R_idx_glad, M,K);
   
%%
    save(strcat('./Result/gladScore',int2str(M),'_',int2str(n),'.mat'),'G_idx_glad','R_idx_glad','scores_glad');
    end
end

exit;


