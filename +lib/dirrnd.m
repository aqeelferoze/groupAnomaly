function theta = dirrnd(alpha)
% draws a sample from a dirichlet with the parameter vector alpha
theta = randg(alpha);% gamma random with unit scale
theta = theta/sum(theta);
