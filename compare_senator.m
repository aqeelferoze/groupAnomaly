%% Parameter
N =100;
M = 10;
K = 4;
%% Senator
import lib.*;
load ('~/Downloads/Dataset/data_senator/senator.mat');
load('~/Downloads/Dataset/data_senator/names.mat');

data.X= load('~/Downloads/Dataset/data_senator/attributes.csv');
% X = mnormalize(X,2);
% data.X = mnrnd(10,X);


time = clock;
foldername= sprintf('%d_%d_%d_%d', time(2),time(3),time(4),time(5));
mkdir('Senator',foldername)
path = strcat(pwd,'/Senator/',foldername,'/');

for i = [4]
    
data.Y = E(:,:,i);

[hyper_para_glad,var_para_glad] = GLAD.glad(data.X, data.Y,M,K);
[~, G_idx_glad(i,:)] = max(var_para_glad.lambda);
[~, R_idx_glad(i,:)] = max(var_para_glad. mu);
[score_glad(:,i), score_point(:,i)]= GLAD.score_var(data.X,data.Y, hyper_para_glad, var_para_glad);
fprintf('*******Done with GLAD ******* \n');
% %% Graph- spectum
% % 
% import graphcut.*
% [G_idx_graph,Pi,cost]= grPartition(data.Y,M);
% G_idx_graph = G_idx_graph';
% 
% fprintf('*******Done with Graph******* \n');
%% wordle

import Plot.*;
fname = strcat(path,'/word_',int2str(i),'.txt');
wordle(score_glad, score_point,names, G_idx_glad(i,:)', fname);

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
%% party

%%
save(strcat(path,'/workspace',int2str(i),'.mat'));
end