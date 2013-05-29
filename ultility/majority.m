function id_all=majority(label,num)
% % MAJORITY count all pixel labels in a superpixel region and pick up the
%            one that take the majority in it . Label is a vector that
%            represent the label inside the region and num is the number of
%            classes. Start from 0-N. 0 represnts the NULL class

label_count=zeros(num,1);
for iter=1:num
    label_count(iter)=length(find(label==iter-1));
end
[new_count order]=sort(label_count,'descend');

id_all=order(1)-1;
end