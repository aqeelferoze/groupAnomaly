import MMSB.*

clear all

global verbose
verbose =1; 

% experiment paramerters
N = 30;
M = 3;
B = eye(M) * 0.8 + 0.01 * ones(M, M);
alpha = 0.1 * ones(1,M);

% set hyper parameters
hyper_para_true.N = N;
hyper_para_true.M = M;
hyper_para_true.B = B;
hyper_para_true.alpha = alpha;

% generate data according to MMSB
data = genData(hyper_para_true);

% generate initial hyper parameters
hyper_para_init = hyper_para_true
hyper_para_init.alpha = 0.1*ones(1,M);
hyper_para_init.B = 0.1.*eye(M)+0.3.*ones(M,M);

[hyper_para,var_para] = mmsb(data.Y, hyper_para_init);

