function loglike = test(Xp, Yp, model,hyper_para )
%TEST Summary of this function goes here
%   Detailed explanation goes here
import DGLAD_Sample.*
import lib.*

Rp = model.R(end);
Gp = model.G(end);
Pi = model.Pi;
Theta_init = model.Theta(end);
Theta0 = model.Theta0;
B = model.B;
Beta = model.Beta;
alpha = hyper_para.alpha;
Sigma = hyper_para.Sigma;
nC = hyper_para.nC;
nM =hyper_para.nM;

X=cell2mat(Xp);
Y=cell2mat(Yp);
G=cell2mat(Gp);
R=cell2mat(Rp);
Theta = cell2mat(Theta_init);
N = length(G);
[gNum, rNum ] = size(Theta);

for gi = 1: gNum
    t =  mvnrnd (Theta(gi,:), Sigma*eye(rNum));
    Theta(gi,:) = exp(t)/sum(exp(t));
end


loglike =0;
for n = 1:N
    loglike = loglike + logs(dirpdf(Pi(n,:),alpha*ones(1,gNum)));

    ri =  find(R(n,:)==1);
    gi = find(G(n,:) ==1 );
    loglike = loglike + logs(Pi(n,gi)) + logs(Theta(gi,ri));
    loglike = loglike +logs( mnpdf(X(n,:),Beta(ri,:)));
    tmp =0;
    for n2 = 1:N
        gn = find(G(n,:) ==1 );
        tmp = tmp+Y(n,n2)*logs(B(gi,gn))+(nC-Y(n,n2))*logs(1-B(gi,gn));
    end
    loglike = loglike + tmp;
end
 fprintf('likelihood  :%d \n ',  loglike);
end

