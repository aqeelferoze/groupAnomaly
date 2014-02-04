function [Xp,Yp,Pi,Gp,Rp,Theta] = generateDataDGLAD(nNum,nT,alpha,B,initTheta,Beta,sigma,nC,nM)
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here
    
    gNum = size(B,1);
    rNum = size(initTheta,2);
    aNum = size(Beta,2);
    
    Theta = cell(1,nT);
    Xp = cell(1,nT);
    Yp = cell(1,nT);
    Gp = cell(1,nT);
    Rp = cell(1,nT);
    
    %generate all thetas
    Theta{1} = zeros(gNum,rNum);
    tempTheta = initTheta;
    for gi=1:gNum
        tempTheta(gi,:) = mvnrnd(tempTheta(gi,:),sigma^2*eye(rNum));
        temp =  exp(tempTheta(gi,:));
        Theta{1}(gi,:) = temp / sum(temp);
    end
    for t=2:nT
        Theta{t} = zeros(gNum,rNum);
        for gi=1:gNum
            tempTheta(gi,:) = mvnrnd(tempTheta(gi,:),sigma^2*eye(rNum));
            temp =  exp(tempTheta(gi,:));
            Theta{t}(gi,:) = temp / sum(temp);
        end
    end
    
    %generate Pi for all individuals
    Pi = gamrnd(alpha,1,[nNum,gNum]);
    for n=1:nNum
        Pi(n,:) = Pi(n,:)/sum(Pi(n,:));
    end
    
    %generate other variable and observations for each time slice
    for t = 1:nT
        Gp{t} = zeros(nNum,gNum);
        Yp{t} = zeros(nNum,nNum);
        Rp{t} = zeros(nNum,rNum);
        Xp{t} = zeros(nNum,aNum);
        %geneerate group membership
        for n=1:nNum
            Gp{t}(n,:) = mnrnd(1,Pi(n,:));
        end

        %generate communication
        for n1=1:nNum
            for n2=n1+1:nNum
                prob = Gp{t}(n1,:)*B*Gp{t}(n2,:)';
            %Bernoulli
                %Y(n1,n2) = (rand()< prob);
                %Y(n2,n1) = Y(n1,n2);
            %Binimial
                 Yp{t}(n1,n2) = binornd(nC,prob);
                 Yp{t}(n2,n1) = Yp{t}(n1,n2);
            end
        end

        %generate role distribution
        for n=1:nNum
            gn = find(Gp{t}(n,:)==1);
            Rp{t}(n,:) = mnrnd(1,Theta{t}(gn,:));
        end
        
        %generate activities
        for n=1:nNum
            rn = find(Rp{t}(n,:)==1);
            Xp{t}(n,:) = mnrnd(nM,Beta(rn,:));
        end
    end
end

