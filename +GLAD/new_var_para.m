function [phiL, phiR, gama] = new_var_para(alpha, N,M)
%NEW_VAR_PARA Summary of this function goes here
%   Detailed explanation goes here: new variational parameters
phiL = nan(N,N,M);
phiR = nan(N,N,M);
for p = 1:N
    for q = 1:N
        phiL(p,q,:) = mnormalize(1+dirrnd (ones(1,M)),2);
        phiR(p,q,:) = mnormalize(1+dirrnd (ones(1,M)),2);
    end
end
gama = update_gama(phiL,phiR, alpha);


end

