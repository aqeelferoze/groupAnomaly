function drawResult(data, var_para, hyper_para)
%DRAWRESULT Summary of this function goes here
%   Detailed explanation goes here
    nC = 1;
    
    % aggregate Xp, Gp, Rp
    nNum = length(var_para.mu);
    aNum = size(var_para.mu{1},1);
    gNum = size(var_para.lambda{1},1);
    rNum = size(var_para.mu{1},1);
    
    Y = data.Y;
    
    Xp = zeros(nNum, aNum);
    for n=1:nNum
        temp = data.X{n};
        for a = 1:size(temp,2)
            Xp(n, temp(a)) = Xp(n, temp(a)) + 1;
        end
    end
    
    Rp = zeros(nNum, rNum);
    for n=1:nNum
        temp = var_para.mu{n};
        Rp(n,:) = sum(temp,2)';
    end
    
    Gp = zeros(nNum, gNum);
    for n=1:nNum
        temp = var_para.lambda{n};
        Gp(n,:) = sum(temp,2)';
    end
    
    %visualize adjacent matrix
    gn = zeros(1,nNum);
    for n = 1:nNum
        [~,gn(n)] = max(var_para.gama(:,n));
    end
    [~,I] = sort(gn);
    
    newY = zeros(nNum,nNum);
    for n1= 1:nNum
        for n2= 1:nNum
            newY(n1,n2) = Y(I(n1),I(n2));
        end
    end
    newY = nC - newY;
    minX = min(min(newY));
    maxX = max(max(newY));
    newY = (newY-minX)/(maxX-minX);
    subplot(2,2,1),imshow(newY,'InitialMagnification','fit');
        
    %visualize individual activities    
    newCordinate = zeros(nNum,2);
    newColor = zeros(nNum,3);
    
    defaultColors = [1,1,0
                     1,0,0
                     0,1,0
                     0,0,1
                     1,0,1
                     0,0,1
                     0.5,1,1
                     1,0.5,1
                     1,1,0.5
                     0,0,0];
    
    for n= 1:nNum
        tempF = Xp(n,:)/sum(Xp(n,:));
        newCordinate(n,1) = -sqrt(2)/2*tempF(2)+sqrt(2)/2*tempF(1);
        newCordinate(n,2) = tempF(3)*sqrt(6)/2;
        [~, rn] = max(Rp(n,:));
        newColor(n,:) = defaultColors(rn,:);
    end
    
    subplot(2,2,2),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),30,newColor,'filled');
    
    %visulize group mixture
    newCordinate = zeros(gNum,2);
    newColor = zeros(gNum,3);
    
    for n= 1:gNum
        tempF = hyper_para.theta(:,n);
        newCordinate(n,1) = -sqrt(2)/2*tempF(2)+sqrt(2)/2*tempF(1);
        newCordinate(n,2) = tempF(3)*sqrt(6)/2;
        newColor(n,:) = defaultColors(n,:);
    end
    subplot(2,2,3),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),30,newColor,'filled');
    
    %visualize individual group
    newCordinate = zeros(nNum,2);
    newColor = zeros(nNum,3);
    for n= 1:nNum
        tempF = Gp(n,:)/sum(Gp(n,:));
        newCordinate(n,1) = -sqrt(2)/2*tempF(2)+sqrt(2)/2*tempF(1);
        newCordinate(n,2) = tempF(3)*sqrt(6)/2;
        [~ , gn] = max(var_para.gama(:,n));
        newColor(n,:) = defaultColors(gn,:);
    end
    
    subplot(2,2,4),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),30,newColor,'filled');
end

