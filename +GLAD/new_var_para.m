function var_para = new_var_para(X, hyper_para, N,M,K,V)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here : first assignment

import GLAD.*;
import lib.*
var_para.mu = cell(1,N);
var_para.lambda = cell(1,N);
for n = 1:N
    Ap = length(X{n});
    var_para.mu{n} = ones(K,Ap)/K;
    var_para.lambda{n} =ones(M,Ap)/M;
end


phiL = ones(N,N,M)*1/M;
phiR = ones(N,N,M)* 1/M;

for p = 1:N
    for q = 1:N
        phiL(p,q,:) = mnormalize(1+dirrnd (ones(1,M)),2);
        phiR(p,q,:) = mnormalize(1+dirrnd (ones(1,M)),2);
    end
end

var_para.phiL  = phiL;
var_para.phiR  = phiR;


var_para.gama = update_gama (hyper_para, var_para);



end

