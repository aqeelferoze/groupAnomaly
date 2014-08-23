function like = var_like_noE( X,Y,hyper_para,var_para )
%VAR_LIK Summary of this function goes here
%   Detailed explanation goes here
% lambda : N cell, each of M x Ap  , eta in the derivation
% mu : N cell, each of M x Ap, ksi in the derivation
% theta: K x M 
% gama: M x N

import GLAD.*;
import lib.*;

alpha  = hyper_para.alpha;
B = hyper_para.B;

theta = hyper_para.theta;
beta = hyper_para.beta;

gama = var_para.gama;
lambda = var_para.lambda;
mu = var_para.mu;
phiL = var_para.phiL;
phiR = var_para.phiR;

[~,M] = size(theta); 
[K,V] = size(beta);
 N = length(X);

% Parallel on Group
phif = nan (M,M);
for g = 1:M
    for h =1:M
         f = Y* log(B(g,h)) +(1-Y) *log(1-B(g,h));
%         f = log (Y*B(g,h) + (1-Y) * (1-B(g,h)));
         phif(g,h) = sum( sum(phiL(:,:,g).* phiR(:,:,h).* f));
    end
end
phiLpsi = nan(M,1);
phiRpsi = nan(M,1);

for g = 1:M
         phiLpsi(g) =(psi(gama(g,:))-psi(sum(gama)))  * sum(phiL(:,:,g),2);
end

for h = 1:M
         phiRpsi(h) = (psi(gama(h,:))-psi(sum(gama))) *  sum(phiR(:,:,h),1)';% switch the p-q index
end
      
% handle exception when gamma(x) = inf
% loggamma(~isfinite(loggamma))=0;

logPI = N* gammaln(sum(alpha)) - N* sum(gammaln(alpha))+...
    sum((alpha-1) * (psi(gama)-repmat(psi(sum(gama)),[M,1])));

logZL  = sum(phiLpsi);
logZR  = sum(phiRpsi);

logY = sum(sum(phif));


N = length(X);
logG = 0; logR =0;
for n = 1:N
    logG = logG + sum(lambda{n}'* log_pi(gama(:,n)));
    logR = logR + sum(diag(mu{n}'* logs(theta) * lambda{n})); 

end

%handle mu = zero, 0*log(0) problem
logX = 0;
log_beta = logs(beta);
for n = 1:N
   Ap = length(X{n});
   x_like = zeros(K,Ap);
   for a = 1:Ap
        x_like(:,a)= log_beta(:,X{n}(a));
   end

   logX = logX+ sum( sum( mu{n} .*  x_like ) );
end

log_like = logY + logZL + logZR  +logPI+logG+logR+logX;
 
log_like = log_like / N;
like = exp(log_like);

end

