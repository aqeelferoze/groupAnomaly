clear all;

%parameters
alpha = 0.3;
nNum = 100;
gNum = 3;
rNum = 3;
aNum = 3;
nC = 10; % Binomial for communication
nM = 100; % Multinomila for activity
nT = 5; % total time


B = 0.1*ones(gNum,gNum) + 0.8*eye(gNum,gNum);
gRole = [1,3,1
         3,1,1
         1,1,3];
initTheta = zeros(gNum,rNum);
for gi=1:gNum
    initTheta(gi,:) = gRole(mod(gi,3)+1,:);
end
%initTheta(gNum,:) = [3,3,3];
Sigma = 0.3;% Guassian Variance for Theta
Beta = [0.8,0.1,0.1
        0.1,0.8,0.1
        0.1,0.1,0.8];
    
%generate data (Normal)
[Xp,Y,Pi,Gp,Rp,Theta] = generateDataDGLAD(nNum,nT,alpha,B,initTheta,Beta,Sigma,nC,nM);

% drawResultDGLAD(Xp,Y,Pi,Gp,Rp,Theta,nC);

%run MCEM on the first time slice
iB = 0.3*ones(gNum,gNum)+0.4*eye(gNum,gNum);
iTheta = ones(gNum,rNum);
iBeta = ones(rNum,aNum);
for gi = 1:gNum
    iTheta(gi,:) = iTheta(gi,:) / sum(iTheta(gi,:));
end
for ri = 1:rNum
    iBeta(ri,:) = iBeta(ri,:) / sum(iBeta(ri,:));
end

gPi = Pi;
gGp = Gp;
gRp = Rp;
gTheta = Theta;

[B,firstTheta,Beta,firstGp,firstRp,Pi] = MCEMGLAD(Xp{1},Y{1},iB,iTheta,iBeta,nC,nM,3);
drawResultGLAD(Xp{1},Y{1},Pi,firstGp,firstRp);

%initnalization sampling
Rp = cell(1,nT);
Gp = cell(1,nT);
Theta = cell(1,nT);

for t=1:nT
    Rp{t} = firstRp;
    Gp{t} = firstGp;
    Theta{t} = firstTheta;
end

save('initDGLAD.mat');