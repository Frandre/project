function binaryboost(num,iternum,testfile,validationfile,subsamplerate,startclass)
% MULTICLASS_BOOST trains a binart boost classifier. Num is the number of classes and iternum is 
%                  the maximim iteration number we set. Testfile and Validationfile are two mat 
%                  files. The first one row is label and the last rows are features. subsample 
%                  rate.  
num=8;
iternum=700;
testfile='bstfeature';
subsamplerate=5;
validationfile='bstfeature';
startclass=0;

load(testfile);
load(validationfile);

Va_bstfeature=bstfeature(2:end,1:subsamplerate:end);
if startclass
   va_y=bstfeature(1,1:subsamplerate:end)+1;
else
   va_y=bstfeature(1,1:subsamplerate:end);
end

stediffnum=setdiff(1:length(bstfeature),1:subsamplerate:length(bstfeature));
x=bstfeature(2:end,stediffnum);
if startclass
   y_label=bstfeature(1,stediffnum)+1;
else
   y_label=bstfeature(1,stediffnum);
end

% diary cv
% diary on
for class_id=1:num
    fprintf('Class number is %u\n',class_id);
 for iter=1:iternum
%     if iter==1
%         tic
%        for class_id=selectnum
           if iter==1            
            ClassAll=cell(1,iternum);
            com_va=zeros(1,iternum-1);
            com_train=zeros(1,iternum-1);
            va_error=zeros(1,iternum);
            error_rate=va_error;          
           %%%%% balance the positive and negative training number  
            [posi nega]=posinegabalance(y_label,class_id);
    
            xm=[x(:,nega),x(:,posi)];
            y=ones(1,length(posi)+length(nega));
            y(1:length(nega))=-1;
            %%%% balance the positive and negative in validation set             
            [posi nega]=posinegabalance(va_y,class_id);
            
            Va_m=[Va_bstfeature(:,nega),Va_bstfeature(:,posi)];
            va_y=ones(1,length(posi)+length(nega));
            va_y(1:length(nega))=-1;
            Fx_va=zeros(2,size(Va_m,2));
            
            [Nfeatures, Nsamples] = size(xm); % Nsamples = Number of thresholds that we will consider
            
            w=ones(1,Nsamples);
            Fxm=zeros(2, Nsamples);
            end
           
            
            [k, th, a , b] = selectBestRegressionStump(xm,y,w);
      
            % update parameters classifier
            classifier(iter).featureNdx = k;
            classifier(iter).th = th;
            classifier(iter).a = a;
            classifier(iter).b = b;
            
            
            Fx_va(1,:)=a*(Va_m(k,:)>th)+b;
            Fx_va(2,:)=Fx_va(1,:)+Fx_va(2,:);
            va_error(iter)=length(find(sign(Fx_va(2,:))~=va_y))/length(va_y);
    
            % Updating and computing classifier output on training samples
            Fxm(1,:)=a * (xm(k,:)>th) + b;
            Fxm(2,:)=Fxm(1,:)+Fxm(2,:);
            Cxm=sign(Fxm(2,:));
            error_rate(iter)=length(find(Cxm~=y))/length(y);
            fprintf('======Error is %e in training and %e in validation in iteration %u\n',error_rate(iter),va_error(iter),iter);
            % Reweight training samples
            w=w.*exp(-y.*Fxm(1,:));            
            w=w./sum(w);
            
            ClassAll{iter}=classifier(iter);
%             toc
            if iter>=2
                com_va(iter-1)=va_error(iter)-va_error(iter-1);
                com_train(iter-1)=error_rate(iter)-error_rate(iter-1);
                if com_va(iter-1)<0
                    fprintf('Validation Decrease\n');
                end
                if com_train(iter-1)<0
                    fprintf('Training Decrease\n');
                end
            end           
            
             if iter>300
                 if (1/5*sum(va_error(iter-4:iter))<va_error(iter))&&(1/5*sum(error_rate(iter-4:iter))>error_rate(iter))
                 break;
                 end               
             end
 end
fprintf('>>>>>>>>Finish boosting at %u iteration<<<<<<<<<<<\n',iter);
 if iter~=iternum
     bstClass=cell(1,iter-1);
     for count=1:iter-1
         bstClass{count}=ClassAll{count};
     end
 else
     bstClass=ClassAll;
end
error=[va_error(1:iter);error_rate(1:iter)];
figure;plot(error(1,:)); hold on; plot(error(2,:),'-r');

save([num2str(class_id),'classifier'],'bstClass');
save([num2str(class_id),'clserror'],'error');
end
% diary off
%end

