function hogfeature(choose,cellSize,name)
% % HOGFEATURE captures the oriented histogram of image cell

run('/home/paprika/Desktop/project/extern/vlfeat-0.9.16/toolbox/vl_setup');

fprintf('Choose the Training(1) Validation(2) Test(3) set\n');
%choose=input('Input which you want: ');

if choose==1
    direct=['Train/*.',name];
    file='Train';
    id='';
    sizemat='imgsize';
else
    if choose==2
        direct=['Validation/*.',name];
        file='Validation';
        id='Va_';
        sizemat='validation_size';
    else
        if choose==3
            direct=['Test/*.',name];
            file='Test';
            id='Test_';
            sizemat='Test_imgsize';
        end
    end
end

img_files=dir(direct);
mkdir([id,'hogfeature']);
%cellSize=4;
for sample_num=1:size(img_files,1); 
     filename=img_files(sample_num,1).name;
     imgfiles=[file,'/',filename];
     im=imread(imgfiles);
     im=im2single(im);
     hog=vl_hog(im,cellSize,'verbose');
     
     savename=regexprep(filename,name,'mat');
     save([id,'hogfeature','/',savename],'hog');
     if mod(sample_num,100)==0
         imhog=vl_hog('render',hog,'verbose');
         figure; 
         imagesc(imhog);
         colormap gray;
     end
end
end
