function [B,Theta,Beta,Gp,Rp,Pi] = MCEMGLAD(Xp,Y,iB,iTheta,iBeta,nC,nM,itN)
%MCEM Summary of this function goes here
%   Detailed explanation goes here
import GLAD_Sample.*;    
    nNum = size(Xp,1);
    gNum = size(iB,1);
    rNum = size(iTheta,2);
    aNum = size(iBeta,2);
    
    B = iB;
    Theta = iTheta;
    Beta = iBeta;
    
    alpha = 0.1;
    

    
    for iti = 1:itN
        
        [Pi,Gp,Rp] = samplingGLAD(Xp,Y,B,Theta,Beta,alpha,nC,nM);
        
        %updtae parameter Theta
        Theta = Gp'*Rp;
        for gi=1:gNum
            Theta(gi,:) = Theta(gi,:) / sum(Theta(gi,:));
            if(isnan(Theta(gi,1)))
                Theta(gi,:) = ones(1,rNum)/rNum;
            end
        end
        
        %update Beta
        Beta = Rp'*Xp;
        for ri = 1:rNum
            Beta(ri,:) = Beta(ri,:) / sum(Beta(ri,:));
            if(isnan(Beta(ri,1)))
                Beta(ri,:) = ones(1,aNum)/aNum;
            end
        end
        
        %update B
        B = (Gp'*Y*Gp) ./ (Gp'*(nC*ones(nNum,nNum))*Gp); 
        B(isnan(B)) = 0.5;
%        LL = calMLL(Xp,Y,B,Theta,,Beta,alpha);
%        fprintf('iteration No:%d MLL=%.4f\n',iti,LL);
    end
end

