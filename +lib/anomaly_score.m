function [ scores ] = anomaly_score(G_idx, R_idx, M,K )
%ANOMALY_SCORE Summary of this function goes here
%   Detailed explanation goes here


import lib.*;
good = [0.9,0.1]'; % K = 2
bad = [0.1,0.9]';

N = length(G_idx);
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

