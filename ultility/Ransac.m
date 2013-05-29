function abbl=Ransac(x,y,mid)

% Ransac returns the resudul of the line fitting

x_ab=find(x<=ceil(mid));
x_bl=find(x>=floor(mid));

mat=[x,y];
mat_ab=mat(x_ab,:);
mat_bl=mat(x_bl,:);

X_abre=[ones(size(x_ab,1),1),mat_ab(:,1)];
X_blre=[ones(size(x_bl,1),1),mat_bl(:,1)];
y_abre=zeros(length(y),1);
y_blre=y_abre;

linefit=ones(100,2);

for iter=1:100
       
    if size(mat_ab,1) <= 0
        fprintf('error\n');
        linefit=[1 1;1 1];
        break;
    end
    
    randnum=randi(size(mat_ab,1),1,20);
    xab_set=mat_ab(randnum,1);
    Xab=[ones(20,1),xab_set];
    
    if size(mat_bl,1) <= 0
        fprintf('error\n');
        linefit=[1 1;1 1];
        break;
    end
    randnum1=randi(size(mat_bl,1),1,20);
    xbl_set=mat_bl(randnum1,1);
    Xbl=[ones(20,1),xbl_set];
    
    yab_set=mat_ab(randnum,2);
    
    ybl_set=mat_bl(randnum1,2);
    
    theta_ab=pinv(Xab'*Xab)*Xab'*yab_set;
    J=computeCostMulti(Xab, yab_set,theta_ab); % Linear regression for a line
    [theta_ab,J_history]=gradientDescentMulti(Xab,yab_set,theta_ab,0.001,10);
    
    theta_bl=pinv(Xbl'*Xbl)*Xbl'*ybl_set;
    [theta_bl,J_history1]=gradientDescentMulti(Xbl,ybl_set,theta_bl,0.002,10);
    

    y_abre=X_abre*theta_ab;
    ab_red=length(find(abs(y_abre-mat_ab(:,2))>15));
    
    y_blre=X_blre*theta_bl;
    bl_red=length(find(abs(y_blre-mat_bl(:,2))>15));
    
    linefit(iter,:)=[ab_red/length(x_ab),bl_red/length(x_bl)];
end
abbl=min(linefit);% The most possible line in the upper and lower boundry result
end

