function [ alpha ] = update_alpha( gama )
%UPDATE_ALPHA Summary of this function goes here
%   Detailed explanation goes here
[M, N] =size(gama);
a_ini = 10;
alpha_iter_max = 50; 

log_a = log(a_ini);

ss = sum(sum(psi(gama) - repmat(psi(sum(gama)), [M,1])));
for iter = 1: alpha_iter_max
    a = exp(log_a);
    f = N * ( gammaln(M *a) - M * gammaln(a)) + (a-1) * ss;
    d1 = N * M* ( psi(M * a)-  psi(a) )  +  ss;
    d2 = N  * (M * M * psi(1,M * a)- M * psi(1,a));
    log_a_new = log_a - d1 /(d2*a + f);
    if (converge(log_a_new, log_a, 1e-10)) 
        break;
    end
    log_a = log_a_new;
%fprintf('----alpha = %d \n',exp(log_a));
%fprintf('---- d1 = %d \n',d1);
end

alpha = exp(log_a) * ones(1,M);
