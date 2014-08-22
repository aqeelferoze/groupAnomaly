function [ topic_idx ] = lda_group( X, group_idx, k )
%LDA_GROUP Summary of this function goes here
%   Detailed explanation goes here
import LDA_bow.*
N = size(X,1);
total_num_group = length(unique(group_idx));
topic_idx = zeros(N,1);
for group  = 1: total_num_group
    select_idx = (group_idx ==group);
    [alpha,beta, gammas_group] = lda(X(select_idx,:),k);
    [~,topic_idx_group ]= max(gammas_group,[],2);
    topic_idx(select_idx) = topic_idx_group;
end

