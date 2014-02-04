function scores = score_var(X, Y , hyper_para, var_para )
%SCORE_VAR Summary of this function goes here
%   Detailed explanation goes here
import GLAD2.*;
import lib.*;
alpha = hyper_para.alpha;
B = hyper_para.B;
theta = hyper_para.theta;
beta = hyper_para.beta;

lambda = var_para.lambda;
mu = var_para.mu;

M = length(alpha);
[K,N] = size(mu);
cut = 0.1;



scores =zeros(M,1);
nsample = 100;
    
for ind = 1:nsample
    Gs = randm(lambda');% approximate q(G_p| lambda)
    Rs = randm(mu');% approximate q(R_p| mu)
    
    % calculate <logP(R|alpha)>
    group_role_hist = accumarray([Gs Rs], 1, [M, K]);
    for m = 1:M
        scores(m) =scores(m) + log( mnpdf (group_role_hist(m,:),theta(:,m)')*  alpha(m));% need to average over group size
        
    end
    scores = scores./sum(group_role_hist,2);
    scores( sum(group_role_hist,2)==0) = 0;
end
scores = scores/nsample;

scores = scores - quantile(scores, cut);
scores = logistic(scores./RMSE(scores)*5);
scores = 1-scores;