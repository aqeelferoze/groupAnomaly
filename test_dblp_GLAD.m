clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

global verbose;
verbose = 1;

dblp = load('dblp_P.mat');
dblp = dblp.data;
M = 4;
K = 4;
data.X = dblp.X;
V = length(data.X,2);
data.Y = dblp.Y_bin;

hyper_para.alpha = ones(1,M) * 0.01;
hyper_para.B = eye(M,M)*0.8 + 0.1;
hyper_para.beta = mnormalize(rand(K,V),2);
hyper_para.theta = mnormalize(rand(K,M),1);
hyper_para.nC = 1;

tic;
var_para_glad = GLAD2.train(data,hyper_para);
run_time = toc;
save(strcat('./Result/dblp_GLAD.mat'),'var_para_glad','hyper_para','run_time');