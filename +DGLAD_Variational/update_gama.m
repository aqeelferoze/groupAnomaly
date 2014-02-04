function gama = update_gama (hyper_para, var_para)
%UPDATE_GAMA Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Refer to Airoldi-p2010
% phi: N x N x M , alpha : 1 x M 

alpha  = hyper_para.alpha;

lambda = var_para.lambda;

N = size(lambda,2);



% Paralell on groups

gama = repmat(alpha',[1,N])+ lambda;


% Parallel on individual
% for p = 1:N
%     for m = 1:M
%         gama(m,p) = alpha(m) +sum(phiL(p,:,m),2)+sum(phiR(p,:,m),2);
%     end
% end
end
