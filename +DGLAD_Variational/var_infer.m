function [ var_para ] = var_infer( X, Y,  hyper_para, var_para,varMax,thres )
%VAR_INFER Summary of this function goes here
%   Detailed explanation goes here

% initial 
import DGLAD.*;
import lib.*;
if(nargin < 5)
    varMax = 100;
    thres = 1e-5;
end

lik = [];
lik_old = var_lik (X,Y, hyper_para,var_para);

for varIter = 1 : varMax
 
    [var_para.lambda] = update_lambda( Y, hyper_para, var_para);
    [var_para.gama] = update_gama(hyper_para,var_para);
    [var_para.mu ] = update_mu( X, hyper_para, var_para);
    
    lik_new = var_lik (X,Y, hyper_para, var_para); 
    if  converge (lik_old,lik_new,thres) 
        break;
    end
    lik_old= lik_new;
    lik = [lik,lik_new];
    fprintf('----Iter = %d , variational likelihood: %d \n',varIter,lik_new);
end
lik = [lik,lik_new];
plot(1:length(lik), lik);
end

