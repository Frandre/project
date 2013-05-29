function [re_fe, re_idf]=regionfeature(imgfet,horizon,imgsize,lab_layer,label,hog,numberofclass,samplenum)

% regionfeature generate final feature for all regions in one image. There are 3 parts.
%               One for image appearance information: the mean appearance, the varance, 
%               ,log of determinant in the region and the contrast in the region boundry.
%               The second is region shape, its nomarlized area, premeter, x, y moment
%               and roughly whether can fit a line in its upper and lower boudry. The last
%               one is the relative position compared with horizon in the image.   
%               Finally, we get the feauture, geometric and semantic label in each image.    

col=imgsize(2);
row=imgsize(1);
len=row*col;
norma=1/len;
re_fet=cell(length(unique(lab_layer)),1);
img_bw=zeros(row,col);
img_reinout=single(img_bw);
re_id=cell(length(unique(lab_layer)),1);
onefet=ones(1,size(imgfet,2));
i=0;
for id=0:max(lab_layer)     
    findid=find((lab_layer)==id);
    if ~isempty(findid)
        i=i+1;
        id_all=majority(label(findid),numberofclass+1);
        re_id{i}=id_all;
        img_bw(findid)=255;
        img_bdy=edge(img_bw,'canny');
        img_bi=im2bw(img_bw,1);
        targ_fet=imgfet(findid,:); 
        
%         figure;
%         subplot(1,2,1);imshow(img_bw);
%         subplot(1,2,2);imshow(img_bdy);

        re_mean=mean(targ_fet);
        re_var=cov(targ_fet);
        
        if det(re_var)==0
%             fprintf('Determinant Mistake in %u region\n',id);
            detm=det(re_var)+1;
 
%             figure;
%             subplot(1,2,1);imshow(img_bw);
%             subplot(1,2,2);imshow(img_bdy);
            
            re_lgd=log(detm);
        else
        re_lgd=log(abs(det(re_var)));
        end
        

        if ~isempty(find(img_bdy~=0, 1))
            re_pre=length(find(img_bdy~=0));
        else
            re_pre=length(findid);
%             figure;
%             subplot(1,2,1);imshow(img_bw);
%             subplot(1,2,2);imshow(img_bdy);
%           subplot(1,3,3);imshow(img_bi); 
        end
        
        re_nor=length(findid)/len;


        re_adre=gridregion(findid,row,col);
        img_reinout(re_adre)=1;
        in=find(img_reinout.*img_bi);
        out=find(img_reinout.*(~img_bi));
        if ~isempty(in)&&~isempty(out)
             in_re=sum(imgfet(in,:))/length(in);
             out_re=sum(imgfet(out,:))/length(out);
             re_contrast=in_re-out_re; 
        else
%             fprintf('Length Mistake\n');
%             figure;
%             subplot(1,2,1);imshow(img_bw);
%             subplot(1,2,2);imshow(img_bdy);
            re_contrast=zeros(1,size(imgfet,2));
        end



%         bl_hori=length(find(mod(findid,row)>ceil(horizon)));
%         re_ratio=bl_hori/length(findid);


        img_row=mod(findid,row);
        img_col=1+(findid-img_row)./row;
        re_x1mont=sum((norma*img_row*onefet).*targ_fet);
        re_y1mont=sum((norma*img_col*onefet).*targ_fet);
        re_x2mont=sum(norma*targ_fet.*((img_row.^2)*onefet));
        re_y2mont=sum(norma*targ_fet.*((img_col.^2)*onefet));



        
        if isempty(find(img_bdy~=0, 1))
            bdy_row=mod(find(img_bw~=0),row);
            bdy_col=1+(find(img_bw~=0)-bdy_row)./row;    
            img_mid=sum(bdy_row)/length(find(img_bw~=0));            
        else
            bdy_row=mod(find(img_bdy~=0),row);
            bdy_col=1+(find(img_bdy~=0)-bdy_row)./row;    
            img_mid=sum(bdy_row)/length(find(img_bdy~=0));
        end
        redab=Ransac(bdy_row,bdy_col,img_mid);
        %%%%%%%%%%%%%%%%%%%%%%% add location information %%%%%%%%%%%%%%%%%%
        findrow=mod(findid,row);
        findrow(findrow==0)=row;
        meanrow=mean(findrow);
        
        findcol=ceil(findid/row);
        meancol=mean(findcol);
        %%%%%%%%%%%%%%%%%%%%%%% add hogfeature %%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        pickrow=ceil(findrow/4);
        pickcol=ceil(findcol/4);
        
        pickrow(pickrow>size(hog,1))=size(hog,1);
        pickcol(pickcol>size(hog,2))=size(hog,2);
        pickcouple=unique([pickrow,pickcol],'rows');

        hogall=zeros(size(pickcouple,1),size(hog,3));
        for iternum=1:size(pickcouple,1)
            hogall(iternum,:)=squeeze(hog(pickcouple(iternum,1),pickcouple(iternum,2),:));
        end
        hogfea=mean(hogall);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        re_fet{i}=[re_mean,(re_var(:))',re_lgd,re_contrast,re_pre,re_nor,re_x1mont,re_y1mont,re_x2mont,re_y2mont,redab,meanrow,meancol,hogfea];
        if length(re_fet{i})~=813
            fprintf('Error in region %u of %u image \n',id,samplenum);
        end
        img_bw=0*img_bw;
        img_reinout=0*img_reinout;
    end
end
re_fe=cell2mat(re_fet);
re_idf=cell2mat(re_id);
end

