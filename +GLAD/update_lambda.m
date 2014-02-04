function [ lambda ] = update_lambda( hyper_para, var_para)
%UPDATE_LAMBDA Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Refer to Xiong- p
% lambda : M x N 

import GLAD.*; 
import lib.*;
theta = hyper_para.theta;
gama  = var_para.gama;
mu = var_para.mu;


[M,N] = size(gama);

    
t1 = psi(gama)+repmat(psi(sum(gama)),[M,1]);
t2 = logs(theta)'*mu;
lambda = exp(t1+t2);
lambda =  mnormalize(lambda,1);

 end

