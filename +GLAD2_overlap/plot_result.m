import GLAD2.*;
%genData;

R = data.R;
G = data.G;
xlimit = [min(X(:,1))-0.5, max(X(:,1))+0.5];
ylimit = [min(X(:,2))-0.5, max(X(:,2))+0.5];
% colormap = varycolor(K);
colormap=[1,0,0;0,0,1;0,1,0];
C = zeros(N,3);

for k = 1:K
     for d = 1:3
     C(R==k,d) = colormap(k,d);
     end

end

for m = 1:M
    X_group = X(G ==m,:);
    C_group = C(G ==m,:);

    subplot(2,M,m);
    scatter(X(G==m,1),X(G==m,2),15,C_group,'filled'); 
    xlim(xlimit );
    ylim(ylimit);
end
%%


for k = 1:K
     for d = 1:3
     C(R_idx==k,d) = colormap(k,d);
     end

end
for m = 1:M
     X_group = X(G_idx ==m,:);
     C_group = C(G_idx ==m,:);

    subplot(2,M,m+M); 
    scatter(X_group(:,1),X_group(:,2),15,C_group,'filled');
     xlim(xlimit );
     ylim(ylimit);  
end
       