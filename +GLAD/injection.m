function data = injection(N,M )
import lib.*


% good = mnormalize([1,0;0,0;0,1]+1e-1); %M = 3;K = 3;
% bad = mnormalize ([1;1;1]);
good = [0.9,0.1;0.2,0.8;0.1,0.9]'; % K = 2
bad = [0.5,0.5;0.4,0.6]';

good_idx = mod(unidrnd(1:1:M),3)+1;

theta = good(:,good_idx);
theta(:,1:2) = bad;
% theta = good(:,Y);
% theta(:,1) = bad;
% beta  = mnormalize([1,1,0;1,0,0; 1,0,2]+1e-1); %V = 2, K = 3;

beta = [0.9,0.1;0.2,0.8]';

alpha = 0.1 * ones(1,M);
Count = 100;
for p = 1:N
    pi(:,p)= dirrnd  (alpha );
    z(p)= find(mnrnd(1,pi(:,p)')==1);
end

B = rand(M,M);

for p = 1:N
    for q = 1:N
       Y(p,q) = binornd(1, B(z(p),z(q)) );
    end
end

for p = 1:N
    G(p) = find(mnrnd(1,pi(:,p)')==1);
    R(p) = find(mnrnd (1,theta(:,G(p))')==1);
    X(p,:) = mnrnd(Count, beta(:,R(p))');
end
data.X = X;
data.Y = Y;
data.alpha=alpha;
data.B = B;
data.beta = beta;
data.theta = theta;
data.G = G;
data.R = R;

fprintf('*******Done with Anomaly Injection ******* \n');
end

