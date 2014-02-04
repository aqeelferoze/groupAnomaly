function [Rp,Gp,Pi,Theta,iTheta,B,Beta] = MCEMDGLAD(Xp,Y,initTheta,Theta0,initB,initBeta,alpha,Sigma,nC,nM)
%MCEMDGLAD Summary of this function goes here
%   Detailed explanation goes here
import DGLAD_Sample.*;
import lib.*
    
    Theta = initTheta;
    iTheta = Theta0;
    B = initB;
    Beta = initBeta;
    
    nT = size(Xp,2);
    nNum = size(Xp{1},1);
    gNum = size(iTheta,1);
    rNum = size(Beta,1);
    aNum = size(Beta,2);
    
    itN = 3;
    % initialize the latent variables
    
    Pi = mnormalize(gamrnd(alpha,1,[nNum,gNum]),2);
    Gp = cell (1, nT);
    Rp = cell (1 ,nT );
    
    for t = 1:nT
        for n = 1:nNum
            vec = mnrnd (1, Pi(n,:));
            Gp{t}(n,:) = vec ;
            group = find(vec ==1 );
            Rp{t} ( n,: ) = mnrnd (1, Theta{t}(group,:));
        end
    end
    %start MCEM
    for iti = 1:itN
        fprintf('Iteration No: %d \n ',iti);

        %carry out gibbs sampling
        [Gp,Rp,Theta,Pi,Mu] = samplingDGLAD(Xp,Y,Rp,Gp,Pi,Theta,iTheta,B,Beta,alpha,Sigma,nC,nM);
        
        %update parameters
        Beta = zeros(rNum,aNum);
        B = zeros(gNum,gNum);
        for t = 1:nT
            Beta = Beta + Rp{t}'*Xp{t};
            B = (Gp{t}'*Y{t}*Gp{t}) ./ (Gp{t}'*(nC*ones(nNum,nNum))*Gp{t});  
        end
        
        %update init Mu
        iTheta = Mu{1};
        
        %normalize Beta
        for ri = 1:rNum
            Beta(ri,:) = Beta(ri,:) / sum(Beta(ri,:));
            if(isnan(Beta(ri,1)))
                Beta(ri,:) = ones(1,aNum)/aNum;
            end
        end
        %normalize B
        B(isnan(B)) = 0.5;
        
        %visualization results
        %drawResultDGLAD(Xp,Y,Pi,Gp,Rp,Theta,nC);
       
    end
end

