function [ align_idx ] = align_index( indice, true_idx )
%ALIGN_INDEX Summary of this function goes here
%   Detailed explanation goes here

num_group = length(unique(true_idx));
mapping = zeros(1,num_group);
indice_group = cell(1,num_group);
for m = 1:num_group
    indice_group{m}= find(indice == m);
end

for m = 1:num_group
    true_group = find (true_idx == m );
    inter_lengths = zeros(1,num_group);
    for mm = 1:num_group
        inter_lengths (mm) = length(intersect(true_group,indice_group{mm})) ;
    end
    [~ , mapping(m)] = max(inter_lengths);
end

align_idx = indice;
for m = 1:num_group
    align_idx(indice==mapping(m)) =m;
end


