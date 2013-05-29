function sumpixelinregion(choose);

fprintf('Choose the Training(1) Validation(2) Test(3) set\n');
% choose=input('Input which you want: ');

if choose==1
    id='';
else
    if choose==2
        id='Va_';
    else
        if choose==3
            id='Test_';
        end
    end
end
fea_id=[id,'regionid_addhog/*.mat'];
id_files=dir(fea_id);

PixSum=zeros(1,size(id_files,1));

for iter=1:size(id_files,1)
     idfile=id_files(iter,1).name;
     
     load([id,'regionid_addhog','/',idfile]);
     PixSum(iter)=length(x); 
end
save([id,'HoGPixSum'],'PixSum');
end