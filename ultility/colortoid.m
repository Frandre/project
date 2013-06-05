function colortoid(choose)
% COLORTOID map the color ground truth to corresponding id 

fprintf('Choose the Training(1) Validation(2) Test(3) set\n');
%choose=input('Input which you want: ');

if choose==1
    direct='Train/*.pgn';
    file='Train';
    id='GT';
    sizemat='training_size';
else
    if choose==2
        direct='Validation/*.pgn';
        file='Validation';
        id='Va';
        sizemat='validation_size';
    else
        if choose==3
            direct='Test/*.pgn';
            file='Test';
            id='Test';
            sizemat='test_size';
        end
    end
end
GT_path=direct;
con=dir(GT_path);
load('ColorMap.mat'); % load color map
featurefile='_Id';
mkdir([id,featurefile]);
img_size=zeros(size(con,1),2);
for item=1:size(con,1)
    tic
    GT=con(item,1).name;
    fullpath=[file,'/',GT];
    GT_img=imread(fullpath);
    GT_len=reshape(GT_img,size(GT_img,1)*size(GT_img,2),3);
    New_Id=single(zeros(size(GT_img,1)*size(GT_img,2),1));
    
    for iter=1:length(ColorMap);
        id_num=(GT_len(:,1)==ColorMap(iter,1)&GT_len(:,3)==ColorMap(iter,3)&GT_len(:,2)==ColorMap(iter,2));
        New_Id(id_num)=iter;
    end
    toc
    
    savename=regexprep(GT,'pgn','mat');
    save([[id,featurefile],'/',savename],'New_Id');
    fprintf('%u image %s finish...\n',item,savename);
    [row,col]=size(GT_img(:,:,1)); 
    img_size(item,:)=[row,col];
end
save(sizemat,'img_size');
end