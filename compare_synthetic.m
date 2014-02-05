clear;
% T < M, V < N

N = 100;
M = 3;
K = 2;
V = 2;
T= 2;% mgm parameter]

% for M = 8:2:10
%     for  K = 2:2:10
%             for T = 2:2:M-2
%%
time = clock;
foldername= sprintf('%d_%d_%d_%d', time(2),time(3),time(4),time(5));
mkdir('Synthetic',foldername)
path = strcat(pwd,'/Synthetic/',foldername,'/');
% filename = strcat(path,'para.txt');
% fileID = fopen(filename,'w+');
% fprintf(fileID, 'N = %d, M=%d,K=%d,V=%d,T=%d', N,M,K,V,T);
%% Gen data
count = 500;
data  = GLAD.genData (N,M,K,V,count);
%% anomaly injection
clear;

N = 500;
M = 10;
K = 2;
data = GLAD.injection(N, M);
 
%% GLAD
% hyper_para.alpha = data.alpha;
% hyper_para.B = data.B;
% hyper_para.theta = data.theta;
% hyper_para.beta = data.beta;
import GLAD.*;

[hyper_para_glad,var_para_glad] = GLAD.glad(data.X, data.Y,M,K);
[~, G_idx_glad] = max(var_para_glad.gama);
[~, R_idx_glad] = max(var_para_glad. mu);
[score_glad ]= GLAD.score_var(data.X,data.Y, hyper_para_glad, var_para_glad);

fprintf('*******Done with GLAD******* \n');
%% MMSB
import MMSB.*;
[hyper_para_mmsb,var_para_mmsb] = MMSB.mmsb(data.Y,M);
[~, G_idx_mmsb] = max(var_para_mmsb.gama);

fprintf('*******Done with MMSB******* \n');

%% Graph- spectum
% 
% import graphcut.*
% [G_idx_graph,Pi,cost]= grPartition(data.Y,M);
% G_idx_graph = G_idx_graph';
% 
% fprintf('*******Done with Graph******* \n');

%% Connected Components
[S, G_idx_conn] = graphconncomp(sparse(data.Y));
fprintf('*******Done with Graph******* \n');


%% MGM-MMSB

import MGM.*;
options = struct('n_try', 3, 'para', false, 'verbose', true, ...
    'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);

[mgm Like_mgm]= MGM.Train1(data.X, G_idx_mmsb', T, K, options);
[~,R_idx_mgm]= max(mgm.phi,[],2);
R_idx_mgm = R_idx_mgm';
[score_mgm] = mgm.ScoreVar(data.X, G_idx_mmsb');

fprintf('*******Done with MMSB-MGM******* \n');
%% LDA-MMSB
import LDA.*;
options = struct('n_try', 3, 'para', false, 'verbose', true, ...
    'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);
[lda Like_lda]= LDA.Train(data.X, G_idx_mmsb', K, options);
%[lda Like_lda]= LDA.Train(data.X, data.G', K, options);
[~,R_idx_lda]= max(lda.phi,[],2);
R_idx_lda = R_idx_lda';
[score_lda]= lda.score_var(G_idx_mmsb');

fprintf('*******Done with MMSB-LDA******* \n');
%% MGM-Graph
import MGM.*;
options = struct('n_try', 3, 'para', false, 'verbose', true, ...
    'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);

[mgm_g Like_mgm_g]= MGM.Train1(data.X, G_idx_graph', T, K, options);
[~,R_idx_mgmgraph]= max(mgm_g.phi,[],2);
R_idx_mgmgraph = R_idx_mgmgraph';
%[score_mgmgraph] = mgm_g.ScoreVar(data.X, G_idx_graph');

fprintf('*******Done with Graph-MGM******* \n');
%% LDA-Graph
import LDA.*;
[lda_g Like_lda_g]= LDA.Train(data.X, G_idx_graph', K, options);
[~,R_idx_ldagraph]= max(lda_g.phi,[],2);
R_idx_ldagraph = R_idx_ldagraph';
%[score_ldagraph]= lda.score_var(G_idx_graph);

fprintf('*******Done with Graph-LDA******* \n');
%% plot role partition in each group
% import Plot.*;
% subplot (1,6,1), plot_RinG(G_idx_glad ,R_idx_glad, M,K);
% title('GLAD'); xlabel('groups'); ylabel('role partition');
% subplot (1,6,2), plot_RinG(G_idx_mmsb, R_idx_mgm, M,K);
% title('MMSB-MGM'); xlabel('groups'); ylabel('role partition');
% subplot (1,6,3), plot_RinG(G_idx_mmsb, R_idx_lda, M,K);
% title('MMSB-LDA'); xlabel('groups'); ylabel('role partition');
% subplot (1,6,4), plot_RinG(G_idx_graph, R_idx_mgmgraph, M,K);
% title('Graph-MGM'); xlabel('groups'); ylabel('role partition');
% subplot (1,6,5), plot_RinG(G_idx_graph, R_idx_ldagraph, M,K);
% title('Graph-LDA'); xlabel('groups'); ylabel('role partition');
% subplot (1,6,6), plot_RinG(data.G', data.R', M,K);
% title('ground truth'); xlabel('groups'); ylabel('role partition');

%% plot mixed membership vectors
import Plot.*;
h = figure;
subplot(1,4,1), plot_E(data.Y,data.G);title('Ground Truth');
subplot(1,4,2), plot_E(data.Y,G_idx_glad);  title('GLAD');
subplot(1,4,3), plot_E(data.Y,G_idx_mmsb); title('MMSB');
%subplot(1,4,4), plot_E( data.Y,G_idx_graph); title('Graph');
subplot(1,4,4), plot_E( data.Y,G_idx_conn); title('Graph');
filename = strcat(path,'block_R');
hgsave(h,filename); 
fprintf('*******Done with Block Plot ******* \n');

%% Entropy of each group
% import Cal.*;
% entro_glad = cal_entropy(G_idx_glad, R_idx_glad);
% entro_lda  = cal_entropy(G_idx_mmsb, R_idx_lda);
% entro_mgm  = cal_entropy(G_idx_mmsb, R_idx_mgm);
% entro_ldagraph = cal_entropy(G_idx_mmsb, R_idx_ldagraph);
% entro_mgmgraph = cal_entropy(G_idx_mmsb, R_idx_mgmgraph);
% boxplot([entro_glad,entro_lda, entro_mgm,entro_ldagraph,entro_mgmgraph],'labels',{'GLAD','MMSB-LDA','MGMM-MGM','Graph-LDA','Graph-MGM'});
% ylabel('Entropy');

%% calculate role distribution in each group
% import Cal.*;
% portion_glad = cal_proportion(G_idx_glad,R_idx_glad, M ,K );
% portion_mgm = cal_proportion(G_idx_mmsb,R_idx_mgm, M ,K  );
% portion_lda = cal_proportion(G_idx_mmsb,R_idx_lda, M ,K  );
% portion_mgmgraph = cal_proportion(G_idx_graph,R_idx_mgm, M ,K  );
% portion_ldagraph = cal_proportion(G_idx_graph,R_idx_lda, M ,K  );

%% calculate entropy
import Cal.*;
entropy_glad = cal_entropy(G_idx_glad,R_idx_glad,M,K );
entropy_mgm = cal_entropy(G_idx_mmsb,R_idx_mgm ,M,K);
entropy_lda = cal_entropy(G_idx_mmsb,R_idx_lda ,M,K);
entropy_mgmgraph = cal_entropy(G_idx_graph,R_idx_mgm ,M,K);
entropy_ldagraph = cal_entropy(G_idx_graph,R_idx_lda ,M,K);
entropy_truth = cal_entropy(data.G,data.R,M,K);

%% plot entropy 
h = figure;
ColorSet = varycolor(7);
entropy = [entropy_glad, entropy_mgm, entropy_lda, entropy_mgmgraph, entropy_ldagraph, entropy_truth];
labels = {'GLAD','MMSB-MGM','MMSB-LDA','Graph-MGM','Graph-LDA','truth'};

plot(entropy);
legend(gca, labels);

filename = strcat(path,'entropy');
hgsave(h,filename); 
fprintf('*******Done with Entropy Plot ******* \n');

%%
 
save(strcat(path,'/workspace.mat'));
 
%             end
%       end
% end
