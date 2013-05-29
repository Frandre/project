function [mean_fea,cov_fea , X_norm] = whitening(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.

X=double(X);
mean_fea=mean(X);
X_norm=bsxfun(@minus,X, mean_fea);

cov_X=cov(X_norm);
[eig_vect,eig_val]=eig(cov_X);
cov_fea=eig_vect*(sqrt(eig_val)^(-1))*eig_vect';
X_norm=X_norm*cov_fea;
% ============================================================
end