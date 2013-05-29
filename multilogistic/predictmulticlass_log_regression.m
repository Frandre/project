function p=predictmulticlass_log_regression(all_theta,X,condition)
%PREDICT Predict the label for a trained classifier. The labels
%are in the range 1..K, where K = size(all_theta, 1).
 
m = size(X, 1);
num_labels = size(all_theta, 1);
if ~condition
   p = zeros(size(X,1), 1);
else
    p=zeros(m,num_labels);
end

X = [ones(m, 1) X];

for j=1:m,
    X_result=exp(X(j,:)*all_theta');
    partition=sum(X_result);
    X_final=X_result/partition;
    if ~condition
        [trash,p(j)]=max(X_final);
    else
        p(j,:)=X_final;
    end
end
end
