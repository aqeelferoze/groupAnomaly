clear all

alpha = 0.1;

nNum = 100;
gNum = 10;
rNum = 3;
aNum = 3;
lambda = 100;

B = 0.1*ones(gNum,gNum) + 0.8*eye(gNum,gNum);
gRole = [0.1,0.8,0.1
         0.8,0.1,0.1
         0.1,0.1,0.8];
Theta = zeros(gNum,rNum);

for gi=1:gNum
    Theta(gi,:) = gRole(mod(gi,3)+1,:);
end

Beta = [0.8,0.1,0.1
        1/3,1/3,1/3
        0.5,0.0,0.5];
    
[Xp, Y, Pi, Zl, Zr, Gp, Rp] = generateData(nNum, alpha, B, Theta, Beta, lambda);
