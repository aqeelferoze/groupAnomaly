[U Gamma] = PCA(X,2);
M = 5;


ColorSet = varycolor(M);
set(gca, 'ColorOrder', ColorSet);
hold all
for m = 1:M
    scatter (U((role==m),1),U((role==m),2),'filled');
end

