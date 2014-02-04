align = zeros(M,T);
align(:,1) = 1:M;

% theta_t = rTheta{1};
% for t = 2:T
%     theta_tt = rTheta{t};
%     for m = 1:M
        

% g_t = g(:,1);
% i_t = cell(1,m);
% for m = 1:m
%         i_t{1} = find(g_t==1);
% end
% for t = 2: t
%     g_tt = g(:,t);   
%     i_tt = cell(1,m);
%    
%    
%     for m = 1:M
%         i_tt{m} = find(g_tt == m);
%         overlap = zeros(M,1);
%         for mm = 1:M
%             overlap(mm
%             
%     end
%     
%     
%     
%     g_t = g_tt;
% end


for t = 1: T
    G_tt = rGp{t};
    align(:,t) = histc(G_tt,[1:M]);
end
    
    
    
    
    