

R = data.R;
G = data.G;
xlimit = [min(X(:,1))-0.5, max(X(:,1))+0.5];
ylimit = [min(X(:,2))-0.5, max(X(:,2))+0.5];
% colormap = varycolor(K);
colormap=[1,0,0;0,0,1;0,1,0];




xnum = floor(sqrt(M));
ynum = floor(M/xnum);

for m = 1:M
    
    X_group = X(G ==m,:);
    subplot(xnum,ynum,m);
    if (find(anomaly==m))
        scatter(X(G==m,1),X(G==m,2),20,'r','filled'); 
    else
        scatter(X(G==m,1),X(G==m,2),20,'b','filled'); 
    end
    xlim(xlimit );
    ylim(ylimit);
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    if(m==4)     
        set(gca, 'color', 0.9*[1 1 1])
    end
    set(gca,'linewidth',3);
    pos  = get(gca,'position');  
    rectangle('position',[-13, -13 ,20.26,19.7],'linewidth',3 );
    
end
     
%%

for m = 1:M
     X_group = X(G_idx ==m,:);
    subplot(2*xnum,ynum,m+xnum*ynum); 
    scatter(X_group(:,1),X_group(:,2),15,'b','filled');
     xlim(xlimit );
     ylim(ylimit);  
end