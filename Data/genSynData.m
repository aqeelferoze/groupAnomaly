% Generate Static synthetic data
clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
import GLAD2.*;
N = 500;
Ms = [5,10,20,50,100]; pr = 0.8;
for i = 1:length(Ms)
    M = Ms(i);
    Pr = ceil(pr*M);
    fname = strcat('./Data/syn',int2str(M),'.mat');
    indices = randperm(M);
    good_idx = indices(1:Pr); %  normal groups
    bad_idx = indices(Pr+1:end); %  anomaly
    [data, hyper_para]  = GLAD2.genData( N,M , good_idx, bad_idx);
    save(fname,'data','hyper_para','bad_idx','good_idx');
    fprintf('M = %d, Bad = %d\n', M, 1-Pr);
end


