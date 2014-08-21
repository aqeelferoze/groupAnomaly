function plot_GLAD_main (data, hyper_para, var_para)
%%
import Plot.*

    % plot the role distribution in each group
    mu = var_para.mu;
    lambda = var_para.lambda;
    gama = var_para.gama;
    % get group index for each individual
    [M,N] = size(gama);
    G_idx = zeros(1,N);
    for n = 1:N
        [~ ,G_idx(n) ] = max(gama(:,n)) ;
    end
    
    % get role index by aggregating activities
    K = size(mu{1},1);
    R_idx = zeros(1,N);
    for n = 1:N
        Ap = length(mu{n});
        mu_n = mu{n};
        R_cnt = zeros(1,K);
        for a = 1:Ap
            [~ , R_idx_a] = max(mu_n(:,a));
            R_cnt(R_idx_a)= R_cnt(R_idx_a)  + 1;
        end
       [~,  R_idx(n)] = max(R_cnt);
    end  
    
    plot_RinG (G_idx,R_idx, M ,K);
    
 %%  
    % plot the re-arranged adjacent matrix
    plot_E(data.Y, G_idx);
    
 %%   
    % plot simplex of the learned parameter
    plot_simplex(var_para.gama') % gama is the variational parameter for \pi
    
    