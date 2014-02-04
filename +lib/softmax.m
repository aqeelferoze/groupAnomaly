function res = softmax( v )
%SOFTMAX Summary of this function goes here
%   Detailed explanation goes here

N = size(v, 1);
for n = 1:N
res(n,:) = exp(v(n,:))/sum(exp(v(n,:)));
end

end

