function [Theta,Mu] = sampleTheta(Gp,Rp,sigma,initTheta)
%SAMPLETHETA Summary of this function goes here
%   Detailed explanation goes here
    
    sN = 500;
    nT = size(Gp,2);
    [gNum, rNum] = size(initTheta);
    
    Theta = cell(1,nT);
    Mu = cell(1,nT);
    
    samples = cell(gNum,1);
    weights = zeros(gNum,sN);

    
    Ot = cell(1,nT);
    for t= 1:nT
        Ot{t} = Gp{t}'*Rp{t};% O(i,j): # of role j in group i 
    end
    
    
   %inital lization
    Theta{1} = zeros(gNum,rNum);
    Mu{1} = zeros(gNum,rNum);
    for gi =1 :gNum
        samples{gi} = mvnrnd(initTheta(gi,:),sigma*eye(rNum),sN);
        
        theta_hat = zeros(sN,rNum);
        for si = 1:sN
            temp = exp(samples{gi}(si,:));
            temp = temp / sum(temp); % soft thresholding
            weights(gi,si) = mnpdf(Ot{1}(gi,:),temp);%empirical probability as weight
            theta_hat(si,:) = temp;      
        end
        weights(gi,:) = weights(gi,:) / sum(weights(gi,:)); 
        Theta{1}(gi,:) = weights(gi,:)*theta_hat;
        Mu{t}(gi,:) = weights(gi,:) * samples{gi};

    end
    
    for t = 2:nT
        Theta{t} = zeros(gNum,rNum);
        Mu{t} = zeros(gNum,rNum);
        for gi=1:gNum    
            samples{gi} = mvnrnd(samples{gi},sigma*eye(rNum),sN);    
            
            theta_hat = zeros(sN,rNum);
            for si = 1:sN
                temp = exp(samples{gi}(si,:));
                temp = temp / sum(temp);
                weights(gi,si) = mnpdf(Ot{t}(gi,:),temp);
                theta_hat (si,:)= temp;
            end
            weights(gi,:) = weights(gi,:) / sum(weights(gi,:)); 
            Theta{t}(gi,:) = weights(gi,:)* theta_hat;
            Mu{t}(gi,:) = weights(gi,:) * samples{gi};
        end
    end
end

