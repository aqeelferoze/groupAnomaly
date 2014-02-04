function [Pi,Gp,Rp] = sampling(Xp,Y,B,Theta,Beta,alpha,nC,nM)
%SAMPLING Summary of this function goes here
%   Detailed explanation goes here
    
    %precalculate combination number
    cNum = zeros(nC+1,1);
    for i =1:nC+1
        cNum(i) = log(nchoosek(nC,i-1));
    end
    
    itN = 100;
    
    nNum = size(Xp,1);
    gNum = size(B,1);
    rNum = size(Theta,2);
    aNum = size(Beta,2);
    
    Pi = rand(nNum,gNum);
    Gp = rand(nNum,gNum);
    Rp = rand(nNum,rNum);
    
    %init sample
    for n=1:nNum
        Pi(n,:) = Pi(n,:)/sum(Pi(n,:));
        Gp(n,:) = mnrnd(1,Gp(n,:)/sum(Gp(n,:)));
        Rp(n,:) = mnrnd(1,Rp(n,:)/sum(Rp(n,:)));
    end
    
    
    LL = zeros(1,itN);
    fprintf('sampling No:');
    for iti = 1:itN
        fprintf('%d ',iti);
        
        
        %Update Rp
        for n=1:nNum
            tProb = zeros(1,rNum);
            gn = find(Gp(n,:)==1);
            for ri = 1:rNum
                tProb(ri) = Theta(gn,ri)*(mnpdf(Xp(n,:),Beta(ri,:)));
            end
            tProb = tProb/sum(tProb);
            Rp(n,:) = mnrnd(1,tProb);
            if(isnan(Rp(n,1)))
                Rp(n,:) = mnrnd(1,ones(1,rNum)/rNum);
            end
        end
        
        %update Gp
        for n=1:nNum
            tProb = zeros(1,gNum);
            rn =  find(Rp(n,:)==1);
            if(isempty(rn)==1)
                disp('error');
            end
            for gi = 1:gNum
                tProb(gi) = log(Pi(n,gi))+log(Theta(gi,rn));
                for n2 = 1:nNum
                    gn = find(Gp(n2,:)==1);
                    if(isempty(gn)==1)
                         disp('error');
                    end
                    %Bernoulli
                    %tProb(gi) = tProb(gi) + Y(n,n2)*log(B(gi,gn))+(1-Y(n,n2))*log(1-B(gi,gn));
                    %Binomial
                    tProb(gi) = tProb(gi) + cNum(Y(n,n2)+1) + Y(n,n2)*log(B(gi,gn))+(nC-Y(n,n2))*log(1-B(gi,gn));
                end
            end
            tProb = exp(tProb - getLogSum(tProb));
            Gp(n,:) = mnrnd(1,tProb/sum(tProb));
             if(isnan(Gp(n,1)))
                Gp(n,:) = mnrnd(1,ones(1,gNum)/gNum);
            end
        end
        
        
        %Update Pi
        for n=1:nNum
            Pi(n,:) = gamrnd(alpha+Gp(n,:),1,[1,gNum]);
            Pi(n,:) = Pi(n,:)/sum(Pi(n,:));
        end
        
        

        
  %      LL(iti) = calLL(Xp,Y,Pi,Gp,Rp,B,Theta,Beta,alpha,nC,nM);
    end
%    plot(1:itN,LL);
%    drawResultGLAD(Xp,Y,Pi,Gp,Rp);
    fprintf(' Finished\n');
end

