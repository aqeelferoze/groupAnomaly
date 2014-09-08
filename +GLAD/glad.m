function [ var_para , hyper_para] = glad(data, hyper_para, hyperMaxPre, varMaxPre)
% TRAIN Summary of this function goes here
%   Detailed explanation goes here

global verbose;
verbose =1;
import GLAD.*;
import lib.*;

%%

hyperMax = 10 ;
varMax = 50;
thres = 1e-4;

if nargin >2
    hyperMax = hyperMaxPre;
    varMax = varMaxPre;
end

X = data.X;
Y = data.Y;

N= length(X);
V = length(X{1});
[K,M] = size(hyper_para.theta);


var_para = new_var_para(X, hyper_para, N,M,K,V);
% lik_old  = var_lik (X, Y, hyper_para,var_para);
%--- Get the initial values

% lik = [];
for hyperIter = 1: hyperMax

     % Variationa E step
     % --- using variational value of old hyperIter
     if verbose
        fprintf('--Iter = %d \n ',hyperIter);
     end
     var_para = var_infer ( X, Y,  hyper_para, var_para,varMax,thres);
%      lik_new = var_lik (X,Y, hyper_para,var_para);
%      if converge(lik_old, lik_new, thres)
%          break;
%      end
%      lik_old = lik_new;
%      lik = [lik,lik_new];

     % M step
     [hyper_para.B, hyper_para.theta, hyper_para.beta] =  emp_Bayes (X,Y,hyper_para,var_para);
    
%      import Plot.*
%      close all
%      drawResult(data, var_para, hyper_para);
%      fprintf('Finish plot\n');
     
end
% lik = [lik,lik_new];
% plot(1:length(lik), lik);



