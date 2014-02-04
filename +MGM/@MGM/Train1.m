% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [mgm, L] = Train1(X, group_id, T, K, options)
% [mgm, L] = Train1(X, group_id, T, K, options)
% see MGM.Train: no parallel processing of MGM.Train
import MGM.*;
import MGM.lib.*;

build;

if nargin < 5;    options = [];    end
[epsilon, max_iter, verbose] = GetOptions(options, 'epsilon', 1e-5, 'max_iter', 100, 'verbose', true);

dim = size(X, 2);
group_id = EncodeInt(int32(group_id));
M = double(max(group_id));

% init from GMM
gmm = GMM.Train(X, K);
mus = gmm.means; 
sigmas = gmm.covars; % Fitting GMM for the value of beta in (4.3)
lnpdf = gmm.GetProb(X, true); % N*K 


% has nothing to do with X below
phi = ExpSum1(lnpdf, 2); % normalize exp(lnpdf) so that each rows sums to 1
thetas = Normalize(AccumRows(phi, group_id), 's1', 2);
[chi ys] = Quantize(thetas, T); % chi is set of theta
chi = Normalize(chi', 's1', 2);
pi = accumarray(ys(:), 1, [T, 1]) + 1; % frequency of y index 
pi = pi/sum(pi);% pi size [T,1]
gama = Normalize(repmat(pi, 1, M) + rand(T, M)*0.1, 's1', 2);
mgm = MGM(pi, chi, mus, sigmas, gama, phi);% construct mgm class

tic;
l = nan(1, max_iter); % Make NaN
for iter = 1:max_iter
    [gama, phi] = mgm.InferVar(lnpdf, group_id, ...
        struct('init', 'self', 'max_iter', 2));

    pi = mean(gama, 2);

    chi = Normalize(gama(:, group_id)*phi + 1e-5, 's1', 2)';
    
    for k = 1:K
        [mus(:,k) sigmas(:,:,k)] = MeanCov(X, phi(:, k));
        sigmas(:,:,k) = sigmas(:,:,k) + eye(dim)*1e-5;
        lnpdf(:, k) = mvnpdfex(X, mus(:,k)', sigmas(:,:,k), true);
    end
    
    mgm = MGM(pi, chi, mus, sigmas, gama, phi);

    l(iter) = sum(mgm.LikelihoodVar(lnpdf, group_id)); %  1 x M 
                                 
    if verbose
        fprintf('--Iter = %d, L = %g, TE = %0.2f\n', iter, l(iter)/M, toc);
    end
    if iter > 1 && abs(l(iter) - l(iter - 1)) < epsilon
        break;
    end
    L = l(iter);
end

if verbose
    l_true = mgm.Likelihood([], lnpdf, group_id);
    l_var = mgm.LikelihoodVar(lnpdf, group_id);
    fprintf('Finished. Var likelihood = %g, True likelihood = %g\n', mean(l_var), mean(l_true))
end

