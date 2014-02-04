function [Gp,Rp,Theta,Pi,Mu] = samplingDGLAD(Xp,Y,initRp,initGp,initPi,initTheta,iTheta,B,Beta,alpha,Sigma,nC,nM)
%SAMPLING Summary of this function goes here
%   Detailed explanation goes here

import DGLAD_Sample.*;
    itN = 30;% burn in time 
    
    nT = size(Xp,2);
    nNum = size(Xp{1},1);
    gNum = size(B,1);
    rNum = size(iTheta,2);
    aNum = size(Beta,2);
    
    cNum = zeros(nC+1,1);
    for i =1:nC+1
        cNum(i) = log(nchoosek(nC,i-1));
    end
    

    
    %init sample
    Pi = initPi;
    Rp = initRp;
    Gp = initGp;
    Theta = initTheta;
    

    fprintf('sampling No:');
    for iti = 1: itN
        fprintf('%d ',iti);
        for t = 1:nT
            %update Rp(t,n,:)
%             X = Xp{t};
%             valid_idx = find(sum(X,2)~=0);
%             zero_idx = setdiff([1:nNum],valid_idx);
%             if isempty(valid_idx)
%                 continue
%             end
            for n = 1:nNum
                tProb = zeros(1,rNum);
                gn = find(Gp{t}(n,:)==1);
                for ri = 1:rNum
                    tProb(ri) = Theta{t}(gn,ri)*(mnpdf(Xp{t}(n,:),Beta(ri,:)));
                end              
                tProb = tProb/sum(tProb);           
                Rp{t}(n,:) = mnrnd(1,tProb);
                if(isnan(Rp{t}(n,1)))
                    Rp{t}(n,:) = mnrnd(1,ones(1,rNum)/rNum);
                end
            end
        end
    
        for t = 1:nT
            %update Gp
            for n=1:nNum
                tProb = zeros(1,gNum);
                rn =  find(Rp{t}(n,:)==1);
                if(isempty(rn)==1)
                    disp('error');
                end
                for gi = 1:gNum
                    tProb(gi) = log(Pi(n,gi))+log(Theta{t}(gi,rn));
                    for n2 = 1:nNum
                        gn = find(Gp{t}(n2,:)==1);
                        if(isempty(gn)==1)
                             disp('error');
                        end
                        %Bernoulli
                        %tProb(gi) = tProb(gi) + Y(n,n2)*log(B(gi,gn))+(1-Y(n,n2))*log(1-B(gi,gn));
                        %Binomial
                        tProb(gi) = tProb(gi) + cNum(Y{t}(n,n2)+1) + Y{t}(n,n2)*log(B(gi,gn))+(nC-Y{t}(n,n2))*log(1-B(gi,gn));
                    end
                end
                tProb = exp(tProb - getLogSum(tProb));
                Gp{t}(n,:) = mnrnd(1,tProb/sum(tProb));
                 if(isnan(Gp{t}(n,1)))
                    Gp{t}(n,:) = mnrnd(1,ones(1,gNum)/gNum);
                end
            end
        end
        
        for n=1:nNum
            temp = zeros(1,gNum);
            for t=1:nT
                temp = Gp{t}(n,:);
            end
            Pi(n,:) = gamrnd(alpha+temp,1,[1,gNum]);
            Pi(n,:) = Pi(n,:)/sum(Pi(n,:));
        end  
        
        [Theta, Mu] = sampleTheta(Gp,Rp,Sigma,iTheta);
    end
    fprintf(' Finished\n');
end

