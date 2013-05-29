addpath('/home/paprika/Desktop/project/feature');
addpath('/home/paprika/Desktop/project/ultility');
addpath('/home/paprika/Desktop/project/boosting');
addpath('/home/paprika/Desktop/project/inference');
addpath('/home/paprika/Desktop/project/multilogistic');
addpath('/home/paprika/Desktop/project/extern/GCmex2.0');

splitratio=4/5; % The ratio of dividing our data
choose=[1 2 3]; % 1 2 3 represnt the training, validation and test set
classnumber=8; % The number of classes we have
emiternumber=2; % The number of iteration in color 
boostiternumber=100; % Booting classifer itersion number
hogcellsize=4; % Cellsize of hog feature
logisticiternumber=100; % Number of iterations for multiclass_logidtic regression classifier
learingsteplambda=0.1; % Learning rate of classifier
centernumber=15; % cluster centers of our color model
paraforsuperpixel=[10 0.1]; % Superpixel parameters
sigma=1; % Filterbank size
gridsize=5; % Subsample and local feature size
filterbanksize=17; % Filter bank size
imgname='jpg'; % Image format
labelname='txt'; % Label format
flagva=0; % Have validation or not

% weaknumber=ones(1,classnumber)*boostiternumber;
% save('weakclassifiernum','weaknumber');

diary printinfor
diary on
splitdata(splitratio,imgname,labelname);
filterbankfeature(choose(1),sigma,imgname);filterbankfeature(choose(3),sigma,imgname);
superpixel(choose(1),paraforsuperpixel);superpixel(choose(3),paraforsuperpixel);
testsuperpixel(classnumber);
boostfeature(choose(1),gridsize,filterbanksize,imgname);boostfeature(choose(3),gridsize,filterbanksize,imgname);
subsample(gridsize,labelname);
onevsallboost(classnumber,boostiternumber,flagva);
fprintf('WAIT AND CHECK WEAKCLASSIFIERNUMBER\n');% by default it is weaknumber 
boostscore(classnumber,choose(1));bstscore(classnumber,choose(3));

hogfeature(choose(1),hogcellsize,imgname);hogfeature(choose(3),hogcellsize,imgname);
unaryfea(classnumber,choose(1),labelname);unaryfea(classnumber,choose(3),labelname);
sumpixelinregion(choose(1));sumpixelinregion(choose(3));
multiclass_log_regression(classnumber,learingsteplambda,logisticiternumber,flagva);
realtest;
inference(classnumber,centernumber,emiternumber);
test_accuracy(classnumber);
diary off
