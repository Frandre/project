function [L,a,b]=rgb2lab(ori_image)
%RGB2LAB Convert an image from RGB to CIELAB
%       function [L, a, b]=rgb2lab(I)

B=double(ori_image(:,:,3));
G=double(ori_image(:,:,2));
R=double(ori_image(:,:,1));


if max(max(R))>1.0||max(max(G))>1.0||max(max(B))>1.0
  R=double(R)/255;
  G=double(G)/255;
  B=double(B)/255;
end

% Set a threshold
T = 0.008856;
[row,col]=size(R);
len=row*col;
RGB=[reshape(R,1,len);reshape(G,1,len);reshape(B,1,len)];
% RGB to XYZ
MAT=[0.412453 0.357580 0.180423;
     0.212671 0.715160 0.072169;
     0.019334 0.119193 0.950227];
XYZ=MAT*RGB;
% Normalize for D65 white point
X=XYZ(1,:)/0.950456;
Y=XYZ(2,:);
Z=XYZ(3,:)/1.088754;

XT=X>T;
YT=Y>T;
ZT=Z>T;

Y3=Y.^(1/3); 

fX=XT.*X.^(1/3)+(~XT).*(7.787.*X+16/116);
fY=YT.*Y3+(~YT).*(7.787.*Y+16/116);
fZ=ZT.*Z.^(1/3)+(~ZT).*(7.787.*Z+16/116);

L=reshape(YT.*(116*Y3-16.0)+(~YT).*(903.3*Y),row,col);
a=reshape(500*(fX-fY),row,col);
b=reshape(200*(fY-fZ),row,col);

end

