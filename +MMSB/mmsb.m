function [ hyper_para, var_para] = mmsb(Y, hyper_para)
%MMSB Summary of this function goes here
%   Detailed explanation goes here

global verbose;

import MMSB.*
import lib.*

N = size(Y,1);
M = size(hyper_para.B,1);

if(nargin ==2)
% hyper- parameter EM
%----
hyper_para.alpha = 0.1*ones(1,M);
%---generate from Beta function---
% hyper_para.B = betarnd (1,1, [M,M]);
end

%-------
hyperMax = 5;
varMax = 30;
thres = 1e-4;

var_para = new_var_para0(hyper_para, N,M);
lik_old  = var_lik (Y, hyper_para,var_para);
%--- Get the initial values

lik = [];
for hyperIter = 1: hyperMax

     % Variationa E step
     % --- using variational value of old hyperIter
     if verbose
        fprintf('--Iter = %d, likelihood = %d \n',hyperIter,lik_old)
     end
     var_para = var_infer (Y, hyper_para, var_para,varMax,thres);
     lik_new = var_lik (Y, hyper_para, var_para );
     if converge(lik_old, lik_new, thres)
         break;
     end
     lik_old = lik_new;
     lik = [lik,lik_new];

     % M step
     [hyper_para.B] =  emp_Bayes (Y, hyper_para, var_para);

end
lik = [lik,lik_new];
%plot(1:length(lik), lik);


end

