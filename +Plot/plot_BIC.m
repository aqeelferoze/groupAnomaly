load('../result/bicScore_MGM.mat');
Ts = [1,2,3,4,5];
Ks = [2,3,4,5,6];
ColorSet = varycolor(5);
set(gca, 'ColorOrder', ColorSet);

hold all;


plot(Ks, bicScore);
legend T=1 T=2 T=3 T=4 T=5 Location NorthEast

xlabel('K'); ylabel('BIC score');