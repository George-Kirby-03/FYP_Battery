clear; clc; close all;

%%  Data 
X = [-2; -1; 0; 1; 2; 3];
y = [0; 1; 0; -1; 0; 1.5]; 

%% Kernel (RBF) 
kernel = @(x,z,alpha,l) alpha^2 * exp(-( (x-z).^2 )/(2*l^2));

alpha = 1;     
l = 1;    

%%  Cov K 
n = length(X);
K = zeros(n,n);
for i = 1:n
    for j = 1:n
        K(i,j) = kernel(X(i), X(j), alpha, l);
    end
end

%% Prediction Test Sample points
Xs = linspace(-10,10,200)';
m = length(Xs);

%% Posterior
mu_post = zeros(m,1);
var_post = zeros(m,1);

Kinv = inv(K); 

for i = 1:m
    kstar = zeros(n,1);
    for j = 1:n
        kstar(j) = kernel(Xs(i), X(j), alpha, l);
    end
    kss = kernel(Xs(i), Xs(i), alpha, l);
    mu_post(i) = kstar' * Kinv * y;
    var_post(i) = kss - kstar' * Kinv * kstar;
end

std_post = sqrt(var_post);
upper = mu_post + 1.96*std_post;
lower = mu_post - 1.96*std_post;


figure; hold on; grid on;
scatter(X,y,50,'r','filled')
plot(Xs, mu_post, 'b','LineWidth',2)
fill([Xs; flipud(Xs)], [upper; flipud(lower)], ...
    [0.7 0.8 1], 'EdgeColor','none','FaceAlpha',0.4)

title('Gaussian Process Posterior (Page 4 Formula)')
xlabel('x')
ylabel('f(x)')
legend('Observations','Posterior Mean','95% Credible Interval')

%% ---- PRIOR SAMPLE FUNCTIONS ----
alpha = 1;     % output scale
l = 0.3;         % length scale
% Sample locations for drawing functions
Xs = linspace(-5,5,200)'; 
m = length(Xs);

% Build prior covariance Kss = K(Xs, Xs)
Kss = zeros(m,m);
for i = 1:m
    for j = 1:m
        Kss(i,j) = kernel(Xs(i), Xs(j), alpha, l);
    end
end

% Numerical jitter for stability
Kss = Kss + 1e-6*eye(m);

% Draw 3 random functions from GP prior
L = chol(Kss,'lower');                 % Cholesky factor
f1 = L*randn(m,1);
f2 = L*randn(m,1);
f3 = L*randn(m,1);

% Plot
figure; hold on; grid on;
plot(Xs,f1,'LineWidth',2)
plot(Xs,f2,'LineWidth',2)
plot(Xs,f3,'LineWidth',2)

title('Samples from GP Prior')
xlabel('x')
ylabel('f(x)')
