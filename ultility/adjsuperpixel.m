function adjancentMatrix=adjsuperpixel(image,segs,weight1,weight2,resultname)
% % ADJSUPERPIXEL build an adjecent matrix for superpixels given image size
%                 and region infromation

fprintf('Building Adjacent Map...\n');
if isempty(strfind(ls('AdjMatrix'),resultname))
    biimage=zeros(size(segs));
    se=strel('diamond',1);
    colorval=zeros(max(max(segs)),3);
    matrix=cell(size(colorval,1),1);
% adjancentMatrix=single(zeros(max(max(segs))));
    for iter=1:max(max(segs))
        idset=find(segs==iter);
         colorval(iter,:)=mean(image(idset,:));
%     segs(idset)=1;
         biimage(idset)=1;
         idmember=unique(segs(setdiff(find(imdilate(biimage,se)==1),idset)));
         if length(idmember)>4
             countnumber=histc(segs(segs(imdilate(biimage,se)==1)~=iter),idmember);
             [ordercount countnumber]=sort(countnumber,'descend');
             idmember=idmember(countnumber(1:4));
         end
         idi=ones(length(idmember),1)*double(iter);
         idj=idmember;
         matrix{iter}=[idi,idj];
         biimage=biimage*0;
    end
    matrix=double(cell2mat(matrix));
    beta=1/(2*sum(sum(colorval(matrix,:).^2,2),1)/length(matrix));
    val=exp(-sum((colorval(matrix(:,1),:)-colorval(matrix(:,2),:)).^2,2)*beta);
    val=weight1*val+weight2;

% linearind=sub2ind(size(adjancentMatrix),matrix(:,1),matrix(:,2));
% linearind_symm=sub2ind(size(adjancentMatrix),matrix(:,2),matrix(:,1));
% 
    adjancentMatrix=sparse([matrix(:,1),matrix(:,2)],[matrix(:,2),matrix(:,1)],[val,val],size(colorval,1),size(colorval,1),2*size(matrix,1));
    save(['AdjMatrix/',resultname],'adjancentMatrix');
% linearind=sub2ind(size(adjancentMatrix),matrix(:,1),matrix(:,2));
% adjancentMatrix(linearind)=val;
% linearind=sub2ind(size(adjancentMatrix),matrix(:,2),matrix(:,1));
% adjancentMatrix(linearind)=val;
% adjmatrix=zeros(size(max(max(segs)));
% adjancentMatrix=reshape(adjancentMatrix,max(max(segs)),[]);
else
    load(['AdjMatrix/',resultname]);
end

                 
