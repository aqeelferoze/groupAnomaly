
load('/Users/RoseYu/Dropbox/PythonProject/workspace/networkExtracter/acm/acm_links_all.mat')
load('/Users/RoseYu/Dropbox/PythonProject/workspace/networkExtracter/acm/acm_bows_all.mat')
import DGLAD_XR.*;
import lib.*;

[N V T] = size (bowmat);
Xp = cell(1,T);
Yp = cell(1,T);

for t = 1:T
    Yp{t} = sparse (adjmat(:,:,t));
    Xp{t} = sparse (bowmat(:,:,t));
end

%parameters


N = 100;
M= 20;
K = 5;


alpha = 0.3 ;

Theta0 = mnormalize(rand(M,K),2);

B = 0.1*ones(M,M) + 0.8*eye(M,M);
Theta = cell (1,T); 
for t = 1:T
    Theta{t} =mnormalize(rand(M,K),2);
end
Sigma = 0.3;% Guassian Variance for Theta
Beta = rand (K, V );
Beta = mnormalize(Beta, 2);
nC = 1; % Binomial for communication
nM = 100; % Multinomila for activity



%% DGLAD
[rRp,rGp,rPi,rTheta,riTheta,rB,rBeta,rMu] = MCEMDGLAD(Xp,Yp,Theta,Theta0,B,Beta,alpha,Sigma,nC,nM);

%% Analyze Result
GroupID = zeros(N,T);
for t = 1:T
    for n = 1:N
    GroupID(n,t) = find(rGp{t}(n,:) ==1);
    RoleID(n,t) = find (rRp{t}(n,:) ==1);
    end
end
    

[Beta_sorted, order ]  = sort ( rBeta, 2,'descend');
%%
save(strcat('./ACM','/DGLAD_100.mat'));

