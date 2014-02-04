function entropy = cal_entropy( G_idx,R_idx ,M,K)
%CAL_ENTROPY Summary of this function goes here
%   Detailed explanation goes here

import lib.*;
for m = 1:M
    hist_data(m,:)= histc(R_idx(G_idx==m),1:K)';
    
end
    p = mnormalize(hist_data,2);
    entropy = sum(p .* logs(p),2);
    entropy = sort(entropy);
end

