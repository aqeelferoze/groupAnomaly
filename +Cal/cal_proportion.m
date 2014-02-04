function [ vals ] = cal_proportion(G_idx,R_idx, M ,K  )
%CAL_PROPORTION Summary of this function goes here
%   Detailed explanation goes here
import Cal.*;
import GLAD.lib.*;
hist_data = zeros(K,M);
for m = 1:M
    hist_data(:,m)= histc(R_idx(G_idx==m),1:K);

end

vals = Cal.mnormalize(hist_data);
vals = sort(vals);

end

