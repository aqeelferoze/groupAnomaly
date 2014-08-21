function gama = update_gama (hyper_para, var_para)
%UPDATE_GAMA Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Refer to Airoldi-p2010
% phi: N x N x M , alpha : 1 x M 
import MMSB.*;
alpha  = hyper_para.alpha;
phiL = var_para.phiL;
phiR = var_para.phiR;


M = length(alpha);
N = size(phiL, 1);
gama = nan(M, N);

% Paralell on groups
for m = 1:M
    gama(m,:) = repmat(alpha(m),[1,N])+sum(phiL(:,:,m),2)'+sum(phiR(:,:,m),1);
end

% Parallel on individual
% for p = 1:N
%     for m = 1:M
%         gama(m,p) = alpha(m) +sum(phiL(p,:,m),2)+sum(phiR(p,:,m),2);
%     end
% end
end
