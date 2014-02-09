function var_para = new_var_para0(hyper_para, N,M)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here : first assignment
import MMSB.*;
var_para.phiL  = ones(N,N,M)/M;
var_para.phiR  = ones (N,N,M) /M;
var_para.gama = update_gama (hyper_para, var_para);

end

