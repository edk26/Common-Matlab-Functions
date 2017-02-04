function [m, b, rsq ] = stath_linear_fit (x,y)


p=polyfit(x,y,1);
yfit=polyval(p,x);
yresid=y-yfit;
SSresid=sum(yresid.^2);
SStotal=(length(y)-1)*var(y);

rsq=1-SSresid/SStotal;
m=p(1);
b=p(2);