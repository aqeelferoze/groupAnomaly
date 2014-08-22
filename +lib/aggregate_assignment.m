function [ assign_aggre ] = aggregate_assignment( assign_input, dim )
%AGGREGATE_ASSIGNMENT Summary of this function goes here
%   Detailed explanation goes here

N = length(assign_input);
assign_aggre = zeros(1,N);

for n = 1:N
    assign_cnt = histc(assign_input{n},1:dim);
    [~, assign_aggre(n)] =  max(assign_cnt);
end  
end

