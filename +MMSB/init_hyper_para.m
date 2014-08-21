function [ hyper_para ] = init_hyper_para(hyper_para_true)
%INIT_HYPER_PARA Summary of this function goes here
%   Detailed explanation goes here
import lib.*

alpha_true=hyper_para_true.alpha;
B_true= hyper_para_true.B;

M = length(B_true);
B = 0.7 * eye(M)+1e-2*ones(M);

hyper_para.alpha= alpha_true;
hyper_para.B = B;

end

