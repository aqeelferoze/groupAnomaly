function var_para = new_var_para(hyper_para, N,M,K,V)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here : first assignment

import DGLAD.*;
var_para.mu = ones(K,N)/K;
var_para.lambda = ones(M,N)/M;
var_para.gama = update_gama (hyper_para, var_para);



end

