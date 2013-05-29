function realtest

testdir=dir('Test_regionfeature_addhog/*.mat');
testsuperpixel=dir('Test_superpixel/*mat');

hori=importdata('horizons.txt');
mkdir('Testresult_');
img_size=importdata('Test_imgsize.mat');
theta=importdata('Theta.mat');

sizenum=size(testdir,1);
for sample_num=1:sizenum       
      filename=testdir(sample_num,1).name;
      superpixel=testsuperpixel(sample_num,1).name;
      x=importdata(['Test_regionfeature_addhog/',filename]);
      segs=importdata(['Test_superpixel/',superpixel]);
      p=predictmulticlass_log_regression(theta,x(:,1:size(theta,2)-1),1);
      final=zeros(img_size(sample_num,1)*img_size(sample_num,2),size(theta,1));
      fprintf('Processing------ %s ------image start,number is %u \n',filename,sample_num);
      count=0;
      for regions=0:max(segs(:))
          if sum(segs(:)==regions)
              count=count+1;
              final(find(segs==regions),:)=repmat(p(count,:),length(find(segs==regions)),1);
          end
      end
      parsave(['Testresult_','/',filename],final);     
end
end
