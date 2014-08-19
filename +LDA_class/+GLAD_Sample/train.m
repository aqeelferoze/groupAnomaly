% function model  = train(X, Y, hyper_para)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

import GLAD_Sample.*

hyper_para.nC = 1;
hyper_para.nM = 300;


[rRp,rGp,rPi,rTheta,rB,rBeta] = MCEMGLAD(X,Y,hyper_para.theta,...
    hyper_para.B,hyper_para.beta,hyper_para.alpha,hyper_para.nC,hyper_para.nM);

model.R = rRp;
model.G = rGp;
model.Pi = rPi;
model.Theta = rTheta;
model.B = rB;
model.Beta = rBeta;




