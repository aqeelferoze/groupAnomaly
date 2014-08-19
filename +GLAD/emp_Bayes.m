function [B, theta , beta] =  emp_Bayes (X, Y, hyper_para,var_para)
%EMP_BAYES Summary of this function goes here: Emprical Bayesian to
% estimate hyper-parameters
%   Detailed explanation goes here
% gama: M x N
%alpha = update_alpha(gama); % gama: M x N
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
B  = B/nC;
% ---------End update B

beta = zeros(K,V);
for n = 1:N
    theta = theta + mu{n} * lambda{n}';
    X_cnt = histc(X{n},1:V);
    beta = beta + mu{n} * X_cnt;
end
theta = mnormalize(theta);

beta = mnormalize(beta, 2);

end



