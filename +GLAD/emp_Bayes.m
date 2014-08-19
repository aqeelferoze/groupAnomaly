function [B, theta , beta] =  emp_Bayes (X, Y, hyper_para,var_para)
%EMP_BAYES Summary of this function goes here: Emprical Bayesian to
% estimate hyper-parameters
% Detailed explanation goes here
% gama: M x N
% alpha = update_alpha(gama); % gama: M x N
% mu: N cell, each of K x Ap 
%---- update B
import GLAD.*;
import lib.*;
gama = var_para.gama;
mu = var_para.mu;
lambda = var_para.lambda;

phiL = var_para.phiL;
phiR = var_para.phiR;

[M,N ] = size(gama);
[K,V] = size(hyper_para.beta);


rho = 0;
% alpha = update_alpha(gama);
B = zeros(M,M);
for g =1:M
        for h = 1:M
            B(g,h) = sum(sum(Y.*phiL(:,:,g).* phiR(:,:,h)'))/( (1-rho)*sum(sum(phiL(:,:,g).* phiR(:,:,h)')));
       end
end
% ---------End update B

beta = zeros(K,V);
theta = zeros(K,M);
for n = 1:N
    theta = theta + mu{n} * lambda{n}';
    Ap = size(mu{n},2);
    mu_like = zeros(K,V);
    for a = 1:Ap
        mu_like(:,X{n}(a))= mu_like(:,X{n}(a))+  mu{n}(:,a);
    end
            
    beta = beta + mu_like;
end
theta = mnormalize(theta);

beta = mnormalize(beta, 2);

end



