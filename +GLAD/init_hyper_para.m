function [ hyper_para_init ] = init_hyper_para( hyper_para_true )
%INIT_HYPER_PARA Summary of this function goes here
%   Detailed explanation goes here
import lib.*
alpha_true=hyper_para_true.alpha;
B_true= hyper_para_true.B;
beta_true = hyper_para_true.beta ;
theta_true=hyper_para_true.theta;


M = length(B_true);


[~,V]  = size(beta_true);
[K,M] = size(theta_true);
imax = 100;


% generate initial hyper parameters
hyper_para_init = hyper_para_true;
hyper_para_init.alpha = alpha_true;
hyper_para_init.B = 0.1.*eye(M)+0.3.*ones(M,M);
hyper_para_init.beta = mnormalize(randi(imax, [K,V]), 2);
hyper_para_init.theta = mnormalize( randi(imax, [K,M]), 1);

end

