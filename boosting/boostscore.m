function boostscore(num,choose)
% bstscore returns the score of each one-vs-all boosting classifier and take it 
%          as part of the appearance feature for region information. The final 
%          result is a N*(number of classes) matrix for each image

fprintf('Choose the Training(1) Validation(2) Test(3) set\n');
% choose=input('Input which you want: ');

if choose==1
    id='';
    sizemat='imgsize';
    featurefile='bstfeature';
else
    if choose==2
        id='Va_';
        sizemat='validation_size';
        featurefile='Va_bstfeature';
    else
        if choose==3
            id='Test_';
            sizemat='Test_imgsize';
            featurefile='Test_bstfeature';
        end
    end
end
load(sizemat);
row=img_size(:,1);
col=img_size(:,2);
% num=8;

img_dir=[featurefile,'/','*.mat'];
img_files=dir(img_dir);
load('weakclassifiernum');
mkdir([id,'bstscore']);
for sample_num=1:size(img_files,1)
           fprintf('The %u image is processing...\n',sample_num);
           filename=img_files(sample_num,1).name;
           load([featurefile,'/',filename]);
           fet=re_fet';
           bstsc=zeros(row(sample_num)*col(sample_num),num);
         
           for iter=1:num
               load([num2str(iter),'classifier']);
              [Cx Fx]=strongGentleClassifier(fet,bstClass,weakclassifiernum(iter));
%             finalFx=sigmoid(Fx);
              bstsc(:,iter)=Fx';
           end
         save([[id,'bstscore'],'/',filename],'bstsc');
 end
%  end
%  csvwrite('bst_sc.dat',cell2mat(bst_sc));
end
