function LL = calLLGLAD(Xp,Y,Pi,Gp,Rp,B,Theta,Beta,alpha,nC,nM)
%CALLL Summary of this function goes here
%   Detailed explanation goes here
import GLAD_Sample.*
    nNum = size(Xp,1);
    gNum = size(B,1);
    rNum = size(Theta,2);
    aNum = size(Beta,2);
    
    LL = 0;
    for n=1:nNum
        %dirichlet part
        LL = LL + logs(dirpdf(Pi(n,:),alpha*ones(1,gNum)));
        
        gn = find(Gp(n,:)==1);
        rn = find(Rp(n,:)==1);
        
        %multinomal
        LL = LL + log(Pi(n,gn)) + log(Theta(gn,rn));
        
        %observation
        LL = LL + log(mnpdf(Xp(n,:),Beta(rn,:)));
    end
    
    %adjacent matrix
    for n1=1:nNum
        gn1 = find(Gp(n1,:)==1);
        for n2 = 1:nNum
            gn2 = find(Gp(n2,:)==1);
            if(Y(n1,n2)==1)
                LL = LL + log(B(gn1,gn2));
            else
                LL = LL + log(1-B(gn1,gn2));
            end
        end
    end
end

