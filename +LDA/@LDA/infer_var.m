function [gama,phi] = infer_var(self, X, group_id, options)
% calculates a document and words posterior for a document d.
% gama  : Dirichlet posterior for a document d K x M
% phi      : (N * K) matrix of word posterior over latent classes
% X      : document data
% alpha : Dirichlet prior of alpha 1 x K
% beta : V x K 
% $Id: vbem.m,v 1.5 2004/11/08 12:42:18 dmochiha Exp $
import LDA.*
import lib.*
alpha = self.alpha; 
beta = self.beta;

[~, K]= size(beta);
N = length(group_id);
M = max(group_id);
phi = mnormalize (ones(N,K), 2); % row add up to 1
gama_old = (repmat(alpha,[M 1])+ repmat(accumarray(group_id,ones(N,1)),[1 K])/K)'; 

[epsilon, max_iter] = GetOptions(options, ...
    'epsilon', 1e-2, 'max_iter', 100);
for j = 1:max_iter
  % update phi
  phi = mnormalize(exp ( vpa(X*logs(beta) + psi(gama_old(:,group_id))' )),2);% very small number
 
  % update gama
  gama = (repmat(alpha,[M 1])+ accumCol(group_id, phi ))';
  % converge?
  if (j > 1) && converged(gama,gama_old,epsilon)
    break;
  end
  gama_old = gama  ;
end

self.phi= phi;
self.gama = gama;
