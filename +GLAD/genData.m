function [data, hyper_para_true] = genData (N,M, good_idx, bad_idx)
%GEN : Synthesize data according to GLAD generatibve process
%   Detailed explanation goes here
import GLAD.*;
import lib.*

alpha_val = 0.1;
B = 0.9 * eye(M)+1e-2*ones(M);
% beta = [0,1; 5,5]; % NOTE: for the Gaussian, no need to normalize
beta = [0.4,0.3,0.15,0.1, 0.05; 0.05,0.1,0.15,0.3,0.4;];
good = [0.9,0.1]'; % K = 2
bad = [0.1,0.9]';

K = length(good);
theta = zeros(K,M);
theta(:,good_idx) = repmat(good,[1,length(good_idx)]);
theta(:,bad_idx) = repmat(bad,[1,length(bad_idx)]);

lambda = 10;

[data, hyper_para_true] = generateData(N, alpha_val, B, theta, beta, lambda);



% pi = zeros(N,M);
% G = zeros(N,1);
% R = zeros(N,1);
% X = zeros(N,V);
% Y = zeros(N,N);
% 
% for p = 1:N
%     pi(p,:)= dirrnd  (alpha);
%     G(p) = find(mnrnd(1,pi(p,:))==1); % M X 1
%     R(p) = find(mnrnd (1,theta(:,G(p))')==1);
%     X(p,:) = mnrnd(nM, beta(R(p),:));
%     X(p,:) = mvnrnd(beta(R(p),:),sigma*eye(V), 1);
% end
% 
% 
% for p = 1:N
%     for q = 1:N
%        Y(p,q) = binornd(nC, B(G(p),G(q)));
%         if(p==q)
%             Y(p,q)=1;
%         end      
%     end
% end

% data.X = X;
% data.Y = Y;
% data.G = G;
% data.R = R;
% data.pi = pi;
% data.theta = theta;
% data.K = size(theta,2);
% data.M = size(theta,1);
% 
% hyper_para.alpha=alpha;
% hyper_para.B = B;
% hyper_para.beta = beta;
% hyper_para.theta = theta; % K * M
% hyper_para.nC = nC;
% 



fprintf('data generated ! \n');




    

    



