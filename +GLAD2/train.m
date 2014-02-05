function [ var_para ] = train(data, hyper_para, hyperMaxPre, varMaxPre)
% TRAIN Summary of this function goes here
%   Detailed explanation goes here

global verbose;
import GLAD2.*;
import lib.*;

%%
if nargin >2
    hyperMax = hyperMaxPre;
    varMax = varMaxPre;
end
hyperMax = 50 ;
varMax = 20;
thres = 1e-5;



X = data.X;
Y = data.Y;

[N,V] = size(X);
[K,M] = size(hyper_para.theta);


nC = hyper_para.nC;
var_para = new_var_para(hyper_para, N,M,K,V,nC);
lik_old  = var_lik (X, Y, hyper_para,var_para);
%--- Get the initial values

lik = [];
for hyperIter = 1: hyperMax

     % Variationa E step
     % --- using variational value of old hyperIter
     if verbose
        fprintf('--Iter = %d, likelihood = %d \n',hyperIter,lik_old);
     end
     var_para = var_infer ( X, Y,  hyper_para, var_para,varMax,thres);
     lik_new = var_lik (X,Y, hyper_para,var_para);
     if converge(lik_old, lik_new, thres)
         break;
     end
     lik_old = lik_new;
     lik = [lik,lik_new];

     % M step
     [hyper_para.B, hyper_para.theta, hyper_para.beta] =  emp_Bayes (X,Y,hyper_para,var_para);

end
fprintf('Training Finished \n');
% lik = [lik,lik_new];
% plot(1:length(lik), lik);

[~, G_idx] = max(var_para.lambda);
[~, R_idx] = max(var_para. mu);

scores = score_var(X, Y , hyper_para, var_para);

