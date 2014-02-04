function [lda, L] = Train(X, group_id , K, options)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here
import LDA.*
import lib.*
if nargin < 4;    options = [];    end % argument check, no options

[epsilon, max_iter, verbose] = GetOptions(options, 'epsilon', 1e-5, 'max_iter', 100, 'verbose', true);

[N V] = size(X);
M = double(max(group_id));



% Initialize
alpha  = ones(1,K)*0.1;
beta = mnormalize(rand([V,K]),1);
gama = zeros(K,M);
phi = zeros(N,K);

lda = LDA(alpha, beta);% construct lda class


% Iteration 
tic;
loop = zeros(1, max_iter);
for iter = 1:max_iter
    [gama, phi] = lda.infer_var(X, group_id, ...
        struct('init', 'self', 'max_iter', 50));

    alpha = newton_alpha(gama');
    beta = mnormalize(X'*phi,1); %  calculate beta
    %fprintf('--beta = %d',alpha);
    % reconstruct 
    lda = LDA(alpha, beta,gama, phi);
    loop(iter) = sum(lda.like_var(X,group_id));
    
    if verbose % print 
        fprintf('--Iter = %d, L = %d, TE = %0.2f\n', iter, loop(iter)/M, toc);
    end
    if (loop(iter)/M == -inf)
        break;
    end
    if iter > 1 && abs(loop(iter) - loop(iter - 1)) < epsilon % converge
        break;
    end
end
L = loop(iter);
% plot (1:iter, loop(1:iter));
% title('Likelihood - Iteration', 'fontsize', 10);



