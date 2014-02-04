function [ phiL_new, phiR_new] = update_phi(Y,  hyper_para, var_para, nC)
%UPDATE_PHI Summary of this function goes here: variational EM update for gama
%   Detailed explanation goes here: Refer to Airoldi-p2009



import MMSB.*;
import lib.*
B = hyper_para.B;
phiL = var_para.phiL;
phiR = var_para.phiR;
gama = var_para.gama;

[M, N] = size(gama);
phiL_new = zeros(N,N,M);
phiR_new = zeros(N,N,M);
%Parallel in N people


for p = 1:N
    f1(:,p) = log_pi(gama(:,p));
end
 for p = 1: N
    for q = 1: N

            f = Y(p,q)* log(B)+(nC-Y(p,q))*log(1-B); 

            phiL_new(p,q,:) = f1(:,p) + f *reshape(phiR(q,p,:),[M,1]);
            phiR_new(q,p,:) = f1(:,q) + f'*reshape(phiL(p,q,:),[M,1]);
    end
 end
phiL_new = mnormalize(exp(phiL_new),3);
phiR_new = mnormalize (exp(phiR_new),3);

%--- change f from Y*log(B) to Y*B...
% change phiR_new(p,q) to phiR_new(q,p)
% ---
% Parallel in N individual

% for m = 1:M
%     logpiL = repmat((psi(gama(m,:))-psi(sum(gama)))',[1,N]);
%     logpiR = repmat(psi(gama(m,:))-psi(sum(gama)),[N,1]);
%     fL = repmat(Y,[1,1,M]).* repmat(permute(log(B(m,:)),[1,3,2]),[N,N]) +...
%         repmat(1-Y,[1,1,M]).* repmat(permute(log(1-B(m,:)),[1,3,2]),[N,N]);
%     fR = repmat(Y,[1,1,M]).* repmat(permute(log(B(:,m)),[3,2,1]),[N,N]) +...
%         repmat(1-Y,[1,1,M]).* repmat(permute(log(1-B(:,m)),[3,2,1]),[N,N]);
%     phiL_new(:,:,m) = exp(logpiL+sum(phiR.*fL,3));
%     phiR_new(:,:,m) = exp(logpiL+sum(phiL.*fR,3));% Use the same logpiL
% end
% 
% phiL_new = mnormalize(phiL_new,3);
% phiR_new = mnormalize(phiR_new,3);


%  Two layer variational 
% Max = 100;
% phi_new= phi;
% pq_old = permute(phi(q,p,:),[3,2,1]);
% qp_old = permute(phi(p,q,:),[3,2,1]);
% f= Y(p,q)* log(B) +(1-Y(p,q)) *(1-log(B));
% 
% for iter = 1:Max
%     logpi_p = psi(gama(:,p))-repmat(psi(sum(gama(:,p))), [M,1]);
%     zf_p = f * qp_old;
%     phi_pq = mnormalize(exp(logpi_p+zf_p));
% 
% 
%     logpi_q = psi(gama(:,q))-repmat(psi(sum(gama(:,q))), [M,1]);
%     zf_q =  f * pq_old;
%     phi_qp= mnormalize(exp(logpi_q+zf_q));
% 
%     if converge(phi_pq,pq_old)&& converge(phi_qp,qp_old)
%         break
%     end
%     pq_old = phi_pq;
%     qp_old = phi_qp;
% end
% phi_new(p,q,:) = phi_pq;
% phi_new(q,p,:) = phi_qp;
% !! Normalize should be done in the last step !! 

 % might need to do code optimization for matrix operation
end


