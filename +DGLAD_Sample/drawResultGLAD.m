function drawResultGLAD(Xp,Y,Pi,Gp,Rp)
%DRAWRESULT Summary of this function goes here
%   Detailed explanation goes here
    nC = 10;

    %visualize adjacent matrix
    nNum = size(Xp,1);
    gNum = size(Gp,2);
    
    gn = zeros(1,nNum);
    for n = 1:nNum
        gn(n) = find(Gp(n,:)==1);
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
        rn = find(Rp(n,:)==1);
        newColor(n,:) = defaultColors(rn,:);
    end
    
    subplot(2,2,2),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),30,newColor,'filled');
    
    %visulize group mixture
    newCordinate = zeros(gNum,2);
    newColor = zeros(gNum,3);
    
    for n= 1:gNum
        Theta = Gp'*Rp;
        tempF = Theta(n,:)/sum(Theta(n,:));
        newCordinate(n,1) = -sqrt(2)/2*tempF(2)+sqrt(2)/2*tempF(1);
        newCordinate(n,2) = tempF(3)*sqrt(6)/2;
        newColor(n,:) = defaultColors(n,:);
    end
    subplot(2,2,3),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),30,newColor,'filled');
    
    %visualize individual group
    newCordinate = zeros(nNum,2);
    newColor = zeros(nNum,3);
    for n= 1:nNum
        tempF = Pi(n,:)/sum(Pi(n,:));
        newCordinate(n,1) = -sqrt(2)/2*tempF(2)+sqrt(2)/2*tempF(1);
        newCordinate(n,2) = tempF(3)*sqrt(6)/2;
        gn = find(Gp(n,:)==1);
        newColor(n,:) = defaultColors(gn,:);
    end
    
    subplot(2,2,4),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),30,newColor,'filled');
end

