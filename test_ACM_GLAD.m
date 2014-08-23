%test the GLAD on ACM dataset
clear;clc;
import GLAD.*;
import lib.*;

load ('./Data/data_ACM/acm_bows_100.mat');
load ('./Data/data_ACM/acm_links_100.mat');

Y_t = adjmat;
X_t = bowmat;
T = size(X_t,3);


%%
M = 20;
K = 4;
V = 8025;

imax = 100;

hyper_para_init.alpha = 0.1 * ones(1,M);
hyper_para_init.B = 0.1.*eye(M)+0.3.*ones(M,M);
hyper_para_init.beta = mnormalize(randi(imax, [K,V]), 2);
hyper_para_init.theta = mnormalize( randi(imax, [K,M]), 1);

%%
for t = 1:T
    X_org = full(X_t(:,:,t)) + 1;
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
    
    Y  = Y_t(:,:,t);
    data.X = X;
    data.Y = Y;
    [hyper_para_glad,var_para_glad] = GLAD.glad(data,hyper_para_init);
    save(strcat('./NewResult/senator_',int2str(t),'.mat'),'hyper_para_glad','var_para_glad');


end
