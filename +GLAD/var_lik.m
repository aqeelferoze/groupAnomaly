function like  = var_lik(X,Y,hyper_para,var_para, fixed_para)
%VAR_LIK Summary of this function goes here: Variational log Likelihood 
%   Detailed explanation goes here: log L(X, Y, pi_{1:N},Z_left, Z_right,G,R)
% Using variational lower bound to approximate
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

% for p = 1:N
%     for q = 1:N
%         phif(p,q) = permute(phi(p,q,:),[1,3,2]) * ((Y(p,q) * log(B) +(1-Y(p,q)) *log((1-B)))) * permute(phi(q,p,:),[3,2,1]);
%         phipsi(p,q) = permute(phi(p,q,:),[1,3,2])* (psi(gama(:,p))-repmat(psi(sum(gama(:,p))), [M,1]));
%     end
% end

% Parallel on Group
phif = nan (M,M);
for g = 1:M
    for h =1:M
         f = Y* log(B(g,h)) +(fixed_para.nC-Y) *log(1-B(g,h));
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
         phiRpsi(h) = (psi(gama(h,:))-psi(sum(gama))) *  sum(phiR(:,:,h),2);
end
loggamma = N* gammaln(sum(alpha)) - N* sum(gammaln(alpha))...
          - sum(gammaln(sum(gama))) +sum(sum(gammaln(gama)));
      
% handle exception when gamma(x) = inf
% loggamma(~isfinite(loggamma))=0;

psigama = sum((alpha-1) * (psi(gama)-repmat(psi(sum(gama)),[M,1])))...
          - sum(diag((gama-1)'*(psi(gama)-repmat(psi(sum(gama)),[M,1]))))...
          - sum(sum(sum(phiL.*log(phiL))))-sum(sum(sum(phiR.*log(phiR))));


logG = sum(diag( lambda'* (psi(gama)-repmat(psi(sum(gama)), [M,1]))));
%handle mu = zero, 0*log(0) problem
log_mu = log(mu);
log_mu(~isfinite(log_mu))=0;
logR = sum(diag(mu'* log(theta) * lambda))-sum(diag(mu' * log_mu)); 

log_beta = log(beta);
log_beta(~isfinite(log_beta))=0;
logX = sum(diag(X * log_beta * mu)) -sum(diag(lambda' * log(lambda)));

like = loggamma + psigama + sum(sum(phif))+ sum(phiLpsi)+ sum(phiRpsi) + logG+logR+logX;
  

end

