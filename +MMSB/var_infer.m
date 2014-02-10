function  var_para = var_infer ( Y, hyper_para,var_para,varMax,thres)
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

global verbose;
import MMSB.*;
import lib.*;
if(nargin < 5)
    varMax = 20;
    thres = 1e-5;
end



% phiL = ones(N,N,M)/M;%  N x N x M-3 dim vector
% phiR = ones(N,N,M)/M;%  N x N x M-3 dim vector
% gama = ones(M, N) * 2* N/ M;

%--- Draw from Dirichlet (alpha), update_gama using phi

% [phiL, phiR, gama] = new_var_para(alpha, N,M);

%---

lik = [];
lik_old = var_lik (Y, hyper_para,var_para);

for varIter = 1 : varMax
    if verbose
        fprintf('----Iter = %d , variational likelihood: %d \n',varIter,lik_old);
    end
    [var_para.phiL, var_para.phiR]  = update_phi(Y,hyper_para,var_para);
    [var_para.gama] = update_gama(hyper_para,var_para);



    lik_new = var_lik (Y, hyper_para, var_para); 
    if  converge (lik_old,lik_new,thres) 
        break;
    end
    lik_old= lik_new;
    lik = [lik,lik_new];

end



