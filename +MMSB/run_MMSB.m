% clear;
% load('~/Downloads/Dataset/data_senator/senator.mat');
% X =load('~/Downloads/Dataset/data_senator/attributes.csv');
% % X = mnormalize(X);
% Y= E(:,:,1);

% load('~/Downloads/Dataset/lazega_lawfirm/lazega.mat')
% Y = load('~/Downloads/Dataset/sampson.txt');
% Y= double(Y>0);

% clear;
% load('test.mat');

clear;
N = 50;
M = 10;
% K = 5;
% V = 20;
% count = 100;
%data= genData (N,M);

% clear;
% load('~/Downloads/Dataset/data_senator/senator.mat');
% X =load('~/Downloads/Dataset/data_senator/attributes.csv');
% % X = mnormalize(X);
% Y= E(:,:,1);
load('data.mat');
[hyper_para,var_para] = mmsb(data.Y,M);

[~, G_idx] = max(var_para.gama);
%[pi,zL,zR]= get_latent (phiL,phiR ,gama,alpha, B);
%[ scores] = score_var(hyper_para, var_para);
