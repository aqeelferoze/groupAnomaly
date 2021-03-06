function [ hyper_para, var_para] = mmsb(Y, hyper_para, hyperMaxPre, varMaxPre)
%MMSB Summary of this function goes here
%   Detailed explanation goes here

global verbose;

import MMSB.*
import lib.*

N = size(Y,1);
M = size(hyper_para.B,1);


hyperMax = 20;
varMax = 50;

if nargin >2
    hyperMax = hyperMaxPre;
    varMax = varMaxPre;
end

thres = 1e-4;

var_para = new_var_para0(hyper_para, N, M);
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

