
%WORDLE Summary of this function goes here
%   Detailed explanation goes here
function wordle  (score_group,score_point ,name, group_ID, fname)
fid = fopen(fname,'w')  ;   
M = max(group_ID);

colorSet_orig = b2r(-3,3,M);
   
[~,order] = sort(score_group);
for m  = 1:M
 colorSet(order(m),:) =  colorSet_orig(m,:);
end

for m = 1:M
    colorCode =dec2hex( ceil(colorSet(m,:) * 255),2);
    color(m,:) = strcat(colorCode(1,:),colorCode(2,:),colorCode(3,:));
end
wordColor = color(group_ID,:);
formatSpec = '%s:%6.2f:%s\n';
for i = 1:length(name)
  fprintf(fid, formatSpec,strcat(char(name(i,1)),char(name(i,2))),score_point(i),wordColor(i,:));
end


