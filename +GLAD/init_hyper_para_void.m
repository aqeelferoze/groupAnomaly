function [ hyper_para_init ] = init_hyper_para_void( M,K ,V)
%INIT_HYPER_PARA Summary of this function goes here
%   Detailed explanation goes here
import lib.*
imax = 100;
hyper_para_init.alpha = 0.1 * ones(1,M);
hyper_para_init.B = 0.1.*eye(M)+0.3.*ones(M,M);
hyper_para_init.beta = mnormalize(randi(imax, [K,V]), 2);
hyper_para_init.theta = mnormalize( randi(imax, [K,M]), 1);
end



