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
x = double(x);

if(~isempty(find(de==0)))
    warning('Normalize: Zero Sum to all equal.');
    idx = de==0;
    x(idx) = 1/dim(d);   
end
%x(~isfinite(x))=1/dim(d);

end
