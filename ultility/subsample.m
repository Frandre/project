function subsample(subrate,name)

fea='bstfeature/*.mat';
feadir=dir(fea);
load('imgsize');
id=['GT_Id/*.',name];
iddir=dir(id);
bst=cell(1,size(feadir,1));
for sample=1:size(feadir,1)
    tic
    idname=iddir(sample,1).name;
    feaname=feadir(sample,1).name;
    load(['bstfeature','/',feaname]);
    New_Id=load(['GT_Id','/',idname]);
    if min(min(New_Id))==-1
        New_Id=New_Id+1;
    end
    
    All_poss_id=find(mod(mod(1:img_size(sample,1)*img_size(sample,2),img_size(sample,1)),subrate)==0);
    final_id=All_poss_id(find(mod(ceil(All_poss_id/img_size(sample,1)),subrate)==0));
    
    final_id=final_id(New_Id(final_id)>0);
    
    New_Id=New_Id(final_id);
    re_fet=re_fet(final_id,:);
    
%     Label=(New_Id(1:25:end))';
%     Feature=(re_fet(1:25:end,:))'; 
    
    bst{sample}=[New_Id(1:7:end); (re_fet(1:7:end,:))'];
    fprintf('image %u finish',sample);
    toc
end
bstfeature=cell2mat(bst);
save('bstfeature','bstfeature','-v7.3');
end