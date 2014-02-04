%function [data] = genData( N,M,K,V, Count)
%GEN : Synthesize data according to DGLAD generatibve process
%   Detailed explanation goes here
clear;
N = 500;
M = 20; 

T= 5;
Type = 2;% group type 
K = 3; % role type
V = 2;
nM = 50;
import DGLAD_Variational.*;
import lib.*


alpha = 0.1 * ones(1,M);
B = diag(ones(M,1)*0.9,0)+10e-3;
beta = mnormalize([2,8; 3,3; 8,2],2);
base = mnormalize([10,1,2;1,5,5],2);
theta = zeros(M,K,T);
type = randi([1 Type], M,1);
theta(:,:,1) = base(type,:);
sigma = 0.01;
bad_base = mnormalize ([3,5,10],2);
bad_idx = [4,6,10];
theta(bad_idx,:,1) = kron(bad_base,ones(length(bad_idx),1));

pi = zeros(N,M);
for p = 1:N
    pi(p,:)= dirrnd  (alpha);
    
end

G = zeros(N,T);
for t = 1:T
    for p = 1:N   
        G(p,t) = find(mnrnd(1,pi(p,:))==1); % M X 1
    end
end

Y = zeros(N,N,T);
for t = 1:T
    for p = 1:N
        for q = 1:N
            if(p==q)
                Y(p,q,t)=1;
            end
           Y(p,q,t) = binornd(1, B(G(p,t),G(q,t)));
        end
    end
end

for t = 2:T
    % update theta according with time
    theta(:,:,t) = softmax(mvnrnd (theta(:,:,t-1), sigma*eye(K)));
end

R = zeros(N,T);
X = zeros(N,V,T);
for t = 1:T
    theta_t = theta(:,:,t);
    for p = 1:N
        R(p,t) = find(mnrnd (1,softmax(theta_t(G(p,t),:)))==1);
%         X(p,:,t) = mvnrnd(beta(R(p,t),:),sigma*eye(V), 1); % change to Gaussian
         X(p,:,t)= mnrnd(nM,beta(R(p,t),:)');
    end
end



data.X = X;
data.Y = Y;
data.alpha=alpha;
data.B = B;
data.beta = beta;
data.theta = theta; % K x M X T
data.G = G;
data.R = R;
data.pi = pi;


% 
% fprintf('data generated ! \n');
% 
% for m = 1:M
%     subplot(2,2,m);scatter(X(G==m,1),X(G==m,2));
% end

for m = 1:M
    for t = 1:T
    idx = (m-1)*M + t;
    subplot(M,T,idx);scatter(X(G==m,1,t),X(G==m,2,t));
    end
end



    

    



