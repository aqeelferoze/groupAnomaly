function x = mnormalize(m,d)
% x = mnormalize(m,d)
% normalizes a matrix m along the arbitary dimension d.
% m : matrix
% d : dimension to normalize (default 1)

if nargin < 2
  d = 1;
end 
dim= size(m);

for i= 1:length(dim)
    if(i ~= d)
        dim(i)= 1;
    end
end

de = sum(m,d);


de = repmat(de, dim);
x = m./de;
% handle all zeros situation
% zeroidx = nan(1,length(dim));
% zeroidx = ind2sub(dim,find (de==0));
% end of zero handle
x(~isfinite(x))=1/dim(d);

end
