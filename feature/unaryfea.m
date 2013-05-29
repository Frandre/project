function unaryfea(classnum,choose,name)
% unaryfea returns the number of possible matches between semantic and
%          geometric labels. And we can get final region feature for
%          training our logistic regression classifier.
fprintf('Choose the Training(1) Validation(2) Test(3) set\n');
%choose=input('Input which you want: ');
%classnum=8;
if choose==1
    direct='GT_Id';
    id='';
    sizemat='imgsize';
else
    if choose==2
        direct='Va_Id';
        id='Va_';
        sizemat='validation_size';
    else
        if choose==3
            direct='Test_Id';
            id='Test_';
            sizemat='Test_imgsize';
        end
    end
end
raw_fea=[id,'rawfeature/*.mat'];
img_files=dir(raw_fea);

bst_fea=[id,'bstscore/*.mat'];
bst_files=dir(bst_fea);

lab_files=dir([direct,'/*.',name]);
hog_file=dir([id,'hogfeature/*.mat']);

reg_dir=[id,'superpixel/*.mat'];
reg_files=dir(reg_dir);
idfoldername=[id,'regionid_addhog'];
featurefoldername=[id,'regionfeature_addhog'];

mkdir(idfoldername);
mkdir(featurefoldername);

img_size=importdata([sizemat,'.mat']);
horizon_name=importdata('horizons.txt');
hori=importdata('horizons.txt');
inputnum=size(img_files,1);
matlabpool(3)
parfor sample_num=1:inputnum
   
     feafile=img_files(sample_num,1).name;
     
     bstfile=bst_files(sample_num,1).name;
     bstsc=importdata([id,'bstscore','/',bstfile]);
     imlen=importdata([id,'rawfeature','/',feafile]);
%=========================================================================%
     
     lafile=lab_files(sample_num,1).name;
     refile=reg_files(sample_num,1).name;
     segs=importdata([id,'superpixel','/',refile]);
     New_Id=importdata([direct,'/',lafile]);
     if min(New_Id)==-1
         New_Id=New_Id+1;
     end
     %%%%%%%%%%%%%%%%%%%%%%% HoG Feature%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     hog=importdata([id,'hogfeature','/',refile]);
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      hori_name=regexprep(feafile,'.mat','');
%      hori_id=strfind(horizon_name,hori_name);
%      for check=1:length(horizon_name)
%          if ~isempty(hori_id{check})
%              break;
%          end
%      end
%=========================================================================%     
%      len=img_size(exactInd,1)*img_size(exactInd,2);
     fprintf('Processing %u image start\n',sample_num);
     tic
     [re_fet,re_id]=regionfeature([imlen,bstsc],hori(1),img_size(sample_num,:),segs(:),New_Id,hog,classnum,sample_num);
     toc
     parsave([featurefoldername,'/',refile],re_fet);
     parsave([idfoldername,'/',refile],re_id);    
end
matlabpool close
% end

