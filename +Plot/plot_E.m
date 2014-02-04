% cdMMSB
%
% Visualizes an interaction network E, optionally grouped according
% to some labeling L (defined as a function from actor indices
% to labels).
%
% Returns E grouped according to L.

function perm_E = plot_E(E,L)
     E = double(~E);
     N              = size(E,1);
     if nargin < 2
          L = ones(1,N);
     end
     NUM_LABELS     = max(L);
     
     E_reorder      = [];
     block_starts   = 1;
     for i = 1:NUM_LABELS
          thisclass_idx  = find(L==i);
          E_reorder      = [E_reorder thisclass_idx];
          block_starts   = [block_starts block_starts(i)+length(thisclass_idx)];
     end
     perm_E = E(E_reorder,E_reorder);
     
     for i = 1:NUM_LABELS
          % Assign diagonal block interactions to a unique integer
          block_range = block_starts(i):block_starts(i+1)-1;
          perm_E(block_range,block_range) = perm_E(block_range,block_range) .* 3;
     end
     newplot;
     %ColorSet = varycolor(NUM_LABELS);
     % cmap = ColorSet;
  
     cmap = colormap('LINES');
     cmap(1,:) = [0 0 0];% black
     cmap(2,:) = [1 1 1];% white
  

     blue = [137, 207, 240]/256;
     cmap(3,:) = blue;
     colormap(cmap);
     image(perm_E+1);
     %ColorSet = varycolor(NUM_LABELS);

     
     axis off;
     %title('Reordered interaction network E');
end