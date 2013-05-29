function boostfeature(choose,gridsize,filterbanksize,name)

% boostfeature generate features for initial boosting. These features are generated from raw image 
%              features. We extract them by computing its gridszie^2 mean, variance. At last, we add their
%              row information. The final result is a N*finallength matrix. 

fprintf('Choose the Training(1) Validation(2) Test(3) set\n');
%choose=input('Input which you want: ');

if choose==1
    direct='rawfeature/*.mat';
    id='rawfeature';
    sizemat='imgsize';
    featurefile='bstfeature';
else
    if choose==2
        direct='Va_Id/*.mat';
        id='Va_Id';
        sizemat='validation_size';
        featurefile='Va_bstfeature';
    else
        if choose==3
            direct='Test_rawfeature/*.mat';
            id='Test_rawfeature';
            sizemat='Test_imgsize';
            featurefile='Test_bstfeature';
        end
    end
end
        
img_dir=direct;% Rawfeature dir 
img_files=dir(img_dir);
finallength=filterbanksize^2+filterbanksize*2+1;

mkdir(featurefile);
im_sample=zeros(gridsize,gridsize,filterbanksize);
da_win=zeros(gridsize^2,filterbanksize);
da_cov=zeros(1,filterbanksize^2);
da_mean=zeros(1,filterbanksize);
load(sizemat);
bstfet=cell(size(img_files,1),1);
for sample_num=1:size(img_files,1) 
    
    fprintf('Processing %u image\n',sample_num);
    
    filename=img_files(sample_num,1).name;
    imfile=[id,'/',filename];
    load(imfile);
    row=img_size(sample_num,1);
    col=img_size(sample_num,2);
    im_fin=reshape(imlen,row,col,[]);

    len=row*col;
    
    fin_fet=zeros(row,col,finallength);
    tic
%  =========================Mean and Variance In A 5*5 Patch=======================%   
    for n_row=1:row
        for n_col=1:col
            for r_step=1:gridsize
                for c_step=1:gridsize
                    if (r_step+n_row-1)<=row&&(c_step+n_col-1)<=col
                        im_sample(r_step,c_step,:)=im_fin(r_step+n_row-1,c_step+n_col-1,:);
                    else
                        im_sample(r_step,c_step,:)=im_fin(n_row,n_col,:);                
                    end                    
                end
            end
    da_win=reshape(im_sample,gridsize^2,filterbanksize);
    da_cov=reshape(cov(da_win),1,[]);
    da_mean=mean(da_win);
%   re=reshape(horzcat((squeeze(im_fin(n_row,n_col,:)))',da_cov,da_mean,n_row),1,324);
    fin_fet(n_row,n_col,:)=reshape(horzcat((squeeze(im_fin(n_row,n_col,:)))',da_cov,da_mean,n_row),1,1,finallength);    
        end
    end
    toc
    re_fet=reshape(fin_fet,len,[]);% Reshape the feature
%     bstfet{sample_num}=single(New_Id(1:25:end,:));
    filename=regexprep(filename,name,'mat');
    save([featurefile,'/',filename],'re_fet');
    
end
% bstLabel=cell2mat(bstfet);
% save('bstLabel','bstLabel');
% end

