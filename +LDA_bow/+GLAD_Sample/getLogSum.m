function result = getLogSum(A)
%GETLOGSUM Summary of this function goes here
%   Detailed explanation goes here
% input:  A = log(a1),log(a2),...
% output: result = log(a1+a2+...)
     nN = sort(A,'descend');
     m = nN(1);
     if(~isinf(m))
         nN = nN - m;
         result = log(sum(exp(nN)));
         result = result + m;
     else
         result = -inf;
     end
end

