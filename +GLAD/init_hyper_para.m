function [ hyper_para ] = init_hyper_para( hyper_para_true )
%INIT_HYPER_PARA Summary of this function goes here
%   Detailed explanation goes here

alpha_true=hyper_para_true.alpha;
B_true= hyper_para_true.B;
beta_true = hyper_para_true.beta ;
theta_true=hyper_para_true.theta;

alpha = alpha_true;
B = ones(size(B_true))*0.5;
[~,V]  = size(beta_true);
[K,M] = size(theta_true);
beta = ones(K,V)*1/V;
theta = ones(K,M)*1/K;

hyper_para.alpha=alpha;
hyper_para.B = B;
hyper_para.beta = beta;
hyper_para.theta = theta;
end

