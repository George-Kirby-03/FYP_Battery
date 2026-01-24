
alpha = 0.5;     
l = 1;         

Xs = linspace(-6,10,200)'; %Entire X_star points to be used (test points)
m = length(Xs);

%Make the K(X_star,X_star) matrix thing
%According to wikipedia Covi,j = K(i,j) sort of thing
Kss = zeros(m,m);
for i = 1:m
    for j = 1:m
        Kss(i,j) = pekernal(1, l, alpha, Xs(i), Xs(j));
    end
end

f = mvnrnd(zeros(m,1), Kss, 3);  %Sampling 3 vectors (vector is the function)

% Plot
figure; hold on; grid on;
plot(Xs,f(1,:),'LineWidth',2)
plot(Xs,f(2,:),'LineWidth',2)
plot(Xs,f(3,:),'LineWidth',2)
%Seems to agree with the book so fair play

title('Samples from GP Prior')
xlabel('x')
ylabel('f(x)')

% Now assume some noise free data is observed, can then codition the prior
% distrobution on this new data i.e gp regression...
%currently assuming no prior knowlage 
% f∗|X∗, X,f ∼ N(K(X∗, X)K(X, X)−1f,K(X∗, X∗) − K(X∗, X)K(X, X)−1K(X, X∗))
% eq 2.19


% Assuming X_star and f_star are defined for the new data points


% X = [-2; -1; 0; 1; 2; 3]; %X means the actual observerd point x w correspondiong f's
% f = [2; 4; 1; 6; -2; 10];
X = [-2; -1; 0; 1; 2; 3; 5];
f = [0; 1; 0; -1; 0; 1.5; -2];
n = length(X);

K_X_star_X = zeros(m,n);
K_X_star_X_star = Kss; % Already computed
K_X_X_star = zeros(n,m);
K_X_X = zeros(n,n);

%Computing K(X*,X)
for i = 1:m
    for j = 1:n
        K_X_star_X(i,j) = pekernal(1,l,alpha,Xs(i),X(j));
    end
end

%Computing K(X,X)
for i = 1:n
    for j = 1:n
        K_X_X(i,j) = pekernal(1,l,alpha,X(i),X(j));
    end
end

%Computing K(X,X*)
for i = 1:n
    for j = 1:m
        K_X_X_star(i,j) = pekernal(1,l,alpha,X(i),Xs(j));
    end
end


post_mu = (K_X_star_X*inv(K_X_X))*f;   %Supose could give f individualy, but given as vector as per book
post_cov = K_X_star_X_star - (K_X_star_X *inv(K_X_X)) * K_X_X_star; % Posterior covariance
std_post = sqrt(diag(post_cov)); 
upper = post_mu + 1.96 * std_post;
lower = post_mu - 1.96 * std_post;

% Sample 3 functions from the posterior distribution
f_star = mvnrnd(post_mu', post_cov, 3); 

figure; 
hold on; 
grid on;

% Uncertainty +-2 (stgandard deviations had to ask AI how to do this part)
fill([Xs; flipud(Xs)], ...
     [upper; flipud(lower)], ...
     [0.7 0.8 1], ...
     'EdgeColor','none', ...
     'FaceAlpha',0.4);

% Posterior function samples
plot(Xs, f_star(1,:), 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5)
plot(Xs, f_star(2,:), 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5)
plot(Xs, f_star(3,:), 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5)

% Posterior mean
plot(Xs, post_mu, 'b', 'LineWidth', 2.5)

% Observed data points
plot(X, f, 'ko', 'MarkerFaceColor','k', 'MarkerSize',6)

title('GP Posterior')
xlabel('x')
ylabel('f(x)')
