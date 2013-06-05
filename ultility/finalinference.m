function error=finalinference(re, set,classnum,normalsize,infer,seman,alpha,weight,para1,para2,choose,validation);
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
    
%   AdjancentMatrix=uint8(zeros(row*col));
    AdjancentMatrix=adjsuperpixel(reshape(img,row*col,3),segs,para1,para2,resultname);

%   [AdjancentMatrix edge]=produceadj(row,col,img);
    %%%%%%%%%%%%%%%%%%%%% color potential %%%%%%%%%%%%%%%%%%%%%%%%%
     [val indx]=max(x,[],2);
     first=indx;
%      color=colorpotential(img,classnum,centernumber,first,emiternum);
    %%%%%%%%%%%%%%%%%%%%% position potential %%%%%%%%%%%%%%%%%%%%%%
    imgpotential=locationpotencial(row,col,classnum,segs,alpha,weight,normalsize,iter,resultname);
    %%%%%%%%%%%%%%%%%%%%% classifier result %%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%% Bulid Graph %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    SmoothnessCost=ones(classnum)-eye(classnum);
    nodePot=exp(-(x.*imgpotential)./max(max(x.*imgpotential))); % -min(min(x+imgpotential))+0.0001;
%     edgeStruct=UGM_makeEdgeStruct(AdjancentMatrix,classnum,1,50);
%     edgePot=repmat(edge,1,classnum*classnum);
%     edgePot(:,find(eye(classnum)==1))=edgePot(:,find(eye(classnum)==1))*0;
%     edgePot(edgePot==0)=1;
%     edgePot=reshape(edgePot',classnum,classnum,length(edge));
    %%%%%%%%%%%%%%%%%%%%%%%% Inference %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     [nodeBel,edgeBel,logZ]=UGM_Infer_ViterbiApx(nodePot,edgePot,edgeStruct,@UGM_Decode_AlphaExpansion);
    tic
%    indx=UGM_Decode_AlphaExpansion(nodePot,edgePot,edgeStruct,@UGM_Decode_GraphCut,first);
    gch=GraphCut('open',nodePot',SmoothnessCost,AdjancentMatrix);
%     gch=GraphCut('set',gch,reshape(first-1,row,col));
    gch=GraphCut('set',gch,first-1);
    [gch e]=GraphCut('energy', gch);
    fprintf('Current Energy is %e \n',e);
    [gch labels]=GraphCut('expand',gch);
    [gch e]=GraphCut('energy', gch);
    fprintf('Output Energy is %e \n',e);
    gch=GraphCut('close', gch);
    toc
    labels=labels+1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    reallabel=region2pixel(labels,segs);

    error(count)=sum(New_Id(:)~=reallabel(:))/length(New_Id(:));
    if choose==3
        save([re,'CRFresult/',resultname],'reallabel');
        fprintf('----------Image %s finish----------- %u number\n',imgname,iter); 
    end
end
error=mean(error);


end