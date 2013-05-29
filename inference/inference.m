function inference(classnum,centernumber,emiternum)

test=dir('Test/*.jpg');
seman=dir('Testresult_/*.mat');
load normalposition
load Test_imgsize
addpath('/home/paprika/software/GCmex2.0');
% mexAll;
mkdir('CRFresult');
for iter=1:size(seman,1)
    imgname=test(iter,1).name;
    resultname=seman(iter,1).name;
    row=img_size(iter,1);
    col=img_size(iter,2);
    
    
    img=imread(['Test/',imgname]);
    load(['Testresult_/',resultname]);
    
%     AdjancentMatrix=uint8(zeros(row*col));
    [AdjancentMatrix edge]=produceadj(row,col,img);
    %%%%%%%%%%%%%%%%%%%%% color potential %%%%%%%%%%%%%%%%%%%%%%%%%
     [val indx]=max(x,[],2);
     first=indx;
%      color=colorpotential(img,classnum,centernumber,first,emiternum);
    %%%%%%%%%%%%%%%%%%%%% position potential %%%%%%%%%%%%%%%%%%%%%%
    imgpotential=locationpotencial(row,col);
    %%%%%%%%%%%%%%%%%%%%% classifier result %%%%%%%%%%%%%%%%%%%%%%%
    Class=first;
    
    %%%%%%%%%%%%%%%%%%%%%%%% Bulid Graph %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    SmoothnessCost=ones(classnum)-eye(classnum);
    nodePot=exp(-(x.*imgpotential.*color)./max(max(x.*imgpotential.*color))); % -min(min(x+imgpotential))+0.0001;
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
    gch=GraphCut('set',gch,reshape(first-1,row,col));
    [gch e]=GraphCut('energy', gch);
    fprintf('Current Energy is %e \n',e);
    [gch labels]=GraphCut('expand',gch);
    [gch e]=GraphCut('energy', gch);
    fprintf('Output Energy is %e \n',e);
    gch=GraphCut('close', gch);
    toc
    labels=labels+1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    save(['CRFresult/',resultname],'labels');
    fprintf('----------Image %s finish----------- %u number\n',imgname,iter); 
end
end
