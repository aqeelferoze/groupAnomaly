function like = var_lik( X,Y,hyper_para,var_para )
%VAR_LIK Summary of this function goes here
%   Detailed explanation goes here
import GLAD2.*;
import lib.*;
alpha  = hyper_para.alpha;
B = hyper_para.B;

theta = hyper_para.theta;
beta = hyper_para.beta;
nC = hyper_para.nC;

gama = var_para.gama;
lambda = var_para.lambda;
mu = var_para.mu;


[K,M] = size(theta); 
[N,V] = size(X);

% Parallel on Group
for m = 1:nC
    for g = 1:M
        for h =1:M
             f = Y(:,:,m)* logs(B(g,h)) +(1-Y(:,:,m)) *logs(1-B(g,h));
             f(logical(eye(size(f)))) = 0;  % remove diagonal 
             logY(g,h,m) = lambda(g,:,m)*f *lambda(h,:,m)';
        end
    end
end
logY = sum(logY,3);
      
% handle exception when gamma(x) = inf
% loggamma(~isfinite(loggamma))=0;

logPI = N* gammaln(sum(alpha)) - N* sum(gammaln(alpha))+...
    sum((alpha-1) * (psi(gama)-repmat(psi(sum(gama)),[M,1])));
          
for m = 1:nC
    logG(m) = sum(diag( lambda(:,:,m)'* (psi(gama)-repmat(psi(sum(gama)), [M,1]))));
end
logG = sum(logG);
%handle mu = zero, 0*log(0) problem

for m = 1:nC
    logR(m) = sum(diag(mu'* logs(theta) * lambda(:,:,m))); 
end
logR = sum(logR);

logX = sum(diag(X * logs(beta)' * mu));

% logX = 0;
% for k = 1:K
% logX = logX+sum(logs(mvnpdf(X,beta(k,:),0.05*eye(V))));
% end

for m = 1:nC
    logQ(m) =  sum(gammaln(sum(gama))) +sum(sum(gammaln(gama)))+...
    sum(diag((gama-1)'*(psi(gama)-repmat(psi(sum(gama)),[M,1]))))+...
    sum(diag(mu' * logs(mu)))+sum(diag(lambda(:,:,m)' * logs(lambda(:,:,m))));
end
logQ = sum(logQ);

like = logPI+sum(sum(logY))+logG+logR+logX- logQ;
  

end

