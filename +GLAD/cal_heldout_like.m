function like = cal_heldout_like(data, hyper_para)
%CAL_HELDOUT_LIKE Summary of this function goes here
%   Detailed explanation goes here
    X = data.X;
    Y = data.Y;

    N= length(X);
    V = length(X{1});
    [K,M] = size(hyper_para.theta);
    var_para = new_var_para(X, hyper_para, N,M,K,V);
    [var_para] = var_infer( X, Y,  hyper_para, var_para);
    like = var_like_noE( X,Y,hyper_para,var_para );
end

