function [ assign_idx ] = infer_assignment( assign_prob )
%INFER_ASSIGNMENT Summary of this function goes here
%   Detailed explanation goes here

N = length(assign_prob);
assign_idx = cell(1,N);
for n = 1:N
    [~, assign_idx{n}] = max(assign_prob{n});
end

