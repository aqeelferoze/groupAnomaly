function [ mean_new , var_new] = KF_update( mean_old, var_old, theta)
%KF_UPDATE Measurement update step of Kalman Filter
%  take the old Gaussian mean and variance, update the corresponding
%  elements

% in meansurement step var_old = variance + sigma*I
M = length(mean_old);
Ka = var_old / (var_old+(nu)*eye(M));
mean_new = mean_old + Ka*( theta-mean_old);
var_new = var_old - Ka*var_old;


end

