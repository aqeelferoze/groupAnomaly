function like= var_lik_point( X,Y,hyper_para,var_para )
%VAR_LIK_POINY Summary of this function goes here
%   Detailed explanation goes here
import GLAD.*;
import lib.*;
alpha  = hyper_para.alpha;
B = hyper_para.B;

theta = hyper_para.theta;
beta = hyper_para.beta;

phiL = var_para.phiL;
phiR = var_para.phiR;
gama = var_para.gama;
mu = var_para.mu;
lambda = var_para.lambda;
[M,N] = size(gama); 

like = zeros( N,1);

for p = 1: N
phif = nan (M,M);
for g = 1:M
    for h =1:M
        
         f = Y(p,:)* logs(B(g,h)) +(1-Y(p,:)) *logs(1-B(g,h));

         phif(g,h) = sum( phiL(p,:,g).* phiR(:,p,h)'.* f,2);
    end
end
phiLpsi = nan(M,1);
phiRpsi = nan(M,1);
for g = 1:M
         phiLpsi(g) =(psi(gama(g,p))-psi(sum(gama(:,p))))  * sum(phiL(p,:,g),2);
end
for h = 1:M
         phiRpsi(h) = (psi(gama(h,p))-psi(sum(gama(:,p)))) *  sum(phiR(:,p,h));
end
loggamma = gammaln(sum(alpha)) - sum(gammaln(alpha))...
          - gammaln(sum(gama(:,p))) + sum(gammaln(gama(:,p)));
      

psigama = (alpha-1) * (psi(gama(:,p))-psi(sum(gama(:,p))))...
          - (gama(:,p)-1)'*(psi(gama(:,p))-psi(sum(gama(:,p))))...
          - sum(sum(sum(phiL(p,:,:).*log(phiL(p,:,:)))))-sum(sum(sum(phiR(:,p,:).*log(phiR(:,p,:)))));


logG = lambda(:,p)'* (psi(gama(:,p))-psi(sum(gama(:,p))));

logR = mu(:,p)'* logs(theta) * lambda(:,p)-mu(:,p)' * logs(mu(:,p)); 

logX = X(p,:) * logs(beta) * mu(:,p) - lambda(:,p)' * logs(lambda(:,p));

like(p) = loggamma + psigama + sum(sum(phif))+ sum(phiLpsi)+ sum(phiRpsi) + logG+logR+logX;
  
end

end

