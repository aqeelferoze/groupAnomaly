function [ theta_hat ] = update_theta_hat( X, hyper_para, var_para)
%UPDATE_THETA Summary of this function goes here
%   Detailed explanation goes here
% theta (K x M X T)
% forward 
K = 3; M = 5; T= 2;
theta_hat= var_para.theta_hat;
fwdmean = zeros(K,M,T);
fwdmean(:,:,1) = 1/K;
fwdvar = zeros(K,K,M,T);
fwdvar(:,:,:,1)= repmat(0.1*eye(K,K),[1,1,M]);

for m = 1:M
    for t = 1:T   
       [fwdmean(:,m,t+1),fwdvar(:,:,m,t+1)]= KF_update(fwdmean (:,m,t),fwdvar(:,:,m,t),theta_hat(:,m,t));  
        
    end
end
         

% backward
bwdmean = zeros(K,M,T+1);
bwdmean(:,:,T+1) = fwdmean(:,:,T+1);
bwdvar = zeros (K,K,M,T+1);
bwdvar(:,:,:,T+1) = bwdvar(:,:,:,T+1);

for m = 1:M
    for t = fliplr(2:T+1)
        [bwdmean(:,m,t-1), ~] = Smooth_update(bwdmean(:,m,t),bwdvar(:,:,m,t),fwdmean(:,m,t-1),fwdvar(:,:,m,t-1)); 
    end   
end

% forward derivative
dfwdmean = zeros(K,M,T+1);
dfwdmean(:,:,1) = 0;
for m = 1:M
    for t = 1:T
  
       [dfwdmean(:,m,t+1),~]= KF_update(dfwdmean (:,m,t),fwdvar(:,:,m,t),delta);  
        
    end
end
      
% backward derivate
dbwdmean = zeros(K,M,T+1);
dbwdmean(:,:,T+1) = dfwdmean(:,:,T+1);
for m = 1:M
    for t = fliplr(2:T+1)
        [dbwdmean(:,m,t-1), ~] = Smooth_update(dbwdmean(:,m,t),bwdvar(:,:,m,t),dfwdmean(:,m,t-1),fwdvar(:,:,m,t-1)); 
    end   
end


para.bwdmean = bwdmean;
para.bwdvar = bwdvar;
para.dbwdmean = dbwdmean;

[opt_theta_hat] = conju_descent( start_point, para);

end

