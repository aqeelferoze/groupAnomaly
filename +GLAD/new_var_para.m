function var_para = new_var_para(X, hyper_para, N,M,K,V)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here : first assignment

import GLAD.*;
var_para.mu = cell(1,N);
var_para.lambda = cell(1,N);
for n = 1:N
    Ap = length(X{n});
    var_para.mu{n} = ones(K,Ap)/K;
    var_para.lambda{n} =ones(M,Ap)/M;
end

var_para.phiL  = ones(N,N,M)/M;
var_para.phiR  = ones (N,N,M) /M;


var_para.gama = update_gama (hyper_para, var_para);



end

