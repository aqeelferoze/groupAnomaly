import GLAD.*

clear all

global verbose
verbose =1; 
nNum= 25;
M = 3; 
alpha_val = 0.1;
B = 0.9 * eye(M)+1e-2*ones(M);
% beta = [0,1; 5,5]; % NOTE: for the Gaussian, no need to normalize
beta = [0.9,0.05,0.05;
        0.05,0.9,0.05;
        0.05,0.05,0.9];
    

theta = [0.9, 0.1, 0.0;
         0.0, 0.9, 0.1;
         0.0, 0.1, 0.9]';

K = 3;
lambda = 50;

pr = 0.2;

%Pr = ceil(pr*M);
%indices = randperm(M);
%bad_idx = indices(1:Pr); %  normal groups
%good_idx = indices(Pr+1:end); %  anomaly
%theta(:,good_idx) = repmat(good,[1,length(good_idx)]);
%theta(:,bad_idx) = repmat(bad,[1,length(bad_idx)]);


hyperMaxPre = 5;
varMaxPre = 50;

[data, hyper_para_true] = generateData(nNum, alpha_val, B, theta, beta, lambda);
hyper_para_init = init_hyper_para(hyper_para_true);
[ var_para , hyper_para] = glad(data, hyper_para_init, hyperMaxPre, varMaxPre);
%%
disp( hyper_para_true.B);
disp(hyper_para.B);

%%
%import Plot.*
%plot_GLAD_main(data, hyper_para, var_para);