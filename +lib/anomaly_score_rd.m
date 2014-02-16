function [ scores ] = anomaly_score_rd( G_idx, R_idx, M,K  )
%ANOMALY_SCORE_RD Summary of this function goes here
%   using the distance from mean as scoring criteria
import lib.*
N = length(G_idx);
theta_emp = zeros(K,M);

for n = 1:N
    theta_emp(R_idx(n), G_idx(n) ) = theta_emp(R_idx(n), G_idx(n) )+1;
end

theta_emp = lib.mnormalize(theta_emp,1);

mean_theta = mean(theta_emp,2);
scores = zeros(M,1);
for m = 1:M
    scores(m) = norm(mean_theta-theta_emp(:,m));
end

end

