function [ lambda ] = update_lambda( Y, hyper_para, var_para)
%UPDATE_LAMBDA Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Refer to Xiong- p
% lambda : M x N 

import GLAD2.*; 
import lib.*;
B = hyper_para.B;
theta = hyper_para.theta;
nC = hyper_para.nC;
gama  = var_para.gama;
lambda = var_para.lambda;
mu = var_para.mu;


M= size(lambda,1);
N = size(lambda,2);
t1 = psi(gama)+repmat(psi(sum(gama)),[M,1]);
t2 = logs(theta)'*mu;


t3 = zeros (M,N);
for m = 1:nC
    for g = 1:M
        for h =1:M
             f = Y(:,:,m)* logs(B(g,h)) +(1-Y(:,:,m)) *logs(1-B(g,h));
             f(logical(eye(size(f)))) = 0;  % remove diagonal 
             t3(g,:) =   t3(g,:)+ (f *lambda(h,:,m)')';% why there is 2-coefficient before f?
        end
    end
    lambda(:,:,m) = exp(vpa(t1+t2+t3));

end
lambda=  mnormalize(lambda,1);


end

