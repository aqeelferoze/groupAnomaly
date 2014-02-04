function drawAnomalyDGLAD(GCA,PA,Xp,Rp,Theta)
%DRAWANOMALYDGLAD Summary of this function goes here
%   Detailed explanation goes here
    nNum = size(PA,2);
    gNum = size(GCA,2);
    nT = size(Xp,2);
    
    cRed = [1,0,0];
    cBlue = [0,0,1];
    
    np = 1;
    for t = 1:nT
        %visualize individual activities    
        newCordinate = zeros(nNum,2);
        newColor = zeros(nNum,3);
        newSize = zeros(nNum,1);
        
        for n= 1:nNum
            tempF = Xp{t}(n,:)/sum(Xp{t}(n,:));
            newCordinate(n,1) = -sqrt(2)/2*tempF(2)+sqrt(2)/2*tempF(1);
            newCordinate(n,2) = tempF(3)*sqrt(6)/2;
            newColor(n,:) = PA(t,n)*cBlue + (1-PA(t,n))*cRed;
            newSize(n,:) = 20 + 80 * (1-PA(t,n));
        end

        subplot(nT,2,np),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),newSize,newColor,'filled');
        np = np + 1;
        
        %visulize group mixture
        newCordinate = zeros(gNum,2);
        newColor = zeros(gNum,3);
        newSize = zeros(gNum,1);
        
        for n= 1:gNum
            tempF = Theta{t}(n,:);
            newCordinate(n,1) = -sqrt(2)/2*tempF(2)+sqrt(2)/2*tempF(1);
            newCordinate(n,2) = tempF(3)*sqrt(6)/2;
            newColor(n,:) = GCA(t,n) * cBlue + (1-GCA(t,n))*cRed;
            newSize(n,:) = 20 + 80 * (1-GCA(t,n));
        end
        subplot(nT,2,np),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),newSize,newColor,'filled');
        np = np + 1;
    end
end

