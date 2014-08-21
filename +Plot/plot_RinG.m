function hist_data = plot_RinG (G_idx,R_idx, M ,K)
import lib.*
ColorSet = varycolor(M);
colormap(cool)
%bar(rand(10,5),'stacked');
hist_data = zeros(M,K);
for m = 1:M
    hist_data(m,:)= histc(R_idx(G_idx==m),1:K)';

end
     bar(hist_data, 'stacked');
     axis off;
end