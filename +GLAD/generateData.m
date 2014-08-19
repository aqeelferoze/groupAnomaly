function [data, hyper_para] = generateData(nNum, alpha_val, B, Theta, Beta, lambda)
% Input paramters:
% nNum: number of individuals
% alpha: same alpha used for \alpha = ones(1,gNum) * alpha
% Theta: rNum * gNum
% Beta: rNum * aNum
% lambda: poisson parameter for total number of activities for one individual % How to access the generated data
% X_{pa,d} = Xp{p}{a}(d)
% R_{pa,r} = Rp{p}{a}(r)
% G_{pa,g} = Gp{p}{a}{g}
% Y_{pg} = Y(p,q)
% Zl_{pq,g} = Zl{p,q}(g)
% Zr_{pq,g} = Zr{p,q}(g)
    
    gNum = size(B,1);
    rNum = size(Theta,1);
    aNum = size(Beta,2);
    
    % generate Pi for all individuals
    Pi = gamrnd(alpha_val,1,[nNum,gNum]);
    for n=1:nNum
        Pi(n,:) = Pi(n,:)/sum(Pi(n,:));
    end

    Zl=zeros(nNum, nNum);
    Zr=zeros(nNum, nNum);
    Y=zeros(nNum, nNum);
    
    % MMSB part
    for p=1:nNum
        for q=1:nNum
            Zl(p,q) = find(mnrnd(1,Pi(p,:))==1);
            Zr(p,q) = find(mnrnd(1,Pi(q,:))==1);
            Y(p,q) = binornd(1, B(Zl(p,q), Zr(p,q)));
        end
    end
    
    Gp = cell(1,nNum);
    Rp = cell(1,nNum);
    Xp = cell(1,nNum);
    
    % LDA part
    for n=1:nNum
        % generate total number of activities
        tA = poissrnd(lambda);
        Xp{n}= zeros(1,tA);
        Gp{n} = zeros(1,tA);
        Rp{n} = zeros(1,tA);
        for a=1:tA
            temp = mnrnd(1,Pi(n,:));
            Gp{n}(a) = find(temp==1);
            
            temp = mnrnd(1,Theta(:,Gp{n}(a))');
            Rp{n}(a) = find(temp==1);
            
            temp = mnrnd(1,Beta(Rp{n}(a),:));
            Xp{n}(a) = find(temp==1);
        end
    end
    
   
    
data.X = Xp;
data.Y = Y;
data.G = Gp;
data.R = Rp;
data.pi = Pi;
data.theta = Theta;
data.K = size(Theta,1);
data.M = size(Theta,2);

hyper_para.alpha=alpha_val*ones(1,gNum);
hyper_para.B = B;
hyper_para.beta = Beta;
hyper_para.theta = Theta;
end

