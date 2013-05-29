function [J, grad] = lrCostFunction(theta, X, y, lambda)
%LRCOSTFUNCTION Compute cost and gradient for logistic regression with
%regularization
% J = LRCOSTFUNCTION(theta, X, y, lambda) computes the cost of using
% theta as the parameter for regularized logistic regression and the
% gradient of the cost w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples

J = 0;
grad=zeros(size(theta));
% ====================== YOUR CODE HERE ======================
A = theta(2:size(theta),1);
J = sum((-y.*log(sigmoid(X*theta)))-(1-y).*log(1-sigmoid(X*theta)))/m+lambda/(2*m)*sum(A.^2);
grad(1) = sum((sigmoid(X*theta)-y).*X(:,1))/m;
grad(2:end) = ((X(:,2:end))'*(sigmoid(X*theta)-y)+theta(2:end).*lambda)/m;
% =============================================================

end