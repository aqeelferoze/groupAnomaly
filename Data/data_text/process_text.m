clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

load('dblp_4area_abstract.mat');
[num_doc , num_author] = size(Mda);
num_term = size(Mdt, 2);

%%
% Y = zeros(num_author, num_author);
% for d = 1:num_doc
%     fprintf('# %d \n',d);
%     co_author = find(Mda(d,:) ==1);
%     if(numel(co_author)>1)
%         pairs = nchoosek(co_author, 2);
%         for p = 1: size(pairs,1);
%             pair = pairs(p,:);
%             Y(pair(1),pair(2)) =Y(pair(1),pair(2))+1;
%             Y(pair(2),pair(1)) =Y(pair(2),pair(1))+1;
%         end
%     end
% end
% Y = sparse(Y);
%% construct authors bag of words
% X = zeros(num_author,num_term);
% for d = 1:num_doc
%     fprintf('# %d \n',d);
%     co_author = find(Mda(d,:) ==1);
%     for a = co_author
%         X(a,:) = X(a,:) + Mdt(d,:);
%     end
% end
% 
% X = sparse(X);

%% generate anomalous data

load('dblp_4area_abstract.mat');
[num_doc, num_conf] = size(Mdc);

for M = [5 10 20 50 100 200];
thres = 0.2;sz_group = 20; 
Pr = ceil(M*thres);
bad_idx = randperm(M,Pr);
good_idx = setdiff([1:M],bad_idx);



N = M * sz_group;
kdd_idx = 11;cvpr_idx = 3;
kdd_doc = find(Mdc(:,kdd_idx)==1);
cvpr_doc = find(Mdc(:,cvpr_idx)==1);

num_kdd = length(kdd_doc);
num_cvpr = length(cvpr_doc);

num_term = size(Mdt,2);
X = zeros(N,num_term);

%%

doc_idx = zeros(M,sz_group);


for m = good_idx
    select_idx = randperm(num_kdd,sz_group);
    idx = kdd_doc(select_idx);
    st = (m-1)*sz_group + 1;
    ed =  m *  sz_group;
    doc_idx(m,:) = idx;
    X(st:ed,:) = Mdt(idx,:);
end

for m= bad_idx
    select_idx = randperm(num_cvpr,sz_group);
    idx = cvpr_doc(select_idx);
    st = (m-1)*sz_group + 1;
    ed =  m *  sz_group;
    doc_idx(m,:) = idx;
    X(st:ed,:) = Mdt(idx,:);
end

%%

% Y = zeros(N,N);
% doc_idx = doc_idx(:);
% for i = 1:N
%     for j = 1:N
%         p1 = Mda(doc_idx(i),:);
%         p2 = Mda(doc_idx(j),:);
%         if(any(p1&p2) )
%             Y(i,j)=1;
%         end
%         
%     end
% end
% Y = sparse(Y);


Y = zeros(N,N);
for m = 1:M
    start_idx = (m-1)*sz_group+1;
    end_idx = m*sz_group;
    Y(start_idx:end_idx,start_idx:end_idx) = 1;
end

Y = sparse(Y);

save(strcat('./Data/data_text/dblp_anomaly_',int2str(M),'.mat'),'X','Y','bad_idx');
fprintf('Data generated M = %d \n',M);

end

    
 

 

