clear;
file ='~/Downloads/Dataset/data_adams/E.txt'; % Adjacent Matrix
E= load(file);
N= size(E,1);
nrep = 100; % Number of repetition

res =[];
k = 5;
maxIter = 20;
for iter = 1:maxIter
[ndx(:,iter),Pi,cost]= grPartition(E,k,nrep);
end

csvwrite('~/Downloads/Dataset/data_adams/groupID_cut.csv',ndx);

