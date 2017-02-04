function Y=wavtransform_new_tmp(fq,TS,sr,sf,dim)
% Usage:
%              Y=wavtransform(fq,TS,sr,width,dim)
%It returns the morlet wavelet transform of 'TS' computed at frequencies 'fq'.
%TS is a timeseries or a matrix of timeseries sampled at rate 'sr'. 
%'width'defines the mother wavelet, if set to 0 cwt is run [0].

if ~nargin
    help wavtransform
else
    if ~exist('dim','var')||isempty(dim)
        [ntp nts]=size(TS);
        if nts>ntp
            TS=TS';
            [ntp nts]=size(TS);
        end
    else
        if dim~=1
            TS=TS';
        end
        [ntp nts]=size(TS);
    end
    
    
    
    
    %load all Mother Wavelets
    dt = 1/sr;
    MW=cell(numel(fq),1);
    for nf=1:numel(fq)
        sf1=sf(nf);
        w=fq(nf)/sf1;
        st = 1/(2*pi*sf1);
        t=-(w/2)*st:dt:(w/2)*st;
        MW(nf) = {morwav(fq(nf),t,w,sf1,st)};
    end
    scales=sr./fq;
    
    
    Y=nan(numel(fq),ntp,nts);
    
    for N=1:nts
        nani = find(~isnan(TS(:,N)));
        TSn = TS(nani,N);
        for nf=1:numel(fq)
            Y(nf,nani,N) = conv(TSn,MW{nf}','same');
        end
    end
    
end



function y = morwav(f,t,width,sf,st)
% sf = f/width;
% st = 1/(2*pi*sf);
A = 1/sqrt((st*sqrt(pi)));
y = A*exp(-t.^2/(2*st^2)).*exp(1i*2*pi*f.*t);


