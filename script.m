addpath('/home/paprika/Desktop/project/feature');
addpath('/home/paprika/Desktop/project/ultility');
addpath('/home/paprika/Desktop/project/boosting');
addpath('/home/paprika/Desktop/project/inference');
addpath('/home/paprika/Desktop/project/multilogistic');
addpath('/home/paprika/Desktop/project/extern/GCmex2.0');

splitratio=4/5; % The ratio of dividing our data
choose=[1 2 3]; % 1 2 3 represnt the training, validation and test set
classnumber=11; % The number of classes we have
emiternumber=2; % The number of iteration in color
boostiternumber=300; % Booting classifer itersion number
hogcellsize=4; % Cellsize of hog feature
logisticiternumber=200; % Number of iterations for multiclass_logidtic regression classifier
learingsteplambda=0.1; % Learning rate of classifier
centernumber=15; % cluster centers of our color model
paraforsuperpixel=[8 0.01]; % Superpixel parameters
sigma=1; % Filterbank size
gridsize=[5 5]; % Subsample and local feature size
filterbanksize=17; % Filter bank size
imgname='png'; % Image format
labelname='png'; % Label format
flagva=1; % Have validation or not
normalsize=60;

weaknumber=ones(1,classnumber)*boostiternumber;
save('weakclassifiernum','weaknumber');

diary printinfor
diary on
% splitdata(splitratio,imgname,labelname);
% colortoid(choose(1));colortoid(choose(2));colortoid(choose(3));
% filterbankfeature(choose(1),sigma,imgname);filterbankfeature(choose(2),sigma,imgname);filterbankfeature(choose(3),sigma,imgname);
% superpixel(choose(1),paraforsuperpixel);superpixel(choose(2),paraforsuperpixel);superpixel(choose(3),paraforsuperpixel);
% testsuperpixel(classnumber);
% boostfeature(choose(1),gridsize(1),filterbanksize,imgname); boostfeature(choose(2),gridsize(1),filterbanksize,imgname);boostfeature(choose(3),gridsize(1),filterbanksize,imgname);
% subsample(gridsize(2),choose(1));subsample(gridsize(2),choose(2));
% onevsallboost(classnumber,boostiternumber,flagva);
% fprintf('WAIT AND CHECK WEAKCLASSIFIERNUMBER\n');% by default it is weaknumber
% boostscore(classnumber,weaknumber,choose(1));boostscore(classnumber,weaknumber,choose(2));boostscore(classnumber,weaknumber,choose(3));

% hogfeature(choose(1),hogcellsize,imgname);hogfeature(choose(2),hogcellsize,imgname);hogfeature(choose(3),hogcellsize,imgname);
% unaryfea(classnumber,choose(1),labelname);unaryfea(classnumber,choose(2),labelname);unaryfea(classnumber,choose(3),labelname);
% sumpixelinregion(choose(1));sumpixelinregion(choose(2));sumpixelinregion(choose(3));
% multiclass_log_regression(classnumber,learingsteplambda,logisticiternumber,flagva);
% realtest(choose(1));realtest(choose(3));realtest(choose(2));

% locationmatrix(normalsize,classnumber);

[error paramin]=inference(classnumber,choose(2),0,normalsize);
save('parameterforcrf','paramin');
[error paramin]=inference(classnumber,choose(3),paramin,normalsize);

test_accuracy(classnumber);
diary off
