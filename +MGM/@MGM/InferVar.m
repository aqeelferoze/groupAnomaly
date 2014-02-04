% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [gama, phi] = InferVar(self, lnpdf, group_id, options)
%[gama, phi] = InferVar(self, lnpdf, group_id, options)
% variational inference of MGM
import MGM.*;
import MGM.lib.*;
if nargin < 4;    options = [];     end
[init, epsilon, max_iter, verbose] = GetOptions(options, ...
    'init', [], 'epsilon', 1e-5, 'max_iter', 100, 'verbose', false);

pi = self.pi;
chi = self.chi;
T = size(chi, 2);
M = double(max(group_id));
logsafe = eps(0.0);

if isempty(init)
    phi = ExpSum1(lnpdf, 2);
    gama = Normalize(repmat(pi, 1, M) + rand(T, M)*0.1, 's1', 1);
elseif iscell(init)
    [gama, phi] = cell2vars(init);
elseif strcmp(init, 'self')
    gama = self.gama;
    phi = self.phi;
else
    error('wrong init');
end

for iter = 1:max_iter
    phi_old = phi;
    
    % update phi
    gama_logchi = log(chi + logsafe)*gama; % K x M
    phi = gama_logchi(:, group_id)' + lnpdf;
    phi = ExpSum1(phi, 2);
    
    % update gama
    phi_logchiT = phi*log(chi + logsafe);
    gama = AccumRows(phi_logchiT, group_id, [M, T])';
    gama = bsxfun(@plus, gama, log(pi + eps(0.0)));
    gama = ExpSum1(gama, 1);

    if verbose
        % likelihood value
        self.phi = phi;
        self.gama = gama;
        l = sum(self.LikelihoodVar(lnpdf, group_id));
        %fprintf('--Iter = %d, L = %g\n', iter, l/M);
    end
    
    if norm(phi_old - phi, 'fro') < epsilon
        break;
    end
end
