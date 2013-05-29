function finalXmat=gridregion(X,row,len)

% callog is uesd to found the 24 neighbors' position of a given pixel

finalX=X(find(mod(X,row)~=0&mod(X,row)~=1&mod(X,row)~=2&mod(X,row)~=row-1&ceil(X/row)~=1&ceil(X/row)~=len&ceil(X/row)~=2&ceil(X/row)~=len-1));
%re=[-row-1,-row,-row+1,-1,1,row-1,row,row+1];
re=[-2*row-2,-2*row-1,-2*row,-2*row+1,-2*row+2,-row-2,-row-1,-row,-row+1,-row+2,-2,-1,+1,+2,row-2,row-1,row,row+1,row+2,2*row-2,2*row-1,2*row,2*row+1,2*row+2];
Xmat=finalX*ones(1,length(re));
remat=ones(length(finalX),1)*re;
finalXmat=Xmat+remat;

end

