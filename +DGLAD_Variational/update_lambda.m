function [ lambda ] = update_lambda( Y, hyper_para, var_para)
%UPDATE_LAMBDA Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Refer to Xiong- p
% lambda : M x N 

import DGLAD.*; 
import lib.*;
B = hyper_para.B;
theta = hyper_para.theta;
gama  = var_para.gama;
lambda = var_para.lambda;
mu = var_para.mu;


[M,N] = size(gama);
t1 = psi(gama)+repmat(psi(sum(gama)),[M,1]);
t2 = log(theta)'*mu;

% Add term w.r.t Y
for p = 1:N
    for q = 1:N
        for g = 1:M
            for h = 1:M
                f(p,q,g,h) = Y(p,q)*log(B(g,h))+(1-Y(p,q))*log(1-B(g,h));
            end
        end
    end
end
for p = 1:N
    for m = 1: M
        for q = 1:N
              for h = 1:M
                tmp(p,q,m,h) = lambda(p,m)*f(p,q,m,h);
              end
        end
        tmp(p,p,:,:) = 0;
        t1(m,p) = reshape(sum(sum(tmp,2),4),[1,1]);
    end
end
lambda = exp(t1+t2+t3);
lambda =  mnormalize(lambda,1);

end

