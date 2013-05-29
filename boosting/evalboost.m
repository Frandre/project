function [score error]=evalboost(feature,th,a,b,k,initial_score,label)
% EVALBOOST evaluates the boost classifier for each iteration and returns ...
%           the score for each input feature; th is the threshold, a and b 
%           are corresponding parameters for each weakclassifier. k is the 
%           effective feature dimension

score=ones(size(initial_score));
score(1,:)=a*(feature(k,:)>th)+b;
score(2,:)=score(1,:)+initial_score(2,:);

error=length(find(sign(score(2,:))~=label))/length(label);
end