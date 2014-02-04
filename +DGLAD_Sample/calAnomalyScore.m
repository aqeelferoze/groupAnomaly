function [GCA,PA] = calAnomalyScore(Xp,Rp,Mu,Theta,Beta,Sigma)
%CALANOMALYSCORE Summary of this function goes here
%   Detailed explanation goes here
    nT = size(Xp,2);
    gNum = size(Mu{1},1);
    nNum = size(Xp{1},1);
    rNum = size(Beta,1);
    
    GCA = zeros(nT,gNum);
    PA = zeros(nT,nNum);
    
    for t = 1:nT
        for n = 1:nNum
            rn = find(Rp{t}(n,:)==1);
            PA(t,n) = log(mnpdf(Xp{t}(n,:),Beta(rn,:)));
        end
        if(t>1)
            for gi=1:gNum
               GCA(t,gi) = mvnpdf(Theta{t}(gi,:),Theta{t-1}(gi,:),2*eye(rNum)); 
            end
        end
        %normalization
    end
     maxV = max(max(GCA(2:nT,:)));
     minV = min(min(GCA(2:nT,:)));
     GCA = (GCA-minV)/(maxV-minV);
     GCA(1,:) = 1;
     
     maxV = max(max(PA));
     minV = min(min(PA));
     PA = (PA-minV)/(maxV-minV);
end

