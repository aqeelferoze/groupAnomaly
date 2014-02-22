N = 50;
M = 5;
bad_idx = 4;
good_idx = setdiff([1:5],bad_idx);

[data, hyper_para]  = GLAD2.genData( N,M , good_idx, bad_idx);


%% MMSB
import MMSB.*; 
hyper_para.B = rand(M,M);

[hyper_para_mmsb,var_para_mmsb] = MMSB.mmsb(data.Y,hyper_para);
[~, G_idx_mmsb] = max(var_para_mmsb.gama);
% G_idx_mmsb = lib.align_index (G_idx_mmsb,data.G);

fprintf('*******Done with MMSB ******* \n');



%% Graph
% import graphcut.* ;
% [G_idx_graph,Pi,cost]= grPartition(data.Y,M);
% G_idx_graph = lib.align_index (G_idx_graph,data.G);
% 
% fprintf('*******Done with Graph******* \n');
[S, G_idx_conn] = graphconncomp(sparse(data.Y));
fprintf('*******Done with Graph******* \n');

%% GLAD
import GLAD2.*; 
hyper_para.M=10;
var_para_glad = GLAD2.train(data,hyper_para);
[~,G_idx_glad]= max(var_para_glad.lambda);
G_idx_glad = lib.align_index (G_idx_glad,data.G);

fprintf('*******Done with GLAD******* \n');


import Plot.*;
h = figure;
% plot_E(data.Y,G_idx_conn); title('Graph');
% subplot(1,4,1), 
% plot_E(data.Y,data.G');title('Ground Truth');
% subplot(1,4,2),
plot_E(data.Y,G_idx_glad);  title('GLAD');
% subplot(1,4,3), plot_E(data.Y,G_idx_mmsb); title('MMSB');
% subplot(1,4,4), plot_E( data.Y,G_idx_conn); title('Graph');

fprintf('*******Done with Block Plot ******* \n');