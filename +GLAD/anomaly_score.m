function [ scores ] = anomaly_score( var_para)
%ANOMALY_SCORE Summary of this function goes here
%   Detailed explanation goes here

import lib.*;
good = [0.9,0.1]'; % K = 2
bad = [0.1,0.9]';

[~, G_idx] = max(var_para.lambda);
[~, R_idx] = max(var_para.mu);
N = 1000;
K = size(var_para.mu,1);
M = size(var_para.lambda,1);
theta_emp = zeros(K,M);
for n = 1:N
    theta_emp(R_idx(n), G_idx(n) ) = theta_emp(R_idx(n), G_idx(n) )+1;
end

theta_emp = mnormalize(theta_emp,1);

scores = zeros(M,1);
for m = 1:M
    scores(m) = norm(good-theta_emp(:,m));
end

end

