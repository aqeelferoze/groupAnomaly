function [ prec, recall ] = cal_prec_recall( truth, G_idx, score )
%CAL_PREC Summary of this function goes here
%   Detailed explanation goes here
%truth = load('~/Downloads/Dataset/data_adams/truth.txt');


idx = find(G_idx==find(score==min(score),1))';
tp = length(intersect(truth,idx)); % true positive
if(tp~=0)
    prec = tp /length(idx);
    recall = tp/ length(truth);

else 
    prec = 0;
    recall = 0;
end
end

