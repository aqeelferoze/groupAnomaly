clear all;

import DGLAD_XR.*;

%parameters
alpha = 0.3 ;
nNum = 100;
gNum = 3;
rNum = 3;
aNum = 3;
nC = 10; % Binomial for communication
nM = 100; % Multinomila for activity
nT = 5; % total time


B = 0.1*ones(gNum,gNum) + 0.8*eye(gNum,gNum);
gRole = [1,3,1
         3,1,1
         1,1,3];
initTheta = zeros(gNum,rNum);
for gi=1:gNum
    initTheta(gi,:) = gRole(mod(gi,3)+1,:);
end
%initTheta(gNum,:) = [3,3,3];
Sigma = 0.3;% Guassian Variance for Theta
Beta = [0.8,0.1,0.1
        0.1,0.8,0.1
        0.1,0.1,0.8];
    
%generate data (Normal)
[Xp,Yp,Pi,Gp,Rp,Theta] = generateDataDGLAD(nNum,nT,alpha,B,initTheta,Beta,Sigma,nC,nM);


%% DGLAD
[rRp,rGp,rPi,rTheta,riTheta,rB,rBeta,rMu] = MCEMDGLAD(Xp,Yp,Rp,Gp,Pi,Theta,initTheta,B,Beta,alpha,Sigma,nC,nM);
save(strcat('./Synthetic/Result_0516','/sampling_result.mat'));

%% GLAD
M = 3;
K = 3;
for t = 1: nT 
    X = Xp{t};
    Y = Yp{t};
    
    fixed_para.M = M;
    fixed_para.K = K;
    fixed_para.nC = nC;
    fixed_para.nM = nM;
    
    hyper_para_init.alpha = alpha* ones(1,M);
    hyper_para_init.B = B;
    hyper_para_init.beta = Beta;
    hyper_para_init.theta = Theta {t}';% Only Dynamic Part, Transpose from Xinran
    
    [hyper_para_glad{t},var_para_glad{t}] = GLAD.glad(X,Y, fixed_para);
end

%% MMSB 
import MGM.*;
import MMSB.*;
M = 3;
K = 3;
T = 3; % MGM parameter
options = struct('n_try', 3, 'para', false, 'verbose', true, ...
'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);

  hyper_para_init.alpha = alpha* ones(1,M);
  hyper_para_init.B = diag(ones(1,M)*0.5)+10e-3;
for t = 1: nT 
    Y = Yp{t}; 
    fixed_para.M = M;
    fixed_para.nC = nC; 
  
    [hyper_para_mmsb{t},var_para_mmsb{t}] = MMSB.mmsb (Y,  fixed_para,hyper_para_init);
    [~,G_idx_mmsb] = max(var_para_mmsb{t}.gama);
   % [mgm{t} Like_mgm{t}]= MGM.Train1(X, G_idx_mmsb', T, K, options);
end
%% MGM

for t = 1:nT
    X = Xp{t};
     [~,G_idx_mmsb] = max(var_para_mmsb{t}.gama);
    [mgm{t} Like_mgm{t}]= MGM.Train1(X, G_idx_mmsb', T, K, options);
end

%% Visualization 
import Plot.*;
figure
% Plot the ternary axis system

% Plot the data
% First jetset the colormap (can't be done afterwards)

color = [1;2;3];
hold on;
for t  = 1:nT
%     mu = var_para_glad{t}.mu;
%     [~,G_idx]= max(Gp{t}');
    % GLAD 
    theta = hyper_para_glad{t}.theta;   
    subplot(3,nT,t);
    [h,hg,htick]=terplot;
    plot_simplex(theta,color,'o');
       
    % DGLAD_XR
    theta = rTheta{t}';
    subplot(3,nT,t+nT);
    [h,hg,htick]=terplot;
    plot_simplex(theta,color,'o');
    
    % GRound Truth
    theta = Theta{t}';   
    subplot(3,nT,t+nT*2);
    [h,hg,htick]=terplot;
    plot_simplex(theta,color,'o');
       
end


