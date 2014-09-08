function [B, theta , beta] =  emp_Bayes (X, Y, hyper_para,var_para)
%EMP_BAYES Summary of this function goes here: Emprical Bayesian to
% estimate hyper-parameters
% Detailed explanation goes here
% gama: M x N
% theta: K x M
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

%  ----- parallel over groups
for g =1:M
        for h = 1:M
            B(g,h) = sum(sum(Y.*phiL(:,:,g).* phiR(:,:,h)))/( (1-rho)*sum(sum(phiL(:,:,g).* phiR(:,:,h))));
       end
end           
% ---------End update B

beta = zeros(K,V);
theta = zeros(K,M);
parfor n = 1:N
    theta = theta + mu{n} * lambda{n}';
end

for n = 1:N
    Ap = size(mu{n},2);
    X_n= zeros(V, Ap);
    
    ind = sub2ind(size(X_n), X{n}(:)', 1:Ap);
    X_n (ind) = 1;
    
    beta = beta + mu{n} * X_n';
    
    %for a = 1:Ap
    %mu_like(:,X{n}(1:Ap))= mu_like(:,X{n}(1:Ap))+  mu{n}(:,1:Ap);
    %end       
    %beta = beta + mu_like;
    
end


theta = mnormalize(theta ,1);

beta = mnormalize(beta, 2);

end



