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
X = zeros(num_author,num_term);
for d = 1:num_doc
    fprintf('# %d \n',d);
    co_author = find(Mda(d,:) ==1);
    for a = co_author
        X(a,:) = X(a,:) + Mdt(d,:);
    end
end

X = sparse(X);

%%

%  data.X = Mdt; 
%  data.Y = Y;
%  
%  Y_binary = double(Y>0);
%  data.Y_bin = Y_binary;
%  
 

 

