function [ var_para ] = train(data, hyper_para )
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

import DGLAD.*;
import lib.*;
hyperMax = 1 ;
varMax = 50;
thres = 1e-5;

% hyper_para.alpha = data.alpha;
% hyper_para.B = data.B;
% hyper_para.theta = data.theta;
% hyper_para.beta  = data.beta;

X = data.X;
Y = data.Y;

[N,V] = size(X);
K = 3; M  =4;
var_para = new_var_para(hyper_para, N,M,K,V);
lik_old  = var_lik (X, Y, hyper_para,var_para);
%--- Get the initial values

lik = [];
for hyperIter = 1: hyperMax

     % Variationa E step
     % --- using variational value of old hyperIter
     var_para = var_infer ( X, Y,  hyper_para, var_para,varMax,thres);
     lik_new = var_lik (X,Y, hyper_para,var_para);
     if converge(lik_old, lik_new, thres)
         break;
     end
     lik_old = lik_new;
     lik = [lik,lik_new];
     fprintf('--Iter = %d, likelihood = %d \n',hyperIter,lik_old)
     % M step
     %[hyper_para.B, hyper_para.theta, hyper_para.beta] =  emp_Bayes (X,Y, var_para);

end
% lik = [lik,lik_new];
% plot(1:length(lik), lik);

end

