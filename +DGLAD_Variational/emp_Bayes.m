function [B, theta , beta] =  emp_Bayes (X, Y, var_para)
%EMP_BAYES Summary of this function goes here: Emprical Bayesian to
% estimate hyper-parameters
%   Detailed explanation goes here

%alpha = update_alpha(gama); % gama: M x N
%---- update B
import GLAD.*;
import lib.*;
phiL  = var_para.phiL;
phiR  = var_para.phiR;
gama = var_para. gama;
mu = var_para.mu;
lambda = var_para.lambda;

M = size(phiL,3);
N = size(Y,1);
B = nan(M,M);



    for g =1:M
            for h = 1:M
                B(g,h) = sum(sum(Y.*phiL(:,:,g).* phiR(:,:,h)'))/sum(sum(phiL(:,:,g).* phiR(:,:,h)'));
           end
    end
% ---------End update B

theta = mnormalize(mu * lambda');
beta = mnormalize(X'* mu' );

end



