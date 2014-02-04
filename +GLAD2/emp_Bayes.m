function [B, theta , beta] =  emp_Bayes (X, Y, hyper_para,var_para)
%EMP_BAYES Summary of this function goes here: Emprical Bayesian to
% estimate hyper-parameters
%   Detailed explanation goes here

%alpha = update_alpha(gama); % gama: M x N
%---- update B
import GLAD2.*;
import lib.*;
gama = var_para.gama;
mu = var_para.mu;
lambda = var_para.lambda;

nC = hyper_para.nC;
[M,N ] = size(gama);



rho = 0;
% alpha = update_alpha(gama);

for g =1:M
    for h = 1:M
        B(g,h) = sum(sum(Y.*(lambda(g,:)'*lambda(h,:))))/((1-rho)*sum(sum(lambda(g,:)'*lambda(h,:))));
   end
end
B  = B/nC;
% ---------End update B

theta = mnormalize(mu * lambda');
beta = mnormalize(X'* mu' );

end



