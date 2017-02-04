function [p, tval] = ttest_sk (x, tail,dim)

%Call -
%   [p, tval] = ttest_sk (x, tail,dim)
%Inputs - 
%   x - data
%   tail - 1 = one tail R
%          2 = one tail L
%          3 = two tail

m=0;
%dim=1;
nans = isnan(x);
if any(nans(:))
    samplesize = sum(~nans,dim);
else
    samplesize = size(x,dim); % a scalar, => a scalar call to tinv
end
df = max(samplesize - 1,0);
xmean = nanmean(x,dim);
sdpop = nanstd(x,[],dim);
ser = sdpop ./ sqrt(samplesize);
tval = (xmean - m) ./ ser;

if tail ==2
    p = tcdf(-tval, df);%Rt 1 tail
elseif tail ==1
    p = tcdf(tval, df);%Lt 1 tail
elseif tail ==3
    p = 2 * tcdf(-abs(tval), df);%2 tail
end

end