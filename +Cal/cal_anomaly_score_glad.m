function [ scores ] = cal_anomaly_score_glad( hyper_para, var_para )
%CAL_ANOMALY_SCORE_GLAD Summary of this function goes here
%   Detailed explanation goes here: compute group and role, calculate
%   anomaly score
good = [0.9,0.1]'; % K = 2
bad = [0.1,0.9]';
M = length(hyper_para.alpha); % group number
scores = zeros(M,1);

for m = 1:M
    theta_est = hyper_para.theta;
    scores(m) = norm(good-theta_est(:,m));
end

% measure the deviation from the mean

% theta_est = hyper_para.theta;
% mean_theta = mean(theta_est,2 );
% 
% for m = 1:M
%     scores(m) = norm(theta_est(:,m)-mean_theta);
% end

end

