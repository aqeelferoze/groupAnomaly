function [ X_aggre ] = aggregate_activity( X_input, V )
%AGGREGATE_ACTIVITY Summary of this function goes here
%   Detailed explanation goes here
%  takes in cell array and aggregate activity into N x V matrix
N = length(X_input);
X_aggre = zeros(N,V);
for n = 1:N
    X_aggre(n,:) =  histc(X_input{n},[1:V]);
end

% add one to avoid numerical issue
X_aggre = X_aggre +1;

end

