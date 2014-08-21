function [ lambda ] = update_lambda(hyper_para, var_para)
%UPDATE_LAMBDA Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Refer to Xiong- p
% lambda : N cell, each of M x Ap  , eta in the derivation
% mu : N cell, each of  K x Ap, ksi in the derivation
% theta: K x M 
% gama: M x N
import GLAD.*; 
import lib.*;

theta = hyper_para.theta;
gama  = var_para.gama;
mu = var_para.mu;
N = length(mu);
lambda = cell(1,N);

for n = 1:N
    Ap = size(mu{n},2);
    lambda{n} = exp(vpa( logs(theta)' * mu{n} + repmat(psi(gama(:,n)) ,[1,Ap] ) ));
    lambda{n} =  mnormalize(lambda{n},1);
end


end

