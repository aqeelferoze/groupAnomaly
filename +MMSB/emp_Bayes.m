function [B] =  emp_Bayes (Y, hyper_para, var_para)
%EMP_BAYES Summary of this function goes here: Emprical Bayesian to
% estimate hyper-parameters
%   Detailed explanation goes here

%alpha = update_alpha(gama); % gama: M x N
%---- update B
import MMSB.*;
phiL  = var_para.phiL;
phiR  = var_para.phiR;
gama = var_para. gama;


M = size(phiL,3);
N = size(Y,1);
B = nan(M,M);



for g =1:M
        for h = 1:M
            B(g,h) = sum(sum(Y.*phiL(:,:,g).* phiR(:,:,h)))/sum(sum(phiL(:,:,g).* phiR(:,:,h)));
       end
end

% ---------End update B


end



