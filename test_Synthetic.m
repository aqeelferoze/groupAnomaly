clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
global verbose;
verbose = 1;

load ('syn10.mat');


%% 
import GLAD2.*; 
var_para = GLAD2.train(data,hyper_para);

    
%%    


scores = GLAD2.score_var(data.X, data.Y , hyper_para, var_para);
 

%%
import GLAD_Sample.*;

nC = 100;
nM = 100;
[Pi,Gp,Rp] = GLAD_Sample.samplingGLAD(data.X,data.Y,hyper_para.B,hyper_para.theta',hyper_para.beta,hyper_para.alpha,nC,nM);





