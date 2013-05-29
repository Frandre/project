function gau=gauss1d(sigma,mean,x,order)
% Function to compute gaussian derivatives evaluated at x.

  x=x-mean;
  num=x.*x;
  variance=sigma^2;
  denom=2*variance; 
  gau=exp(-num/denom)/sqrt(pi*denom);
  if order==1
      gau=-gau.*(x/variance);
  end
return
