function [feature label]=collectmulti_log_data(feature,PixSum,label,id_files,fet_files,id)

for iter=1:size(fet_files,1)
     idfile=id_files(iter,1).name;
     fetfile=fet_files(iter,1).name;
     
     if iter==1
         load([id,'regionid_addhog','/',idfile]);
%          id=find(x~=0);
         label(1:PixSum(iter))=x;
         load([id,'regionfeature_addhog','/',fetfile]);
         feature(1:PixSum(iter),:)=x;
         
     else
         load([id,'regionid_addhog','/',idfile]);
         label(PixSum(iter-1)+1:PixSum(iter))=x; 
         load([id,'regionfeature_addhog','/',fetfile]);
         feature(PixSum(iter-1)+1:PixSum(iter),:)=x; 
     end 
end

end