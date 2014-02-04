function [ mu ] = update_mu( X, hyper_para, var_para)
%UPDATE_MU Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Detailed explanation goes here: Refer to Xiong- p
% mu : K x N
import GLAD2.*;
import lib.*;


theta = hyper_para.theta;
beta = hyper_para.beta;
lambda = var_para.lambda;
nC = hyper_para.nC;

[K,V] = size(beta);
N=  size(lambda,2);
pdf = zeros(N,K);
% for k = 1:K 
%   pdf(:,k) = mvnpdf(X,beta(k,:),0.05*eye(V));% exp(Small Number) = 0
% end
% mu = pdf' .* exp( logs(theta) * lambda); 

mu = zeros(K,N,nC);
for m = 1:nC
     mu(:,:,m) = exp(vpa( logs(theta) * lambda(:,:,m) + logs(beta)*X'));
end
mu = sum(mu,3);
% exp(Small Number) = 0
mu = mnormalize(mu,1);

end

