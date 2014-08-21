function like  = var_lik(Y , hyper_para, var_para)
%VAR_LIK Summary of this function goes here: Variational log Likelihood 
%   Detailed explanation goes here: log L(X, Y, pi_{1:N},Z_left, Z_right,G,R)
% Using variational lower bound to approximate
import MMSB.*;
import lib.*;
alpha  = hyper_para.alpha;
B = hyper_para.B;

phiL = var_para.phiL;
phiR = var_para.phiR;
gama = var_para.gama;

[M,N] = size(gama); 

% Parallel on Group
phif = nan(M,M);
for g = 1:M
    for h =1:M
         f = Y* log(B(g,h)) +(1-Y) *log(1-B(g,h));
         phif(g,h) = sum( sum(phiL(:,:,g).* phiR(:,:,h).* f));
    end
end

logY = sum(sum(phif));

% phiLpsi = nan(N,1);
% phiRpsi = nan(N,1);
% 
% for p=1:N
%     phiLpsi(p) = 0;
%     for g=1:M
%         phiLpsi(p) = phiLpsi(p) + ( psi(gama(g,p))-psi(sum(gama(:,p)))) * sum(phiL(p,:,g));
%     end
% end

phiLpsi = nan(M,1);
phiRpsi = nan(M,1);

for g = 1:M
         phiLpsi(g) =(psi(gama(g,:))-psi(sum(gama)))  * sum(phiL(:,:,g),2);
end

for h = 1:M
         phiRpsi(h) = (psi(gama(h,:))-psi(sum(gama))) *  sum(phiR(:,:,h),2);
end

for q=1:N
    phiRpsi(q) = 0;
    for h=1:M
        phiRpsi(q) = ( psi(gama(h,q))-psi(sum(gama(:,q))) ) * sum(phiR(:,q,h),1);
    end
end
logZL  = sum(phiLpsi);
logZR  = sum(phiRpsi);


logPI = N* gammaln(sum(alpha)) - N* sum(gammaln(alpha))+...
        sum( (alpha-1) * (psi(gama)-repmat(psi(sum(gama)),[M,1])) ) ;


logQ =   -sum(sum(gammaln(gama))) + sum(gammaln(sum(gama)))...
         + sum(sum( (gama-1) .* (psi(gama)-repmat(psi(sum(gama)),[M,1])) ))...
         +  sum(sum(sum(phiL.*log(phiL))))+ sum(sum(sum(phiR.*log(phiR))));

     



log_like = logY + logZL + logZR + logPI - logQ;

like = log_like;
  

end

