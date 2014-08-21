function [data] = genData(hyper_para)
%GENDATA Summary of this function goes here
%   Detailed explanation goes here
    N = hyper_para.N;
    B = hyper_para.B;
    M = hyper_para.M;
    alphas = hyper_para.alpha;
    import lib.*;
    data.Pi = zeros(N,M);
    for p=1:N
        data.Pi(p,:) = dirrnd(alphas);
    end
    
    data.Zl = zeros(N,N);
    data.Zr = zeros(N,N);
    data.Y = zeros(N,N);
    
    for p=1:N
        for q=1:N
            data.Zl(p,q) = find(mnrnd(1,data.Pi(p,:))==1);
            data.Zr(p,q) = find(mnrnd(1,data.Pi(q,:))==1);
            data.Y(p,q) = binornd(1, B(data.Zl(p,q), data.Zr(p,q)));
        end
    end
end

