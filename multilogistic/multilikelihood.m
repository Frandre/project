function finallikelihood=multilikelihood(feature,label,theta,num);

m = size(feature, 1);

feature = [ones(m, 1) feature];
predict=sigmoid(theta*feature');
predictlikeliood=bsxfun(@times,predict,1./sum(predict,1));

xyposition=[(cumsum(ones(m, 1)))';label'];
positionid=(xyposition(1,:)-1)*num+xyposition(2,:);
likelihood=predictlikeliood(positionid);

finallikelihood=sum(log(likelihood));
end
