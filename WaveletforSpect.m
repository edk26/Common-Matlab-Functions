function [Yztotal, amp, ph] = WaveletforSpect(dataA,fs,fq,LFP,buff)

% LFP=LFP(round(25*fs):round(30*fs));
buff=buff/2;
fct=[1,30;30,1300];
sf=[2,2];
% sf=2*ones(size(fct,1),1);


Yztotal=[]; amp=[]; ph=[];
for i=1:numel(sf)
    fq1=fq(fq>=fct(i,1)); fq1=fq1(fq1<fct(i,2));
    
    if ~isempty(fq1)
        sf1=sf(i);
        
        
        Y=wavtransform_sk(fq1,dataA,fs,sf1,1);
        Y1=abs(Y(:,round(buff*fs+1):round(size(Y,2)-buff*fs),:));
        Y2=angle(Y(:,round(buff*fs+1):round(size(Y,2)-buff*fs),:));
        
        
        if size(size(Y1),2)>2
            Ymn=squeeze(mean(Y1,3));
        elseif size(size(Y1),2)==2
            Ymn=Y1;
        end
        
        tmp=wavtransform_sk(fq1,LFP,fs,sf1,1);
        stdev=std(tmp,[],2);
        avg=mean(abs(tmp),2);
        clear Yz
        for j=1:size(avg,1)
            Yz(j,:)=(Ymn(j,:)-avg(j))/stdev(j);
        end
        
        Yztotal=[Yztotal;Yz];
        amp=[amp;Y1];
        ph=[ph;Y2];
    end
end

a=1;