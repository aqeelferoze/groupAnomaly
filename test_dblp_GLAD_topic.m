clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

import +lib.*;
import +GLAD2.*


raw = load('dblp_Psmall.mat');

X = raw.X_small(:,:);

pr = full(lib.mnormalize(X,2));
[~,max_idx] = max(pr,[],2);
X = mnrnd(10000,pr);
X = X+1;
% avoid X to have zero value

data.Y = raw.Y_small;
data.X = X;
%%

M = 4;
K = 4;
V = size(data.X,2);
hyper_para.alpha = ones(1,M) * 0.01;
hyper_para.B = eye(M,M)*0.8 + 0.1;
hyper_para.beta = lib.mnormalize(rand(K,V),2);
hyper_para.theta = lib.mnormalize(rand(K,M),1);
hyper_para.nC = 1;

tic;
[var_para_glad , hyper_para_glad] = GLAD2.train(data,hyper_para);
run_time = toc;

%%
% save(strcat('./Result/dblp_GLAD.mat'),'var_para_glad','hyper_para_glad','hyper_para','run_time');
% exit;

