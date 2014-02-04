function like = var_lik( X,Y,hyper_para,var_para )
%VAR_LIK Summary of this function goes here
%   Detailed explanation goes here

import lib.*;
alpha  = hyper_para.alpha;
B = hyper_para.B;

theta = hyper_para.theta;
beta = hyper_para.beta;

gama = var_para.gama;
lambda = var_para.lambda;
mu = var_para.mu;


[K,M] = size(theta); 
[N,V] = size(X);

% Parallel on Group
phif = nan (M,M);
for g = 1:M
    for h =1:M
         f = Y* log(B(g,h)) +(1-Y) *log(1-B(g,h));
         logY(g,h) = lambda(g,:)*f *lambda(h,:)';
    end
end
      
% handle exception when gamma(x) = inf
% loggamma(~isfinite(loggamma))=0;

logPI = N* gammaln(sum(alpha)) - N* sum(gammaln(alpha))+...
    sum((alpha-1) * (psi(gama)-repmat(psi(sum(gama)),[M,1])));
          

logG = sum(diag( lambda'* (psi(gama)-repmat(psi(sum(gama)), [M,1]))));
%handle mu = zero, 0*log(0) problem

logR = sum(diag(mu'* log(theta) * lambda)); 
logX =0;

for k = 1:K
logX = logX+sum(log(mvnpdf(X,beta(k,:),0.05*eye(V))));
end


logQ =  sum(gammaln(sum(gama))) +sum(sum(gammaln(gama)))+...
    sum(diag((gama-1)'*(psi(gama)-repmat(psi(sum(gama)),[M,1]))))+...
    sum(diag(mu' * logs(mu)))+sum(diag(lambda' * logs(lambda)));

like = logPI+sum(sum(logY))+logG+logR+logX- logQ;
  

end

