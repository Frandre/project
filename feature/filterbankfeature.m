function filterbankfeature(choose,sigma,imgname)
% imgfeature extract features in each pixel that generated from 17 filters. They are Gaussian Filter of 3 
% differents scales in L,a,b channels, x and y derivative of Gaussian of 2 scales in L channel and 
%            Laplacian of Guanssian of 4 scales in L channel. Finally, we save the image feature
%            in a matrix, each row represents the feature. THe number of the column is the number of
%            pixels in each image

fprintf('Choose the Training(1) Validation(2) Test(3) set\n');
%choose=input('Input which you want: ');

if choose==1
    direct='Train';
    id='';
else
    if choose==2
        direct='Validation';
        id='Va_';
    else
        if choose==3
            direct='Test';
            id='Test_';
        end
    end
end

img_files=dir([direct,'/*.',imgname]);
mkdir([id,'rawfeature']);
Fil=Mfilterbank(sigma);
Dim=size(Fil,1);
for sample_num=1:size(img_files,1) 
    filename=img_files(sample_num,1).name;
    imfile=[direct,'/',filename];
    imgdata=imread(imfile);
    [row,col,layer]=size(imgdata);
    [L,a,b]=rgb2lab(imgdata);% From RGB To LAB
% %     figure;
% %     subplot(1,2,1); imshow(L);
% %     subplot(1,2,2); imshow(imgdata);

    imgfet=zeros(row,col,17);
    for num=1:Dim
        if num<=3
            imgfet(:,:,(num-1)*3+1)=conv2(L,Fil{num},'same');
            imgfet(:,:,(num-1)*3+2)=conv2(a,Fil{num},'same');
            imgfet(:,:,(num-1)*3+3)=conv2(b,Fil{num},'same');
        else imgfet(:,:,num+6)=conv2(L,Fil{num},'same');
        end
    end
    
    len=row*col;
    imlen=reshape(imgfet,len,[]);
    path_fet=regexprep(filename,imgname,'mat');
    save([[id,'rawfeature'],'/',path_fet],'imlen');
    fprintf('feature image %u, name %s saved\n',sample_num,filename);
    img_size(sample_num,:)=[row col];
end
    save([id,'imgsize'],'img_size');% Save image size information 
end

