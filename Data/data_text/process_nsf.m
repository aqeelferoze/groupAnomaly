clear;
clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));

load('NSF4.mat');

num_term = size(Mdt, 2);

%% generate anomalous data

load('NSF4.mat');
[num_doc, num_conf] = size(Mdc);

N = 500;
for M = [5 10 20 ];
thres = 0.2;sz_group = N/M; 
Pr = ceil(M*thres);
bad_idx = randperm(M,Pr);
good_idx = setdiff([1:M],bad_idx);



N = M * sz_group;
math_idx = 3;econ_idx = 6;
math_doc = find(Mdp(:,math_idx)==1); % program 
econ_doc = find(Mdp(:,econ_idx)==1);

num_math = length(math_doc);
num_econ = length(econ_doc);

num_term = size(Mdt,2);
X = zeros(N,num_term);

%%

doc_idx = zeros(M,sz_group);


for m = good_idx
    select_idx = randperm(num_math,sz_group);
    idx = math_doc(select_idx);
    st = (m-1)*sz_group + 1;
    ed =  m *  sz_group;
    doc_idx(m,:) = idx;
    X(st:ed,:) = Mdt(idx,:);
end

for m= bad_idx
    select_idx = randperm(num_econ,sz_group);
    idx = econ_doc(select_idx);
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

save(strcat('./Data/data_text/NSF_anomaly_',int2str(M),'.mat'),'X','Y','bad_idx');
fprintf('Data generated M = %d \n',M);

end
