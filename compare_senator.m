%% Parameter
N =100;
M = 2;
K = 4;
%% Senator
import GLAD.*;
import lib.*;

load ('./Data/data_senator/senator.mat');
load('./Data/data_senator/names.mat');

X_org= load('./Data/data_senator/attributes.csv');
[N,V] = size(X_org);
X = cell(1,N);
for n = 1:N
    Ap = sum(X_org(n,:));
    X_n = [];
    for v = 1:V
        X_n = [X_n, ones(1,X_org(n,v)) * v ];
    end
    X{n} =  X_n;
end
data.X = X;


% time = clock;
% foldername= sprintf('%d_%d_%d_%d', time(2),time(3),time(4),time(5));
% mkdir('Senator',foldername)
% path = strcat(pwd,'/Senator/',foldername,'/');
%%
imax = 100;
hyper_para_init.alpha = 0.1 * ones(1,M);
hyper_para_init.B = 0.1.*eye(M)+0.3.*ones(M,M);
hyper_para_init.beta = mnormalize(randi(imax, [K,V]), 2);
hyper_para_init.theta = mnormalize( randi(imax, [K,M]), 1);

for i = 1:8
    
data.Y = E(:,:,i);
[hyper_para_glad,var_para_glad] = GLAD.glad(data,hyper_para_init);
% [~, G_idx_glad(i,:)] = max(var_para_glad.lambda);
% [~, R_idx_glad(i,:)] = max(var_para_glad. mu);

% get group, role index by aggregating activities
G_idx_infer = infer_assignment(var_para_glad.lambda);
R_idx_infer =  infer_assignment(var_para_glad.mu);
G_idx_glad = lib.aggregate_assignment(G_idx_infer,M);
R_idx_glad = lib.aggregate_assignment(R_idx_infer,K);


save(strcat('./NewResult/senator_',int2str(i),'.mat'),'G_idx_glad','R_idx_glad');

% [score_glad(:,i), score_point(:,i)]= GLAD.score_var(data.X,data.Y, hyper_para_glad, var_para_glad);
fprintf('*******Done with GLAD ******* \n');
% %% Graph- spectum
% % 
% import graphcut.*
% [G_idx_graph,Pi,cost]= grPartition(data.Y,M);
% G_idx_graph = G_idx_graph';
% 
% fprintf('*******Done with Graph******* \n');
%% wordle
% import Plot.*;
% fname = strcat(path,'/word_',int2str(i),'.txt');
% wordle(score_glad, score_point,names, G_idx_glad(i,:)', fname);

%% senator - role distribution with time
% row = 2;
% col = 4;
% for i = 1:8
%     hist_data (:,:,i) = Plot.plot_RinG (G(i,:),R(i,:), M ,K);% M x K
%   
% end
% subplot(1,4,1), bar(reshape(hist_data(1,:,:),[8,K]), 'stacked');set(gca,'xtick',[],'ytick',[]);
% subplot(1,4,2), bar(reshape(hist_data(7,:,:),[8,K]), 'stacked');set(gca,'xtick',[],'ytick',[]);
% subplot(1,4,3), bar(reshape(hist_data(8,:,:),[8,K]), 'stacked');set(gca,'xtick',[],'ytick',[]);
% set(gca,'YLim',[1 50]);
% subplot(1,4,4), bar(reshape(hist_data(4,:,:),[8,K]), 'stacked');set(gca,'xtick',[],'ytick',[]);
% set(gca,'YLim',[1 50]);
% for m = 1:M
%       subplot(row, col, m), bar(reshape(hist_data(m,:,:),[8,K]), 'stacked');
%       ylabel('role');
%       xlabel('time');
%       title(['group',num2str(m)]);
% end

end