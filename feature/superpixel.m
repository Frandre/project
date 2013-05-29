function superpixel(choose,para)
% SUPERPIXEL generate superpixels for each image. Those superpixels are
%            treated as 'regions' for further use, that is, we collect
%            region feature on that.

run('/home/paprika/Desktop/project/extern/vlfeat-0.9.16/toolbox/vl_setup');
addpath('/home/paprika/Desktop/project/extern/superpixels64');

fprintf('Choose the Training(1) Validation(2) Test(3) set\n');
%choose=input('Input which you want: ');

if choose==1
    direct='Train/*.jpg';
    file='Train';
    id='';
    sizemat='imgsize';
else
    if choose==2
        direct='Validation/*.jpg';
        file='Validation';
        id='Va_';
        sizemat='validation_size';
    else
        if choose==3
            direct='Test/*.jpg';
            file='Test';
            id='Test_';
            sizemat='Test_imgsize';
        end
    end
end

img_files=dir(direct);
mkdir([id,'superpixel']);
for sample_num=1:size(img_files,1); 
     filename=img_files(sample_num,1).name;
     imgfiles=[file,'/',filename];
     im=imread(imgfiles);
     im=im2single(im);
     segs=vl_slic(im,para(1),para(2));
     im_segs=segImage(im2double(im),double(segs));
%       if mod(ceil(sample_num/2),30)==2
%           figure;
%           imshow(im_segs);
%       end
    fprintf('We have %u segment at the %s image\n',max(max(segs)),filename);
     savename=regexprep(filename,'jpg','mat');
     save([id,'superpixel','/',savename],'segs');
end
end
