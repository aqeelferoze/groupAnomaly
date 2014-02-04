function [res] = conju_descent( start_point, para)
%CONJU_DESCENT Conjugate descent algorithm of the theta 
%   Detailed explanation goes here

bwdmean= para.bwdmean;
bwdvar= para.bwdvar;
dbwdmean=para.dbwdmean;

M = size(bwdmean,2);
MaxIter = 100;
for iter = 1: MaxIter
    for m = 1:M
        diff_mean = (bwdmean(:,:,2:T+1)-bwdmean(:,:,1:T)).* (dbwdmean(:,:,2:T+1)-dbwdmean(:,:,1:T));
        diff_data =  ~
        gradient  = -1/sigma *  sum(diff_mean,2)+
end

