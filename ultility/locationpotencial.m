function imgpotential=locationpotencial(row,col)


load normalposition
normalsize=80;
classnum=8;
alpha=1;
weight=0.1;

subrow=floor(row/normalsize);
subcol=floor(col/normalsize);

pixelinregion=subrow*subcol;
potential=ones(normalsize)*pixelinregion;
imgpotential=zeros(row*col,classnum);
layerpotential=zeros(row*col,1);
for iter=1:classnum
    layer=normalposition(:,:,iter);
    potential=((layer+alpha)/(pixelinregion+alpha)).^weight;
     
    template_row=repmat(1:normalsize,subrow,1);
    template_row=template_row(:);
    
    template_col=repmat(1:normalsize,subcol,1);
    template_col=template_col(:);
    
    layerpotential=potential([template_row;template_row(end)*ones((row-subrow*normalsize),1)],[template_col;template_col(end)*ones((col-subcol*normalsize),1)]);
    imgpotential(:,iter)=layerpotential(:);
end
end