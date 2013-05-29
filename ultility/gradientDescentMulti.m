function [theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
% theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
% taking num_iters gradient steps with learning rate alpha

% x1=ones(30,1);
% x2=(1:30)';
% Xm=x2;
% Xm1=(-repmat(min(Xm,[],1),size(Xm,1),1))*spdiags(1./(max(Xm,[],1)-min(Xm,[],1))',0,size(Xm,2),size(Xm,2));
% Xf=[x1,x2];
% 
% yf=x2*4+6+rand(30,1);
% theta=pinv(Xf'*Xf)*Xf'*yf;
% alpha=0.01;
% num_iters=20;
% 
% X=Xf(1:20,:);
% y=yf(1:20,:);

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters
 gradJ = 1/(2*m) * 2 * (X'*X*theta - X'*y);
 theta = theta - alpha * gradJ;
 J_history(iter) = computeCostMulti(X, y, theta);
end
% % 
%  J_historyf=computeCostMulti(Xf(21:30,:), yf(21:30,:), theta)
end

