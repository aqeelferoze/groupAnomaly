% Generate Static synthetic data
clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
import GLAD2.*;
N = 500;
Ms = 1:10;
pr = 0.2;


for i = 1:length(Ms)
    for n = 1: 10
        M = Ms(i);
        Pr = ceil(pr*M);
        fname = strcat('syn',int2str(M),'_',int2str(n),'.mat');
        indices = randperm(M);
        bad_idx = indices(1:Pr); %  normal groups
        good_idx = indices(Pr+1:end); %  anomaly
        [data, hyper_para]  = GLAD2.genData( N,M , good_idx, bad_idx);
        save(fname,'data','hyper_para','bad_idx','good_idx');
        fprintf('M = %d, Bad = %d\n', M,Pr);
    end
end


