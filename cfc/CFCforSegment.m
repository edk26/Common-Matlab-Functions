function [mi, zmi] =  CFCforSegment (dataP, dataA, fp, fa, fs, buff)
%Inputs:
%   dataP - 2 dimensional time-series x channel of data for phase
%   dataA - 2 dimensional time-series x channel of data for amplitude
%       Note-dataA and dataP will be the same for CFC within a channel
%   fp - frequencies for phase
%            (i.e. fp = 4:1:30)
%   fa - frequencies for amplitude
%            (i.e. fa = [ [30:2:80], [85:5:200], [210:10:500] ]
%   buff - buffer to avoid edge effects of wavelet decomposition
%            (i.e. 0.1 = 100ms )
%   fs - sampling frequency
%
%Outputs:
%   zmi
%   mi

% [~, ph] = WvtforCFC(dataP,fs,fp,buff);
% [amp, ~] = WvtforCFC(dataA,fs,fa,buff);

nbin=18;
nrep=200;





ph=angle(Hilbert_Time_Freq(dataP,fs,fp,buff));
amp=abs(Hilbert_Time_Freq(dataA,fs,fa,buff));

if nargout==2
    tic
    for i=1:size(amp,3)
        amp1=squeeze(amp(:,:,i)); ph1=squeeze(ph(:,:,i));
        [mi(:,:,i), ~ ,zmi(:,:,i)]=cfcMI3(ph1,amp1,nbin,nrep);
        channel = i
        channel_time = toc
    end
    
elseif nargout==1
    for i=1:size(amp,3)
        amp1=squeeze(amp(:,:,i)); ph1=squeeze(ph(:,:,i));
        [mi(:,:,i),~]=cfcMI3(ph1,amp1,nbin,0);
    end
    
else
    error('Incorrect number of outputs')
end


function [amp, ph] = WvtforCFC(data,fs,fq,buff)

fct=[[[1:29]',[[1:29]+1]'] ; [30,1300]];
sf=[ [linspace(2,6,length(1:29))]'; 6];


Yztotal=[]; amp=[]; ph=[];
for i=1:numel(sf)
    fq1=fq(fq>=fct(i,1)); fq1=fq1(fq1<fct(i,2));
    
    if ~isempty(fq1)
        sf1=sf(i);
        
        Y=wavtransform_sk_local(fq1,data,fs,sf1,1);
        Y1=abs(Y(:,buff*fs+1:size(Y,2)-buff*fs,:));
        Y2=angle(Y(:,buff*fs+1:size(Y,2)-buff*fs,:));
        
        amp=[amp;Y1];
        ph=[ph;Y2];
    end
end



% 
% function Y=wavtransform_sk_local(fq,TS,sr,sf,dim)
% % Usage:
% %              Y=wavtransform(fq,TS,sr,width,dim)
% %It returns the morlet wavelet transform of 'TS' computed at frequencies 'fq'.
% %TS is a timeseries or a matrix of timeseries sampled at rate 'sr'.
% %'width'defines the mother wavelet, if set to 0 cwt is run [0].
% 
% if ~nargin
%     help wavtransform
% else
%     if ~exist('dim','var')||isempty(dim)
%         [ntp nts]=size(TS);
%         if nts>ntp
%             TS=TS';
%             [ntp nts]=size(TS);
%         end
%     else
%         if dim~=1
%             TS=TS';
%         end
%         [ntp nts]=size(TS);
%     end
%     if ~exist('sf','var')||isempty(sf)
%         width=0;
%     end
%     
%     %load all Mother Wavelets
%     if any(sf~=0)
%         dt = 1/sr;
%         MW=cell(numel(sf),numel(fq));
%         for nw=1:numel(sf)
%             for nf=1:numel(fq)
%                 % w=width(nw);
%                 % sf = fq(nf)/w;
%                 sf1=sf(nw);
%                 w=fq(nf)/sf1;
%                 st = 1/(2*pi*sf1);
%                 % t=-3.5*st:dt:3.5*st;
%                 t=-(w/2)*st:dt:(w/2)*st;
%                 MW(nw,nf) = {morwav(fq(nf),t,w,sf1,st)};
%             end
%         end
%     end
%     scales=sr./fq;
%     
%     
%     % Y=complex(zeros(numel(fq),ntp,nts,numel(width)));
%     Y=zeros(numel(fq),ntp,nts,numel(sf));
%     % Y=ones(numel(fq),ntp,nts,numel(width));
%     
%     
%     
%     for nw=1:numel(sf)
%         if sf(nw)==0
%             for N=1:nts
%                 Y(:,:,N,nw) = cwt(TS(:,N),scales,'cmor1-1');
%             end
%             
%         else
%             for N=1:nts
%                 for nf=1:numel(fq)
%                     Y(nf,:,N,nw) = conv(TS(:,N),MW{nw,nf}','same');
%                 end
%             end
%         end
%     end
% end
% 
% function y = morwav(f,t,width,sf,st)
% % sf = f/width;
% % st = 1/(2*pi*sf);
% A = 1/sqrt((st*sqrt(pi)));
% y = A*exp(-t.^2/(2*st^2)).*exp(1i*2*pi*f.*t);


