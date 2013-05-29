function testsuperpixel(classnum)

segms=dir('superpixel/*.mat');
ids=dir('GT_Id/*.txt');
load('imgsize');
superpixelerror=zeros(size(ids,1)+1,2);
for iternum=1:size(ids,1)
    segsname=segms(iternum).name;
    idsname=ids(iternum).name;
    
    load(['superpixel/',segsname]);
    x=importdata(['GT_Id/',idsname])+1;
    
    newimg=zeros(img_size(iternum,1),img_size(iternum,2));
    
    for segment=0:max(max(segs))
        label=x(segs==segment);
        id_all=majority(label,classnum+1);
        newimg(segs==segment)=id_all;
    end
    fprintf('training image number %u finish\n',iternum);
    superpixelerror(iternum,1)=length(find(newimg~=x));
    superpixelerror(iternum,2)=img_size(iternum,1)*img_size(iternum,2);
end
superpixelerror(iternum+1,1)=sum(superpixelerror(:,1));
superpixelerror(iternum+1,2)=sum(superpixelerror(:,2));


segms=dir('Test_superpixel/*.mat');
ids=dir('Test_Id/*.txt');
load('Test_imgsize');
% classnum=8;
Test_superpixelerror=zeros(size(ids,1)+1,2);
for iternum=1:size(ids,1)
    segsname=segms(iternum).name;
    idsname=ids(iternum).name;
    
    load(['Test_superpixel/',segsname]);
    x=importdata(['Test_Id/',idsname])+1;
    
    newimg=zeros(img_size(iternum,1),img_size(iternum,2));
    
    for segment=0:max(max(segs))
        label=x(segs==segment);
        id_all=majority(label,classnum+1);
        newimg(segs==segment)=id_all;
    end
    fprintf('test image number %u finish\n',iternum);
    Test_superpixelerror(iternum,1)=length(find(newimg~=x));
    Test_superpixelerror(iternum,2)=img_size(iternum,1)*img_size(iternum,2);
end
Test_superpixelerror(iternum+1,1)=sum(Test_superpixelerror(:,1));
Test_superpixelerror(iternum+1,2)=sum(Test_superpixelerror(:,2));

allerror=[superpixelerror(end,:);Test_superpixelerror(end,:)];

save('allerror','allerror');
end
