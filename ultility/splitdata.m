function splitdata(ratio,imgname,labelname)
img_dir=dir('iccv09Data/images/*.',imgname);
GT_dir=dir('iccv09Data/labels/*.',labelname);

selectnum=randperm(size(img_dir,1));
mkdir('Train');
mkdir('GT_Id');
mkdir('Test');
mkdir('Test_Id');
for iter=1:size(img_dir,1)
    imgname=img_dir(iter,1).name;
    GTname=GT_dir((iter-1)*3+2,1).name;
    if sum(ismember(iter,selectnum(1:size(img_dir,1)*ratio)))        
        copyfile(['iccv09Data/images/',imgname],'Train');
        copyfile(['iccv09Data/labels/',GTname],'GT_Id');
        fprintf('Image %s for training set\n',imgname);
    else
        copyfile(['iccv09Data/images/',imgname],'Test');
        copyfile(['iccv09Data/labels/',GTname],'Test_Id');
        fprintf('Image %s for test set\n',imgname);
    end
end

end
