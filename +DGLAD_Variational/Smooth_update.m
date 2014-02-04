function [ mean_new , var_new ] = Smooth_update( mean_old, var_old, fwdmean, fwdvar)
%SMOOTH_UPDATE Backward smoonthing of the Kalman Filter
%   Taking in values in forward filter, output smoothed values


M = length (mean_old);
Pa = fwdvar / (fwdvar+sigma* eye(M));
mean_new = mean_old * Pa + fwdmean * (1-Pa);
var_new =  Pa* var_old * Pa' +  fwdvar * - Pa*(fwdvar+sigma*eye(M)) *Pa';

end

