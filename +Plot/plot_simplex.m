function plot_simplex( A, d , symbol)
%PLOT_SIMPLEX : Modificaiton of package: ternary2/ternaryc.m
%   Plot a three dimension vector on a ternary diagram: A[3 X N];
% d (optional): color-coded in a ternary plot. The optional parameter SYMBOL
% determines the symbol used in the scatter plot.
% The first three vectors define the position of a data value within the
% ternary diagram, and the fourth vector will be plotted as a coloured
% symbol according to its magnitude. The marker symbol can be optionally
% defined by the marker parameter. If then, note that the marker symbol
% must be enclosed in single quotes (e.g., 'o'). If no symbol is specified
% a dot will be used.

c1 = A(1,:)';
c2 = A(2,:)';
c3 = A(3,:)';


if max(c1+c2+c3)>1
    c1=c1./(c1+c2+c3);
    c2=c2./(c1+c2+c3);
    c3=c3./(c1+c2+c3);
end
if nargin == 1
    % Constant data, no color specified, set marker
    marker = 1;
else
    marker = 0;
    miv=min(d);
    mav=max(d);
    % If no marker specified use the default one
    if nargin==2
        symbol='.';
    end
    % Get the current colormap
%     map=colormap;
    % Create colormap with labels
    map = varycolor(max(d));
end
% Plot the points
hold on
for i=1:length(c1)    
    x=0.5-c1(i)*cos(pi/3)+c2(i)/2;
    y=0.866-c1(i)*sin(pi/3)-c2(i)*cot(pi/6)/2;
    if marker == 1
        hd(i)=plot(x,y,'db','markerfacecolor','b');
    else % marker color specified
 
        hd(i)=plot(x,y,symbol,'color',map(d(i),:),'markerfacecolor',map(d(i),:));
    end
end
hold off
axis image
% % Re-format the colorbar
% 
% if marker == 0
%     hcb=colorbar;
%     
%     %set(hcb,'ylim',[1 length(map)]);
%     yal=linspace(0,1,10);
%     set(hcb,'ytick',yal);
%     % Create the yticklabels
%     ytl=linspace(miv,mav,10);
%     s=char(10,4);
%     for i=1:10
%         if abs(min(log10(abs(ytl)))) <= 3
%             B=sprintf('%-4.3f',ytl(i));
%         else
%             B=sprintf('%-4.2E',ytl(i));
%         end
%         s(i,1:length(B))=B;
%     end
%     set(hcb,'yticklabel',s,'fontsize',9,'ycolor','k','xcolor','k');
% end
%grid on
%set(get(h,'title'),'string',string,'fontweight','bold')


   
end

