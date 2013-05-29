function onevsallboost(num,iternum,flagva)
% ONEVSALLBOOST trains a one vs all GentleBoost classifier with largest
%               iteration num and class numbers

load('bstfeature');

if min(bstfeature(1,:))==0
    bstfeature(1,:)=bstfeature(1,:)+1;
end

if flagva
    load('Va_bstfeature');
else
    Va_bstfeature=bstfeature(:,1:5:end);
    bstfeature=bstfeature(:,setdiff(1:size(bstfeature,2),1:5:size(bstfeature,2)));
end

x=bstfeature(2:end,:);
y_label=bstfeature(1,:);

diary class
diary on
for class_id=1:num
    fprintf('Class number is %u\n',class_id);
 for iter=1:iternum
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
            [posi nega]=posinegabalance(Va_bstfeature(1,:),class_id);
            
            Va_m=[Va_bstfeature(2:end,nega),Va_bstfeature(2:end,posi)];
            va_y=ones(1,length(posi)+length(nega));
            va_y(1:length(nega))=-1;
            
            [Nfeatures, Nsamples] = size(xm); % Nsamples = Number of thresholds that we will consider
            
            w=ones(1,Nsamples);
            Fxm=zeros(2, Nsamples);
            Fx_va=zeros(2,size(Va_m,2));
            end
           
            
            [k, th, a , b] = selectBestRegressionStump(xm,y,w);
      
            % update parameters classifier
            classifier(iter).featureNdx = k;
            classifier(iter).th = th;
            classifier(iter).a = a;
            classifier(iter).b = b;
            
            
            [Fx_va va_error(iter)]=evalboost(Va_m,th,a,b,k,Fx_va,va_y);
            [Fxm error_rate(iter)]=evalboost(xm,th,a,b,k,Fxm,y);
            fprintf('======Error is %e in training and %e in validation in iteration %u\n',error_rate(iter),va_error(iter),iter);
            % Reweight training samples
            w=w.*exp(-y.*Fxm(1,:));            
            w=w./sum(w);
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find when to stop %%%%%%%%%%%%%%%%%%%%%%%%%%%            
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
            
%             if iter>60
%                 if (1/5*sum(va_error(iter-4:iter))<va_error(iter))&&(1/5*sum(error_rate(iter-4:iter))>error_rate(iter))
%                 break;
%                 end               
%             end
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
figure;
plot(va_error(1:iter)); hold on; plot(error_rate(1:iter),'-y');
save([num2str(class_id),'classifier'],'bstClass');
save([num2str(class_id),'clserror'],'error');
end
diary off
end
