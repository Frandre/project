function locationmatrix
% % LOCATIONPOTENTIAL goes through the training set and capture the
% dependence of image labels and and their locations.

load imgsize;
gtdir=dir('GT_Id/*.txt');
normalsize=80;
classnum=8;

normalposition=zeros(normalsize,normalsize,classnum);
countposition=normalposition;
for num=1:size(gtdir,1)
    gtname=gtdir(num,1).name; 
    label=importdata(['GT_Id/',gtname])+1;
    row=img_size(num,1);
    col=img_size(num,2);
    
    subrow=floor(row/normalsize);  
    subcol=floor(col/normalsize);
    preimg=zeros(row,col);
    
    for iter=1:classnum
        preimg=preimg*0;
        if isempty(find(label==iter, 1))
            continue;
        else
            preimg(find(label==iter))=1;
            preimg=cumsum(cumsum(preimg,2),1);
        
            step1id=find(mod(mod(1:row*col,row),subrow)==0);
            picknum_lr=step1id(mod(ceil(step1id/row),subcol)==0);
        
            picknum_ul=picknum_lr-subcol*row-subrow;            
            picknum_ur=picknum_lr-subrow;
            picknum_le=picknum_ul+subrow;
            picknum_ul(picknum_ul<=0)=1;
            picknum_ul(mod(picknum_ul,row)==0)=picknum_ul(mod(picknum_ul,row)==0)+1;
            picknum_ur(picknum_ur<=0)=1;
            picknum_ur(mod(picknum_ur,row)==0)=picknum_ur(mod(picknum_ur,row)==0)+1;
            picknum_le(picknum_le<=0)=1;
%             picknum_le(mod(picknum_le,row)==0)=picknum_le(mod(picknum_le,row)==0)+1;
            result=preimg(picknum_lr(1:normalsize^2))+preimg(picknum_ul(1:normalsize^2))-preimg(picknum_le(1:normalsize^2))-preimg(picknum_ur(1:normalsize^2));
            if isempty(result<0)||isempty(result>subrow*subcol)
                fprintf('error\n');
            end
            countposition(:,:,iter)=reshape(result,normalsize,[]);
        end
    end
fprintf('Image number %u finish \n',num);    
normalposition=countposition+normalposition;
countposition=countposition*0;
end
save('normalposition','normalposition');
end