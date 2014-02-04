function [ mu ] = update_mu( X, hyper_para, var_para)
%UPDATE_MU Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Detailed explanation goes here: Refer to Xiong- p
% mu : K x N
import GLAD.*;
import lib.*;
theta = hyper_para.theta;
beta = hyper_para.beta;
lambda = var_para.lambda;

mu = exp(vpa(logs(theta) * lambda+ (X * logs(beta))'));% exp(Small Number) = 0
mu = mnormalize(mu,1);

end

