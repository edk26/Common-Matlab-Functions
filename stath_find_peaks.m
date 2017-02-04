function [ ] = stath_find_peaks (data)

for i=1:size(data,1)
hthr=quantile(data(:,i),.99);



end