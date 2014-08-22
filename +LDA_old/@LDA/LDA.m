classdef LDA
    %LDA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        alpha; % 1 x K
        beta; % V x K
        gama % K x M - avoid confusion with gamma(X) function
        phi % N x K
    end
    
    methods
        % Constructor
        function [model] = LDA(alpha,  beta, gama, phi)
            if nargin >= 2 % number of function input arguments
                model.alpha = alpha;
                model.beta = beta;
                if nargin == 4
                    model.gama = gama;
                    model.phi = phi;
                end
            end
        end
        
        % number of topics
        function [k] = K(self)
            k = size(self.gama, 1);
        end
        
    end
    
    methods(Static)
        [lda, L] = Train(X, group_id, K, options); % Called in main
    end
    
end

