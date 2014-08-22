%% ADAMS
import lib.*
data.X = load('./Data/data_adams/activity.txt');
data.X = lib.rescale(data.X,1,20);
data.Y= load('./Data/data_adams/E.txt');
data.Y = double (data.Y>0);
truth =  load('./Data/data_adams/truth.txt');
%%






% ADAMS - find anomalies
fid = fopen('~/Downloads/Dataset/data_senator/names.csv');
name = textscan(fid, '%s%s','Delimiter',',');
import Cal.*;
[ prec_glad, recall_glad] = cal_prec_recall( truth, G_idx_glad, score_glad);
[ prec_mgm, recall_mgm] = cal_prec_recall( truth,G_idx_mmsb, score_mgm);
[ prec_lda, recall_lda] = cal_prec_recall(truth, G_idx_mmsb, score_lda);
[ prec_mgmgraph, recall_mgmgraph] = cal_prec_recall(truth, G_idx_graph, score_mgmgraph);
[ prec_ldagraph, recall_ldagraph] = cal_prec_recall(truth, G_idx_graph, score_ldagraph);
% recall and precision
import Plot.*;
prec = [prec_glad',prec_mgm', prec_lda',prec_mgmgraph', prec_ldagraph',];
labels = {'GLAD','MMSB-MGM','MMSB-LDA','Graph-MGM','Graph-LDA'};
recall = [recall_glad',  recall_mgm',recall_lda',recall_mgmgraph', recall_ldagraph'];
F1 = 2*prec.*recall./(prec+recall+1.0e-4);
plot_Box(F1,'F1 Score');
plot_Box(prec,labels,'Prec');
plot_Box(recall,labels,'Recall');