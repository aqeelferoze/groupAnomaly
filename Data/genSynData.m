% Generate Static synthetic data
clear; clc;
addpath(genpath('~/Documents/MATLAB/groupAnomaly'));
import GLAD.*;
% Ms = 2:10;
Ms = 6;
pr = 0.1;
N = 500;
repeat_num =1;
for i = 1:length(Ms)
    for n = 1: repeat_num
        M = Ms(i);
        Pr = ceil(pr*M);
        fname = strcat('./Data/synth/syn',int2str(M),'_',int2str(n),'.mat');
        indices = randperm(M);
        bad_idx = indices(1:Pr); %  normal groups
        good_idx = indices(Pr+1:end); %  anomaly
        [data, hyper_para]  = GLAD.genData( N,M , good_idx, bad_idx);
        save(fname,'data','hyper_para','bad_idx','good_idx');
        fprintf('M = %d, Bad = %d\n', M,Pr);
    end
end


