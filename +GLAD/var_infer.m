function  var_para = var_infer ( X, Y, hyper_para,var_para, fixed_para, varMax,thres)
%VAR_INFER Summary of this function goes here: variational inference for BLAD model
%   Detailed explanation goes here:
% Input: refer to blad.m \\
% Output : variational parameters\\
% phi_left : M x N phi p -> q , variational parameter for multinomial (z_left)
% gama : M x N, variational parameter for Dirichlet ( pi )
% lambda : M x N , ... for multinomial (G)
% mu : K x N, ... for multinomial (R)

% Blockwise Membership  \\

% initial 
import GLAD.*;
import lib.*;
if(nargin < 6)
    varMax = 100;
    thres = 1e-5;
end



% phiL = ones(N,N,M)/M;%  N x N x M-3 dim vector
% phiR = ones(N,N,M)/M;%  N x N x M-3 dim vector
% gama = ones(M, N) * 2* N/ M;

%--- Draw from Dirichlet (alpha), update_gama using phi

% [phiL, phiR, gama] = new_var_para(alpha, N,M);

%---

lik = [];
lik_old = var_lik (X,Y, hyper_para,var_para, fixed_para);

for varIter = 1 : varMax

    [var_para.phiL, var_para.phiR]  = update_phi(Y,hyper_para,var_para, fixed_para.nC);
    [var_para.gama] = update_gama(hyper_para,var_para);
    [var_para.mu ] = update_mu( X, hyper_para, var_para);
    [var_para.lambda] = update_lambda( hyper_para, var_para);


    lik_new = var_lik (X,Y, hyper_para, var_para,fixed_para); 
    if  converge (lik_old,lik_new,thres) 
        break;
    end
    lik_old= lik_new;
    lik = [lik,lik_new];
    fprintf('----Iter = %d , variational likelihood: %d \n',varIter,lik_new);
end



