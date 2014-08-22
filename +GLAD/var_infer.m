function [ var_para ] = var_infer( X, Y,  hyper_para, var_para,varMax,thres )
%VAR_INFER Summary of this function goes here
%   Detailed explanation goes here

% initial 
global verbose
import GLAD.*;
import lib.*;
if(nargin < 5)
    varMax = 30;
    thres = 1e-2;
end

% lik = [];
% lik_old = var_lik (X,Y, hyper_para,var_para);

for varIter = 1 : varMax
    if verbose
        fprintf('----Iter = %d , variational likelihood:  \n',varIter);
    end 
    fprintf('----update_lambda = \n');
    [var_para.lambda] = update_lambda( hyper_para, var_para);
    fprintf('----update_gama = \n');
    [var_para.gama] = update_gama(hyper_para,var_para);
    fprintf('----update_phi = \n');
    [var_para.phiL, var_para.phiR]  = update_phi(Y,hyper_para,var_para);
    fprintf('----update_mu = \n');
    [var_para.mu ] = update_mu( X, hyper_para, var_para);
    
%     lik_new = var_lik (X,Y, hyper_para, var_para); 
%     if  converge (lik_old,lik_new,thres) 
%         break;
%     end
    
%     if(lik_new < lik_old)
%         break;
% %     end
%     lik_old= lik_new;
%     lik = [lik,lik_new];
 
end
% lik = [lik,lik_new];
% plot(1:length(lik), lik);
end

