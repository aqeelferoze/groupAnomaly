function [data, hyper_para] = genData (N,M,K,V, nM,nC)
%GEN : Synthesize data according to GLAD generatibve process
%   Detailed explanation goes here

import GLAD2.*;
import lib.*

% N = 100;
% M = 10;
% K = 3;
% V = 2;
% Count = 2;
alpha = 0.1 * ones(1,M);
% B = diag(ones(M,1)*0.8,0)+10e-3;
B = rand(M);
% B = 0.5 * ones(M,M);
% beta = [0,1; 5,5]; % NOTE: for the Gaussian, no need to normalize
beta = mnormalize([0,1; 5,5],2); 
base = mnormalize([5,5;1,10],2);
T = 2;
type = randi([1 T], M,1);
theta = base(type,:);
sigma = 0.3;
bad_base = mnormalize ([10,1],2);
bad_idx = [4];
theta(bad_idx,:) = kron(bad_base,ones(length(bad_idx),1));







pi = zeros(N,M);
G = zeros(N,1);
R = zeros(N,1);
X = zeros(N,V);
Y = zeros(N,N);

for p = 1:N
    pi(p,:)= dirrnd  (alpha);
    G(p) = find(mnrnd(1,pi(p,:))==1); % M X 1
    R(p) = find(mnrnd (1,theta(G(p),:))==1);
    X(p,:) = mnrnd(nM, beta(R(p),:));
%     X(p,:) = mvnrnd(beta(R(p),:),sigma*eye(V), 1);
end


for p = 1:N
    for q = 1:N
       Y(p,q) = binornd(nC, B(G(p),G(q)));
        if(p==q)
            Y(p,q)=1;
        end      
    end
end




X(X==0)=1;
data.X = X;
data.Y = Y;
data.G = G;
data.R = R;
data.pi = pi;
data.theta = theta;
data.K = size(theta,2);
data.M = size(theta,1);
hyper_para.alpha=alpha;
hyper_para.B = B;
hyper_para.beta = beta;
hyper_para.theta = theta'; % K x M
hyper_para.nC = nC;




fprintf('data generated ! \n');




    

    



