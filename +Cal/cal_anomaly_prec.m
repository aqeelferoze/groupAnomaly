function [ prec ] = cal_anomaly_prec( bad_idx, scores, thres )
%CAL_ANOMALY_PREC Summary of this function goes here
%   thres: alarm percentage

num_total = length(scores);
num_bads = length(bad_idx);
[scores_sort, order ]  =  sort(scores, 1, 'descend');
num_retrvl = ceil(num_total* thres);
anomaly_idx  = order(1:num_retrvl) ;
prec = length(intersect(bad_idx, anomaly_idx))/num_bads;
end

