function  plot_vectors( v, rows, cols )
%PLOT_VECTORS Summary of this function goes here
%   Detailed explanation goes here
     % Plot mixed membership vectors
     
     [K, N, T] = size(v);
     [~,cmax] = max(v);%% max index 
     titles    = cell(N,1);
     
     pages     = ceil(N/(rows*cols));
     for p = 1:pages
          figure();
          colormap(jet(6)); 
          for i = 1:rows*cols
               offset    = rows*cols*(p-1) + i;
               if offset > N
                    break;
               end
               subplot(rows,cols,i);
               bar(reshape(v(:,offset,:),[K T])','stack','BarWidth',1,'LineStyle','none');% create ncol stacks
               ylim([0 1]);
               xlim([0.6 T+0.4]);
               title(titles(offset),'FontSize',8);
               set(gca,'FontSize',6,'XTickLabel',reshape(cmax(1,offset,:),[1 T]),'Ytick',[],'LineWidth',0.01);
          end
          %colormap([0 0 1; 0 1 0; 1 0 0; 0 1 1; 1 0 1; 1 1 0]);
     end

end

