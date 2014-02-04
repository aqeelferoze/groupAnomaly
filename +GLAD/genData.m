function [data] = genData( N,M,K,V, Count)
%GEN : Synthesize data according to GLAD generatibve process
%   Detailed explanation goes here
import GLAD.*;
import lib.*
alpha = 0.1 * ones(1,M);
alpha(M) = 0.9;

% 
% X = ones(N,V);

% for n = 1:N
%     if (mod(n,2)==0)
%         X(n,1:V/2)= 10;
%     else
%         X(n,V/2+1:V)=10;
%     end
% end
%         
% for m = 1:M
%     from = N/M*(m-1)+1;
%     to = N/M*m;
%     Y(from:to, from:to ) = 1;
% end
% B = diag(ones(M,1)*0.9,0)+10e-3;

% B = 0.5*ones(M);
% 
% beta = zeros(V,K)+10e-3;
% beta(1:V/2,1) = 1;
% beta(V/2+1:V,2) = 1;
% beta = mnormalize(beta);
% 
% 
% theta = zeros(K,M);
% for i = 1:3
% theta(:,i)= [0.9;0.1];
% end
% for i = 4:5
% theta(:,i)= [0.1;0.9];
% end


%B = rand(M,M);
B = diag(rand(M,1));
B = B+10e-4; % B cannot have zero
beta = mnormalize(ones(V,K));
theta = mnormalize(rand(K,M));
% 
Y = zeros(N,N);
pi = zeros(M,N);
for p = 1:N
    pi(:,p)= dirrnd  (alpha );
    z(p)= find(mnrnd(1,pi(:,p)')==1);
end
% 
for p = 1:N
    for q = 1:N
       Y(p,q) = binornd(1, B(z(p),z(q)) );
    end
end

G = zeros(1,N);
R = zeros(1,N);

for p = 1:N

    G(p) = find(mnrnd(1,pi(:,p)')==1);
    R(p) = find(mnrnd (1,theta(:,G(p))')==1);
    X(p,:) = mnrnd(Count, beta(:,R(p))');
end

X(X==0)=1;
data.X = X;
data.Y = Y;
data.alpha=alpha;
data.B = B;
data.beta = beta;
data.theta = theta;
data.G = G;
data.R = R;
data.pi = pi;

fprintf('data generated ! \n');




    

    



