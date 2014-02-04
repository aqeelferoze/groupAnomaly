function [Theta,Mu] = sampleTheta(Gp,Rp,sigma,initTheta)
%SAMPLETHETA Summary of this function goes here
%   Detailed explanation goes here
    
    sN = 1000;
    nT = size(Gp,2);
    gNum = size(initTheta,1);
    rNum = size(initTheta,2);
    
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
        
        for si = 1:sN
            temp = exp(samples{gi}(si,:));
            temp = temp / sum(temp);
            weights(gi,si) = mnpdf(Ot{1}(gi,:),temp);
        end
        weights(gi,:) = weights(gi,:) / sum(weights(gi,:)); 
        
        tSum = zeros(1,rNum);
        tMu = zeros(1,rNum);
        for si = 1:sN
            temp = exp(samples{gi}(si,:));
            temp = temp / sum(temp);
            tSum = tSum + weights(gi,si)*temp;
            tMu = tMu + weights(gi,si) * samples{gi}(si,:);% mean Theta?
        end
        Mu{1}(gi,:) = tMu;
        Theta{1}(gi,:) = tSum;
    end
    
    for t = 2:nT
        Theta{t} = zeros(gNum,rNum);
        Mu{t} = zeros(gNum,rNum);
        for gi=1:gNum    
            samples{gi} = mvnrnd(samples{gi},sigma*eye(rNum),sN);    

            for si = 1:sN
                temp = exp(samples{gi}(si,:));
                temp = temp / sum(temp);
                weights(gi,si) = mnpdf(Ot{t}(gi,:),temp);
            end
            weights(gi,:) = weights(gi,:) / sum(weights(gi,:)); 

            tSum = zeros(1,rNum);
            tMu = zeros(1,rNum);
            for si = 1:sN
                temp = exp(samples{gi}(si,:));
                temp = temp / sum(temp);
                tSum = tSum + weights(gi,si)*temp;
                tMu = tMu + weights(gi,si) * samples{gi}(si,:);
            end
            Mu{t}(gi,:) = tMu;
            Theta{t}(gi,:) = tSum;
        end
    end
end

