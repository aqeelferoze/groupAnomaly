function [ val ] = logs( X )
%LOGS Summary of this function goes here: Stablized version of log
%   Detailed explanation goes here
val= log(X);
% if(sum(~isfinite(val)>0))
%     warning('Logs: Input infinite','Value Error');
% end
%     
val(~isfinite(val))=0;
val(~isreal(val))=0;

end

