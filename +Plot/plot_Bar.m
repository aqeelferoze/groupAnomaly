N = 100;
p = ones(6,1);
p(3) = 0.7;
blue = N* p(1);
red = N* p(2);
cmap = [1,0,0;0,0,1];
colornum = 100;
vals = linspace(0, 1, colornum);
colorSet = zeros(colornum, 3);
colorSet(:,1) = fliplr(vals);

%colormap(cmap);
%bar(p,'stack');

for i= 2:N
rectangle('position',[1,i,1,1],'faceColor',colorSet(i,:),'EdgeColor','none')
end

% for i=blue+1:N
% rectangle('position',[1,i,1,1],'faceColor',colorSet_red(i,:),'EdgeColor','none')
% end

% colorSet2 = b2r(-6,3,N);
% for i=2:N
% rectangle('position',[3,i,1,1],'faceColor',colorSet2(i,:))
% end