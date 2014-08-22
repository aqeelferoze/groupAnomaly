function [ mu ] = update_mu( X, hyper_para, var_para)
%UPDATE_MU Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Detailed explanation goes here: Refer to Xiong- p
% mu : N cell, each of K x Ap-- kxi in the derivation
% lambda: N cell, each of M x Ap
% beta: K x D (dictionary size)
% X: N cell, each of 1  x Ap , X takes the value from 1-> D
% theta: K x M
import GLAD.*;
import lib.*;


theta = hyper_para.theta;
beta = hyper_para.beta;
lambda = var_para.lambda;
N = length(lambda);
K = size(beta,1);
mu = cell(1,N);


parfor n = 1:N
    % count the activity
% 	fprintf('%d',n);
    Ap = length(X{n});
    x_like = zeros(K,Ap);
%     for a = 1:Ap
%         x_like(:,a)= beta(:,X{n}(a));
%     end
    x_like(:,1:Ap)= beta(:,X{n}(1:Ap));
    

    mu{n} = exp(vpa( logs(theta) * lambda{n}));
    mu{n} = mu{n} .*  x_like;
    % exp(Small Number) = 0
    mu{n} = mnormalize(mu{n},1);
end
% fprintf('\n');
end

