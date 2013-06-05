function imgpotential=locationpotencial(row,col,classnum,segs,alpha,weight,normalsize,iter,resultname);

if iter==1
    load normalposition
    subrow=floor(row/normalsize);
    subcol=floor(col/normalsize);

    pixelinregion=subrow*subcol;
% potential=ones(normalsize)*pixelinregion;
    imgpotential=zeros(max(max(segs)),classnum);
    layerpotential=zeros(row,col,classnum);
% for iter=1:classnum
    
    layer=normalposition;
    potential=((layer+alpha)/(pixelinregion+alpha)).^weight;
     
    template_row=repmat(1:normalsize,subrow,1);
    template_row=template_row(:);
    
    template_col=repmat(1:normalsize,subcol,1);
    template_col=template_col(:);
    
    layerpotential=potential([template_row;template_row(end)*ones((row-subrow*normalsize),1)],[template_col;template_col(end)*ones((col-subcol*normalsize),1)],:);
%     for subiter=1:max(max(segs))
%         layerpotential=layerpotential(:);
%         imgpotential(subiter,iter)=mean(layerpotential(segs==subiter));
%     end
%     imgpotential(:,iter)=layerpotential(:);
% end
    save('pixellevelposition','layerpotential');
else 
    load('pixellevelposition');
end

if isempty(strfind(ls('Position'),resultname))
    layerpotential=reshape(layerpotential,row*col,classnum);
    for subiter=1:max(max(segs))
%         layerpotential=reshape(layerpotential,row*col,classnum);
        imgpotential(subiter,:)=mean(layerpotential(segs==subiter,:),1);
    end
    save(['Position/',resultname],'imgpotential');
else
    load(['Position/',resultname]);
end
end