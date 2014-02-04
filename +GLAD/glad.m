function [ hyper_para, var_para] = glad(X, Y, fixed_para, hyper_para)
%MMSB Summary of this function goes here
%   Detailed explanation goes here
import GLAD.*;
import lib.*;

M = fixed_para.M;
K = fixed_para.K;

V = size(X,2);
N = size(Y,1);




hyperMax = 5 ;
varMax = 30;
thres = 1e-5;

if(nargin==3) % No assigned hyperparameter
% hyper- parameter EM
hyper_para.alpha = 0.1*ones(1,M);

%---generate from Beta function---
hyper_para.B = betarnd (1,1, [M,M]);
hyper_para.theta = mnormalize(rand(K,M));
hyper_para.beta =  mnormalize(rand(V,K));
end

var_para = new_var_para0(hyper_para, N,M,K,V);
lik_old  = var_lik (X, Y,hyper_para,var_para, fixed_para);
%--- Get the initial values

lik = [];
for hyperIter = 1: hyperMax

     % Variationa E step
     % --- using variational value of old hyperIter
     var_para = var_infer ( X, Y,  hyper_para, var_para,fixed_para, varMax,thres);
     lik_new = var_lik (X,Y, hyper_para,var_para, fixed_para);
     if converge(lik_old, lik_new, thres)
         break;
     end
     lik_old = lik_new;
     lik = [lik,lik_new];
     fprintf('--Iter = %d, likelihood = %d \n',hyperIter,lik_old)
     % M step
     [hyper_para.B, hyper_para.theta, hyper_para.beta] =  emp_Bayes (X,Y, var_para, fixed_para);

end
lik = [lik,lik_new];
% plot(1:length(lik), lik);


end

