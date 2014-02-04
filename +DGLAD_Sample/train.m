function model  = train(X, Y, hyper_para)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

import DGLAD_Sample.*




[rRp,rGp,rPi,rTheta,riTheta,rB,rBeta] = MCEMDGLAD(X,Y,hyper_para.Theta,hyper_para.Theta0,...
    hyper_para.B,hyper_para.Beta,hyper_para.alpha,hyper_para.Sigma,hyper_para.nC,hyper_para.nM);

model.R = rRp;
model.G = rGp;
model.Pi = rPi;
model.Theta = rTheta;
model.Theta0 = riTheta;
model.B = rB;
model.Beta = rBeta;



end

