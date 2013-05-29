function f=makedev(scale,orderx,ordery,pts,size)

if orderx==0
    gx=gauss1d(3*scale,0,pts(1,:),orderx);
    gy=gauss1d(scale,0,pts(2,:),ordery);
else
    gx=gauss1d(scale,0,pts(1,:),orderx);
    gy=gauss1d(3*scale,0,pts(2,:),ordery);
end
  f=normalise(reshape(gx.*gy,size,size));
return

