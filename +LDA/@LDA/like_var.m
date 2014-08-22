function like = like_var(self, X, group_id)
%LIK_VAR Summary of this function goes here
%   Detailed explanation goes here
import lib.*
alpha = self.alpha; % K x 1
beta = self.beta; % V x K
phi = self.phi; % N x K
gama = self.gama; % K x M 

[K M] = size(gama);

% beta V x K

l_point = sum(phi.*(psi(gama(:,group_id))-repmat(psi(sum(gama(:,group_id))),[K 1]))',2) ...% N x 1
          + sum(phi.* (X* logs(beta)),2)...
          - sum(phi.* logs(phi),2);
    % Group Likelihood has nothing to do with group size N_m
    % bug below in gamma(), over become infinite
l_group = repmat(gammaln(sum(alpha))-sum(gammaln(alpha)),[1 M])...
          +sum(repmat((alpha-1)',[1 M]).*(psi(gama)-repmat(psi(sum(gama)),[K,1])))...
          - gammaln(sum(gama))+sum(gammaln(gama))...
          -sum((gama-1).*(psi(gama)-repmat(psi(sum(gama)),[K,1])));
l_group(~isfinite(l_group))=0;
  % throw away -inf
% for m = 1:M
%     if (l_group(m)== -inf)
%         l_group(m)=0;
%     end
% end
      
      
like = l_group + accumarray(group_id, l_point)'; % 1 x M 
end
