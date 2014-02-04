function [B, theta , beta] =  emp_Bayes (X, Y, var_para)
%EMP_BAYES Summary of this function goes here: Emprical Bayesian to
% estimate hyper-parameters
%   Detailed explanation goes here

%alpha = update_alpha(gama); % gama: M x N
%---- update B
import GLAD2.*;
import lib.*;
gama = var_para.gama;
mu = var_para.mu;
lambda = var_para.lambda;

[M,N ] = size(gama);
nC = size(lambda,3);


rho = 0;
alpha = update_alpha(gama);
for m = 1:nC
    for g =1:M
        for h = 1:M
            B(g,h,m) = sum(sum(Y(:,:,m).*(lambda(g,:,m)'*lambda(h,:,m))))/((1-rho)*sum(sum(lambda(g,:,m)'*lambda(h,:,m))));
       end
    end
end

B  = sum(B,3)/M;
% ---------End update B
for m = 1:nC
    theta (:,:,m)= mnormalize(mu * lambda(:,:,m)');
end
theta = sum(theta,3);
beta = mnormalize(X'* mu' );

end



