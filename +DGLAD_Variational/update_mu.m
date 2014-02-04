function [ mu ] = update_mu( X, hyper_para, var_para)
%UPDATE_MU Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Detailed explanation goes here: Refer to Xiong- p
% mu : K x N
import DGLAD.*;
import lib.*;


theta = hyper_para.theta;
beta = hyper_para.beta;
lambda = var_para.lambda;

[K,V] = size(beta);
for k = 1:K 
pdf(:,k) = mvnpdf(X,beta(k,:),0.05*eye(V));% exp(Small Number) = 0
end
mu = pdf' .* exp( logs(theta) * lambda); 
mu = mnormalize(mu,1);

end

