clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

dblp = load('dblp_P.mat');
dblp = dblp.data;
M = 4;
K = 4;
data.X = dblp.X(1:100,1:100);
V = 100;
data.Y = dblp.Y_bin(1:100,1:100);

hyper_para.alpha = ones(1,M) * 0.01;
hyper_para.B = eye(M,M)*0.8 + 0.1;
hyper_para.beta = mnormalize(rand(K,V),2);
hyper_para.theta = mnormalize(rand(K,M),1);
hyper_para.nC = 1;


var_para_glad = GLAD2.train(data,hyper_para);

