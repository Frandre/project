function all_theta=oneVsother(X, y, num_labels,lambda,connum,theta)

%ONEVSALL trains multiple logistic regression classifiers and returns all
%the classifiers in a matrix all_theta, where the i-th row of all_theta
%corresponds to the classifier for label i


m=size(X,1);
n=size(X,2);

all_theta=zeros(num_labels,n+1);

initial_theta=zeros(n + 1,1);     
options = optimset('Hessian', 'on', 'MaxIter',2);
% linec=zeros(size(y,1),1);
y_base=zeros(length(find(y==connum)),1);
X_base=X(find(y==connum),:);

for c=1:num_labels,
    if c~=connum
        y_train=ones(length(find(y==c)),1);
        X_train=X(find(y==c),:);
    
        X_final=[X_base;X_train];
        y_final=[y_base;y_train];
    
        X_final=[ones(length(y_train)+length(y_base),1) X_final];
        
        if ~isnan(theta)
            initial_theta=(theta(c,:))';
        end

%         [b,dev,stats] = glmfit(X_final,y_final,'binomial','link','logit');
%         all_theta(c,:)=b';
        
       all_theta(c,:)=fmincg(@(t)(lrCostFunction(t,X_final,y_final,lambda)),initial_theta,options);
%      all_theta(c,:)=fminunc(@(t)(lrCostFunction(t,X_final,y_final,lambda)),initial_theta,options);
%    linec(find(y==c))=1;
%    for iter=1:50
%        [J,grad]=lrCostFunction(initial_theta,X_final,y_final,lambda);
%        initial_theta=grad+initial_theta;
%        fprintf('Cost Fuction J is %u at %u iteration',J,iter);
%    end
%    all_theta(c,:)=initial_theta;
%    initial_theta=initial_theta*0;
%    linec=linec*0; 
%     end
    end
end

