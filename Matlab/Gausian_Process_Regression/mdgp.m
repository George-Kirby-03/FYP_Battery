%% Multi Variate 
clear; clc; close all;

%% ---- Data ----
X = [-2; -1; 0; 1; 2; 3; 8];
y = [0; 1; 0; -1; 0; 1.5; -2];   % pretend we observed this (noise-free)

%% ---- Kernel (RBF) ----
kernel = @(x,z,alpha,l) alpha^2 * exp(-( (x-z).^2 )/(2*l^2));

alpha = 1;     % output scale
l = 1;         % length scale

%% ---- Build Covariance Matrix K ----
n = length(X);
K = zeros(n,n);
for i = 1:n
    for j = 1:n
        %K(i,j) = kernel(X(i), X(j), alpha, l);
        K(i,j) = pekernal(1,1,0.5,X(i), X(j));
    end
end

%% ---- Prediction Grid ----
Xs = linspace(-10,10,200)';
m = length(Xs);

%% ---- Compute Posterior ----
mu_post = zeros(m,1);
var_post = zeros(m,1);

Kinv = inv(K);   % (Σ0(x1:n,x1:n))^-1

for i = 1:m
    % k(x*, X)
    kstar = zeros(n,1);
    for j = 1:n
        %kstar(j) = kernel(Xs(i), X(j), alpha, l);
        kstar(j) = pekernal(1,1,0.5,Xs(i), X(j));

    end
    
    % prior variance at x*
   % kss = kernel(Xs(i), Xs(i), alpha, l);
    kss = pekernal(1,1,0.5,Xs(i), Xs(i));
    % ---- Page 4 formulas ----
    mu_post(i) = kstar' * Kinv * y;
    var_post(i) = kss - kstar' * Kinv * kstar;
end

std_post = sqrt(var_post);
upper = mu_post + 1.96*std_post;
lower = mu_post - 1.96*std_post;

%% ---- Plot ----
figure; hold on; grid on;
scatter(X,y,50,'r','filled')
plot(Xs, mu_post, 'b','LineWidth',2)
fill([Xs; flipud(Xs)], [upper; flipud(lower)], ...
    [0.7 0.8 1], 'EdgeColor','none','FaceAlpha',0.4)

title('Gaussian Process Posterior (Page 4 Formula)')
xlabel('x')
ylabel('f(x)')
legend('Observations','Posterior Mean','95% Credible Interval')
