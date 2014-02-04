clear all;
load('initDGLAD.mat');

drawResultDGLAD(Xp,Y,gPi,gGp,gRp,gTheta,nC);
drawResultDGLAD(Xp,Y,Pi,Gp,Rp,Theta,nC);

[rRp,rGp,rPi,rTheta,riTheta,rB,rBeta,rMu] = MCEMDGLAD(Xp,Y,Rp,Gp,Pi,Theta,initTheta,B,Beta,alpha,Sigma,nC,nM);
drawResultDGLAD(Xp,Y,rPi,rGp,rRp,rTheta,nC);

%Theta = sampleTheta(Gp,Rp,Sigma,ones(rNum));
[GCA,PA] = calAnomalyScore(Xp,rRp,rTheta,rMu,rBeta,0.5);
drawAnomalyDGLAD(GCA,PA,Xp,rRp,rTheta);
