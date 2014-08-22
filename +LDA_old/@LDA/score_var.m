function [ score ] = score_var( self, group_id )
%SCORE_VAR Summary of this function goes here
%   Detailed explanation goes here
import LDA.*;
import lib.*;
phi = self.phi;
alpha = self.alpha;
M = max(group_id);
K = length(alpha);
score = 0;
nsample = 100;


for ind = 1:nsample
    zs = randm(phi);% approximate q(z_m| phi), draw n zs
    group_z_hist = accumarray([group_id(:) zs(:)], 1, [M, K]);
    % gonna use property of Dirichlet -Multinomial
    % <logp(z|alpha)>
    p_z =  sum(gammaln(group_z_hist + repmat(alpha, [M,1]))- repmat(gammaln(alpha),[M,1]),2);

    score = score + p_z;
    score = score./sum(group_z_hist,2);
    score(sum(group_z_hist,2) ==0) = 0;
end
score = score/ nsample;

cut = 0.1;
score = score - quantile(score, cut);
score = lib.logistic(score./lib.RMSE(score)*5);
end

