function gama = update_gama (hyper_para, var_para)
%UPDATE_GAMA Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Refer to Airoldi-p2010
% phi: N x N x M , alpha : 1 x M 
% gama: M x N
import GLAD.*;
alpha  = hyper_para.alpha;
phiL = var_para.phiL;
phiR = var_para.phiR;
lambda = var_para.lambda;

M = length (alpha);
N = size(phiL, 1);
gama = nan (M, N);


% Paralell on groups
for n = 1:N
    for m = 1:M
     gama(m,n) = alpha(m) +sum(phiL(n,:,m),2) +sum(phiR(:,n,m),1) + sum(lambda{n}(m,:));
    end
end

% Parallel on individual
% for p = 1:N
%     for m = 1:M
%         gama(m,p) = alpha(m) +sum(phiL(p,:,m),2)+sum(phiR(p,:,m),2);
%     end
% end
end
