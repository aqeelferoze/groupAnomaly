function var_para = new_var_para(X, hyper_para, N,M,K,V)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here : first assignment

import GLAD.*;
import lib.*
var_para.mu = cell(1,N);
var_para.lambda = cell(1,N);
for n = 1:N
    Ap = length(X{n});
    var_para.mu{n} = mnormalize(rand(K,Ap),1);
    var_para.lambda{n} = mnormalize(rand(M,Ap),1);
end


var_para.phiL  = rand(N,N,M)/M;
var_para.phiR  = rand(N,N,M) /M;
var_para.gama = update_gama (hyper_para, var_para);



end

