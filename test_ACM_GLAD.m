%test the GLAD on ACM dataset
import GLAD.*;
import lib.*;

load ('./Data/data_ACM/acm_small100.mat');
X_t = author_adj_100;
Y_t = doc_bow_100;
T = length(X_t);


%%
M = 20;
K = 4;
imax = 100;
hyper_para_init.alpha = 0.1 * ones(1,M);
hyper_para_init.B = 0.1.*eye(M)+0.3.*ones(M,M);
hyper_para_init.beta = mnormalize(randi(imax, [K,V]), 2);
hyper_para_init.theta = mnormalize( randi(imax, [K,M]), 1);

%%
for t = 1:T
    X_org = X_t{t};
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
    Y  = Y_t{t};
    data.X = X;
    data.Y = Y;
    [hyper_para_glad,var_para_glad] = GLAD.glad(data,hyper_para_init);
    save(strcat('./NewResult/senator_',int2str(t),'.mat'),'hyper_para_glad','var_para_glad');


end
