function [dataout, fsout] = stath_decimate (datain, fsin, dsf)

datain=orient_var(datain);

fsout=fsin/dsf;
dataout=zeros(ceil(size(datain,1)/dsf),size(datain,2),'single');
for i=1:size(datain,2)
    tmp=datain(:,i)';
    tmp=[eegfilt(tmp,fsin,[],fsout/2)]';
    dataout(:,i)=downsample(tmp,dsf);
    clc
    fprintf(sprintf('Downsampling\nContact %d/%d\n',i,size(datain,2)))
end