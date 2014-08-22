clear; clc;
import GLAD.*; 
import lib.*
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 1;
X_org = load('./Data/data_adams/activity.txt');
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
data.Y= load('./Data/data_adams/E.txt');
data.Y = double (data.Y>0);
truth =  load('./Data/data_adams/truth.txt');


%%

M = 10; K = 3; 
repeat_num = 10;

for n = 1:repeat_num
    [ hyper_para_init ] = init_hyper_para_void( M,K ,V);
    [var_para_glad, hyper_para_glad] = GLAD.glad(data,hyper_para_init);


    % get group, role index by aggregating activities
    G_idx_infer = infer_assignment(var_para_glad.lambda);
    R_idx_infer =  infer_assignment(var_para_glad.mu);
    G_idx_glad = lib.aggregate_assignment(G_idx_infer,M);
    R_idx_glad = lib.aggregate_assignment(R_idx_infer,K);
    X_aggregate = lib.aggregate_activity( data.X, V);

    scores_glad = score_var(data.X, data.Y, hyper_para_glad, var_para_glad )
    fprintf('*******Done with GLAD iter %d ******* \n',n);

    save(strcat('./NewResult/gladAdams_',int2str(n),'.mat'),'G_idx_glad','R_idx_glad','scores_glad');
end
%%

exit;


