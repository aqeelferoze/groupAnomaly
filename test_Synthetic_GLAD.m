clear; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: Generate the Data using Data/genSynData to pick number of groups and
% repeat number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 1;
Ms = 2:10;
repeat_num = 10;
for M = 2:10
    for n = 1:repeat_num

    fname = strcat('./Data/synth/syn',int2str(M),'_',int2str(n),'.mat');
    load(fname);
    [K, V] = size(hyper_para.beta);  
    %% 
    import GLAD.*; 
    import lib.*
    hyper_para_init = GLAD.init_hyper_para(hyper_para); % hyper_para is the ground truth

    [var_para_glad, hyper_para_glad] = GLAD.glad(data,hyper_para_init);
%     [~,G_idx_glad]= max(var_para_glad.gama);
%     [~,R_idx_glad]= max(var_para_glad.mu);

    % get group, role index by aggregating activities
    G_idx_infer = infer_assignment(var_para_glad.lambda);
    R_idx_infer =  infer_assignment(var_para_glad.mu);
    G_idx_glad = lib.aggregate_assignment(G_idx_infer,M);
    R_idx_glad = lib.aggregate_assignment(R_idx_infer,K);

    [ scores_glad ] = lib.anomaly_score(G_idx_glad,R_idx_glad, M,K);
   
%%
    save(strcat('./NewResult/gladScore',int2str(M),'_',int2str(n),'.mat'),'G_idx_glad','R_idx_glad','scores_glad');
    end
end

exit;


