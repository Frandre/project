function color=colorpotential(img,classnum,centernumber,first,emiternum);

labimg=zeros(size(img,1),size(img,2),size(img,3));
[labimg(:,:,1),labimg(:,:,2),labimg(:,:,3)]=rgb2lab(img);

kmeansdata=(reshape(labimg,3,[]))';
[mean_fea,cov_fea,kemans_norm]=whitening(kmeansdata);
alpha=0.1;
weight=3;
%%%%%%%%%%%%%%%%%%%%% Kmeans to find cluster centers%%%%%%%%%%%%%%%%%%%%%%%
opts = statset('Display','final');
[index,center]=kmeans(kemans_norm,centernumber,'MaxIter',600,'replicates',5,'Options',opts);
M=zeros(centernumber,3); % Clster mean
V=zeros(3,3,centernumber); % Cluster variance
prodatatpcenter=zeros(length(kmeansdata),centernumber); % Probability of each pixel belongs to one cluster
for iter=1:centernumber
    M(iter,:)=mean(kmeansdata(index==iter,:));
    V(:,:,iter)=cov(kmeansdata(index==iter,:));
    prodatatpcenter(:,iter)=Gaus(M(iter,:),V(:,:,iter),kmeansdata);
end
%%%%%%%%%%%%%%%%%%%%% compute potentials %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
consp=1/centernumber;
normalp=prodatatpcenter*consp;
procentertodata=bsxfun(@times,normalp,1./sum(normalp,2));
colorpara=zeros(classnum,centernumber); 
     %%%%%%%%%%%%%%%%%%%%%% EM updating %%%%%%%%%%%%%%%%%%
for emiter=1:emiternum     
     for classiter=1:classnum
         clusterk=sum(procentertodata,1);
         freqclassincluster=sum(procentertodata(first==classiter,:),1);
         colorpara(classiter,:)=((freqclassincluster+alpha)./(clusterk+alpha)).^weight;
     end
     color=procentertodata*colorpara';
     [val first]=max(color,[],2);
end
end