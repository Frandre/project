function multiclass_log_regression(num_labels,lambda,iternumber,flagva)
% tr1vsall trains a multiclass logistic regression classifier. X is the input
%          features and y is their labels. It returns all_theta as parameter.
 
fprintf('\nTraining Logistic Regression...\n');
errortrain=zeros(iternumber,1);
errorva=errortrain;
errortest=errortrain;
J=zeros(iternumber,1);
Jva=J;
Jtest=J;
%%%%%%%%%%%%%%%%%%%%%%%%%%load training infromation%%%%%%%%%%%%%%%%%%%%%%%%
fea_id='regionid_addhog/*.mat';
id_files=dir(fea_id);

fea_id='regionfeature_addhog/*.mat';
fet_files=dir(fea_id);
% labelcount=zeros(num_labels,1);
load('HoGPixSum');
PixSum=cumsum(PixSum);
feature=single(zeros(PixSum(end),813));
label=single(zeros(PixSum(end),1));
id='';
[feature label]=collectmulti_log_data(feature,PixSum,label,id_files,fet_files,id);
%%%%%%%%%%%%%%%%%%%%%%%%%%load validation infromation%%%%%%%%%%%%%%%%%%%%%
if flagva
    fea_id='Va_regionid/*.mat';
    id_files=dir(fea_id);

    fea_id='Va_regionfeature/*.mat';
    fet_files=dir(fea_id);
    load('Va_PixSum');
    PixSum=cumsum(PixSum);
    Vafeature=single(zeros(PixSum(end),1677));
    Valabel=single(zeros(PixSum(end),1));
    id='Va_';
    [Vafeature Valabel]=collectmulti_log_data(Vafeature,PixSum,Valabel,id_files,fet_files,id);
    idavailable=find(label~=0);
else
    Vafeature=feature(1:5:end,:);
    Valabel=label(1:5:end);
    feature=feature(setdiff(1:length(feature),1:5:length(feature)),:);
    label=label(setdiff(1:length(label),1:5:length(label)));
    idavailable=find(label~=0);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%load test infromation%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fea_id='Test_regionid_addhog/*.mat';
id_files=dir(fea_id);

fea_id='Test_regionfeature_addhog/*.mat';
fet_files=dir(fea_id);
load('Test_HoGPixSum');
PixSum=cumsum(PixSum);
Testfeature=single(zeros(PixSum(end),813));
Testlabel=single(zeros(PixSum(end),1));
id='Test_';
[Testfeature Testlabel]=collectmulti_log_data(Testfeature,PixSum,Testlabel,id_files,fet_files,id);
Testidavailable=find(Testlabel~=0);
clear idfile id_files PixSum id
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FINISH
for iter=1:num_labels
    labelcount(iter)=length(find(label==iter));
end
save('LabelNum','labelcount');
[countnum indx]=sort(labelcount);
indxnum=indx(ceil(num_labels/2));
%tr_size=size(trainfet,1);
%fulltrain=1:PIxelSum(iter);
figure;
% load Theta_addhog;
for iter=1:iternumber
    if iter==1
        theta=NaN;
        theta=oneVsother(feature(idavailable,:),label(idavailable),num_labels,lambda,indxnum,theta);
    else
        theta=oneVsother(feature(idavailable,:),label(idavailable),num_labels,lambda,indxnum,theta);
    end
    
    J(iter)=multilikelihood(feature(idavailable,:),label(idavailable),theta,num_labels);
    Jva(iter)=multilikelihood(Vafeature,Valabel,theta,num_labels);
    Jtest(iter)=multilikelihood(Testfeature(Testidavailable,:),Testlabel(Testidavailable),theta,num_labels);
%     
    predlabel=predictmulticlass_log_regression(theta,feature,0);
    predValabel=predictmulticlass_log_regression(theta,Vafeature,0);
    predTestlabel=predictmulticlass_log_regression(theta,Testfeature,0);
    
    errortrain(iter)=length(find(predlabel~=label))/length(label>0);
    errorva(iter)=length(find(predValabel~=Valabel))/length(Valabel>0);
    errortest(iter)=length(find(predTestlabel~=Testlabel))/length(Testlabel>0);
    
end

    plot(errortrain);
    hold on; plot(errorva,'-r');
    hold on; plot(errortest,'-y');
    hold on; plot(J,'-b');
    
save('errortrain_addhog','errortrain');
save('errortest_addhog','errortest');
save('errorva_addhog','errorva');
save('loglikelihood_addhog','J'); 
save('valoglikelihood_addhog','Jva'); 
save('testloglikelihood_addhog','Jtest'); 
save('Theta_addhog','theta');    
end


