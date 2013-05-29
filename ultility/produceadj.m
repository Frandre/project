function [AdjancentMatrix edge]=produceadj(row,col,img);


sizemat=row*col;
% AdjancentMatrix=eye(sizemat);
img=(double(reshape(img,3,[])))';
% 
% diagid=find(AdjancentMatrix==1);
% neighbour=[-1 -row];
% 
% AdjancentMatrix(diagid(2:end)+neighbour(1))=1;
% AdjancentMatrix(diagid(2:end)-neighbour(2))=1;
% AdjancentMatrix(diagid)=0;
% 
% [indrow indcol]=ind2sub(find(AdjancentMatrix==1),[sizemat sizemat]);
% 
% perval=sum((img(indrow,:)-img(indcol,:)).^2,2);
% beta=1/(2*sum(perval));
% perval=exp(-perval*beta);
% 
% AdjancentMatrix(AdjancentMatrix==1)=45*perval+10;
countnum=2*(sizemat-1);
i=repmat(1:sizemat,2,1);
j=[i(1,:)-1;i(2,:)+1];
i=i(:);
j=j(:);
i=i(2:end-1);
j=j(2:end-1);

perval=sum((img(j,:)-img(i,:)).^2,2);
beta=1/(2*sum(perval)/length(perval));
perval=exp(-perval*beta);

edge=45*perval+10;
s=ones(countnum,1);
AdjancentMatrix=sparse(j,i,s,sizemat,sizemat,countnum);
end