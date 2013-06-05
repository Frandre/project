function error=pieceinference(re, set,classnum,normalsize,infer,seman,alpha,weight,validation);
load([re,'imgsize']);
error=zeros(length(validation),1);
count=0;
for iter=validation
    count=count+1;
    imgname=infer(iter,1).name;
    resultname=seman(iter,1).name;
    row=img_size(iter,1);
    col=img_size(iter,2);
    segs=importdata([re,'superpixel/',resultname]);
    
    img=imread([set,'/',imgname]);
    load([re,'result/',resultname]);
    load([re,'Id/',resultname]);
    %%%%%%%%%%%%%%%%%%%%% color potential %%%%%%%%%%%%%%%%%%%%%%%%%
     [val indx]=max(x,[],2);
     first=indx;
%      color=colorpotential(img,classnum,centernumber,first,emiternum);
    %%%%%%%%%%%%%%%%%%%%% position potential %%%%%%%%%%%%%%%%%%%%%%
    imgpotential=locationpotencial(row,col,classnum,segs,alpha,weight,normalsize,iter,resultname);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    [garb labels]=max(exp(-(x.*imgpotential)./max(max(x.*imgpotential))),[],2);
    reallabel=region2pixel(labels,segs);
    error(count)=sum(New_Id(:)~=reallabel(:))/length(New_Id(:));
    fprintf('----------Image %s finish----------- %u number\n',imgname,iter);
end
error=mean(error);
end