function like = like_var(self, X, group_id)
%LIKE_SIMP Summary of this function goes here
%   Detailed explanation goes here

alpha = self.alpha; % K x 1
beta = self.beta; % V x K
phi = self.phi; % N x K
gama = self.gama; % K x M 

gama = mnormalize (gama);
like_point = diag(X * log(beta* gama(:,group_id)));
like = accumarray(group_id, like_point);

end

