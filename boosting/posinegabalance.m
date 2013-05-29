function [posi nega]=posinegabalance(label,num)
% POSINEGABALANCE compare the positive and negative number of training set
%                 and balance it to the ratio you want

posi=find(label==num);
nega=find(label~=num);

ratio=length(posi)/length(nega);
if ratio<=1/5
    nega=nega(1:floor((1/ratio)/3):end);
else
    if ratio>=5
        posi=posi(1:floor(ratio/3):end);
    end
end
end