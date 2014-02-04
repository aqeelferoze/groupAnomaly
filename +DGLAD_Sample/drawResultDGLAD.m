function drawResultDGLAD(Xp,Y,Pi,Gp,Rp,Theta,nC)
%DRAWRESULT Summary of this function goes here
%   Detailed explanation goes here
    
    nNum = size(Xp{1},1);
    gNum = size(Gp{1},2);
    nT = size(Xp,2);
    
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
    np = 1;
    
    for t = 1:nT
        
        %visualize adjacent matrix
        gn = zeros(1,nNum);
        for n = 1:nNum
            gn(n) = find(Gp{t}(n,:)==1);
        end
        [~,I] = sort(gn);

        newY = zeros(nNum,nNum);
        for n1= 1:nNum
            for n2= 1:nNum
                newY(n1,n2) = Y{t}(I(n1),I(n2));
            end
        end
        newY = nC - newY;
        minX = min(min(newY));
        maxX = max(max(newY));
        newY = (newY-minX)/(maxX-minX);
        subplot(nT,3,np),imshow(newY,'InitialMagnification','fit');
        np = np + 1;
        
        %visualize individual activities    
        newCordinate = zeros(nNum,2);
        newColor = zeros(nNum,3);

        for n= 1:nNum
            tempF = Xp{t}(n,:)/sum(Xp{t}(n,:));
            newCordinate(n,1) = -sqrt(2)/2*tempF(2)+sqrt(2)/2*tempF(1);
            newCordinate(n,2) = tempF(3)*sqrt(6)/2;
            rn = find(Rp{t}(n,:)==1);
            newColor(n,:) = defaultColors(rn,:);
        end

        subplot(nT,3,np),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),30,newColor,'filled');
        np = np + 1;
        
        %visulize group mixture
        newCordinate = zeros(gNum,2);
        newColor = zeros(gNum,3);

        for n= 1:gNum
            %tTheta = Gp{t}(:,:)'*Rp{t}(:,:);
            %tempF = tTheta(n,:)/sum(tTheta(n,:));
            tempF = Theta{t}(n,:);
            newCordinate(n,1) = -sqrt(2)/2*tempF(2)+sqrt(2)/2*tempF(1);
            newCordinate(n,2) = tempF(3)*sqrt(6)/2;
            newColor(n,:) = defaultColors(n,:);
        end
        subplot(nT,3,np),hold on,plot([-sqrt(2)/2,sqrt(2)/2],[0,0],'LineWidth',3), hold on, plot([-sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3),hold on,plot([sqrt(2)/2,0],[0,sqrt(6)/2],'LineWidth',3), hold on, scatter(newCordinate(:,1),newCordinate(:,2),30,newColor,'filled');
        np = np + 1;
    end
end

