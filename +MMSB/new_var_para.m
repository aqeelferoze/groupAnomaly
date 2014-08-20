function [var_para] = new_var_para(hyper_para, N,M)
%NEW_VAR_PARA Summary of this function goes here
%   Detailed explanation goes here: new variational parameters
import lib.*
import MMSB.*
phiL = nan(N,N,M);
phiR = nan(N,N,M);
for p = 1:N
    for q = 1:N
        phiL(p,q,:) = mnormalize(1+dirrnd (ones(1,M)),2);
        phiR(p,q,:) = mnormalize(1+dirrnd (ones(1,M)),2);
    end
end
var_para.phiL = phiL;
var_para.phiR = phiR;
var_para.gama = update_gama (hyper_para, var_para);

end

