function var_para = new_var_para0(hyper_para, N,M,K,V)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here : first assignment

var_para.phiL  = ones(N,N,M)/M;
var_para.phiR  = ones (N,N,M) /M;
var_para.mu = ones(K,N)/K;
var_para.lambda = ones(M,N)/M;
var_para.gama = GLAD.update_gama (hyper_para, var_para);



end

