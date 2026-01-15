%% 

alpha = 0.5;     
l = 1;         

Xs = linspace(-6,10,50)'; %Entire X_star points to be used (test points)
% Want the form [X1(1), X1(2); X2(1), X2(2); ...] so kernal can treat two
% dimensions differently, each column dimension is x and y respecitvley for
% the meshgrid, my idea is to have all mesh points in a vector and reshape
% in the end back to the 2d grid
[X1, X2] = meshgrid(linspace(-6,10,80),linspace(-6,10,80));
m = length(X1)*length(X2);
%By doing [X1(:), X2(:)], it sticks each size 1 row of each X together so
%the now shape is m x d where m is the number of mesh points and d is the
%dimension of each vector point (2 currently), this gives..
Xs = [X1(:), X2(:)]; 

%Make the K(X_star,X_star) matrix thing
%According to wikipedia Covi,j = K(i,j) sort of thing
Kss = zeros(m,m);
for i = 1:m
    for j = 1:m
        Kss(i,j) = pekernal(2, l, alpha, Xs(i,:), Xs(j,:)); %Dim is now 2
    end
end

f = mvnrnd(zeros(m,1), Kss, 3);  %Sampling 3 vectors (vector is the function)

%Reshape back into 2D, the f(a,:) output needs putting in 2d array shape,
%every mth row down needs shifting to become the next column
B = reshape(f(1,:),length(X1),[]); %As matlab docs, let colum wise be auto determined

figure; hold on; grid on;
mesh(X1,X2,B)

%% Now when data incoming for functions to be conditioned against
% Plot


% Now assume some noise free data is observed, can then codition the prior
% distrobution on this new data i.e gp regression...
%currently assuming no prior knowlage 
% f∗|X∗, X,f ∼ N(K(X∗, X)K(X, X)−1f,K(X∗, X∗) − K(X∗, X)K(X, X)−1K(X, X∗))
% eq 2.19


% Assuming X_star and f_star are defined for the new data points

X = [-2,-4; 
    -1,0; 
    0,1; 
    1,2; 
    2,4; 
    3,5; 
    5,5];
f = [sin(X(1,1)); sin(X(2,1)); sin(X(3,1)); sin(X(4,1)); sin(X(5,1)); sin(X(6,1)); sin(X(7,1))];
n = length(X); %Seems to report the size wanted

K_X_star_X = zeros(m,n);
K_X_star_X_star = Kss; % Already computed
K_X_X_star = zeros(n,m);
K_X_X = zeros(n,n);

%Computing K(X*,X)
for i = 1:m
    for j = 1:n
        K_X_star_X(i,j) = pekernal(2,l,alpha,Xs(i,:),X(j,:));
    end
end

%Computing K(X,X)
for i = 1:n
    for j = 1:n
        K_X_X(i,j) = pekernal(2,l,alpha,X(i,:),X(j,:));
    end
end

%Computing K(X,X*)
for i = 1:n
    for j = 1:m
        K_X_X_star(i,j) = pekernal(2,l,alpha,X(i,:),Xs(j,:));
    end
end


post_mu = (K_X_star_X*inv(K_X_X))*f;   %Supose could give f individualy, but given as vector as per book
post_cov = K_X_star_X_star - (K_X_star_X *inv(K_X_X)) * K_X_X_star; % Posterior covariance
std_post = sqrt(diag(post_cov)); 
k=1;
acq = post_mu + k * std_post;
upper = post_mu + 1.96 * std_post;
lower = post_mu - 1.96 * std_post;

% Sample 3 functions from the posterior distribution
f_star = mvnrnd(post_mu', post_cov, 3); 

figure; 
hold on; 
grid on;
B = reshape(f_star(1,:),length(X1),[]); %As matlab docs, let colum wise be auto determined
C = reshape(acq,length(X1),[]); %As matlab docs, let colum wise be auto determined
mesh(X1,X2,C)
scatter3(X(:,1), X(:,2), f, 80, 'r', 'filled')

% % Uncertainty +-2 (stgandard deviations had to ask AI how to do this part)
% fill([Xs; flipud(Xs)], ...
%      [upper; flipud(lower)], ...
%      [0.7 0.8 1], ...
%      'EdgeColor','none', ...
%      'FaceAlpha',0.4);
% 
% % Posterior function samples
% plot(Xs, f_star(1,:), 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5)
% plot(Xs, f_star(2,:), 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5)
% plot(Xs, f_star(3,:), 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5)
% 
% % Posterior mean
% plot(Xs, post_mu, 'b', 'LineWidth', 2.5)
% 
% % Observed data points
% plot(X, f, 'ko', 'MarkerFaceColor','k', 'MarkerSize',6)
% 
% title('GP Posterior')
% xlabel('x')
% ylabel('f(x)')
