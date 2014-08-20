function [ hyper_para ] = init_hyper_para( hyper_para_true )
%INIT_HYPER_PARA Summary of this function goes here
%   Detailed explanation goes here
import lib.*
alpha_true=hyper_para_true.alpha;
B_true= hyper_para_true.B;
beta_true = hyper_para_true.beta ;
theta_true=hyper_para_true.theta;

alpha = alpha_true;
M = length(B_true);
B = 0.7 * eye(M)+1e-2*ones(M);

[~,V]  = size(beta_true);
[K,M] = size(theta_true);
imax = 100;
beta = mnormalize(randi(imax, [K,V]), 2);
theta = mnormalize( randi(imax, [K,M]), 1);

hyper_para.alpha=alpha;
hyper_para.B = B;
hyper_para.beta = beta;
hyper_para.theta = theta;
end

