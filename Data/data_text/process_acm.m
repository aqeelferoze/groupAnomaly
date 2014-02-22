T = 10;
doc_bow_100 = cell(1,10);
for t = 1:T
    doc_bow_100{t} = sparse(bowmat(:,:,t));
end

%%
author_adj_100 = cell (1,10);
for t = 1:T
    author_adj_100{t} = sparse(adjmat(:,:,t));
end