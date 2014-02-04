function plot_Box (rate, name)


% pct=[recall_LDA', recall_MGMM', recall_LDA_graph' ,recall_MGMM_graph']
% labels = {'LDA-MMSB','MGMM-MMSB','LDA-graph','MGMM-graph'};
boxplot(rate);
set(gca,'XTickLabel',{''})
set(gca,'FontSize',30);
ylabel(name);



% pct=[prec_LDA', prec_MGMM', prec_LDA_graph' ,prec_MGMM_graph']
% labels = {'LDA-MMSB','MGMM-MMSB','LDA-graph','MGMM-graph'};


% set(findobj(gca,'Type','text'),'FontSize',30);
end