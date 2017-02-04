function [Yztotal,amp, ph] = WvtforCFC(data,fs,fq,buff)

%buff=buff/2;
fct=[[[1:29]',[[1:29]+1]'] ; [30,1300]];
sf=[ [linspace(2,6,length(1:29))]'; 6];


Yztotal=[]; amp=[]; ph=[];
for i=1:numel(sf)
    fq1=fq(fq>=fct(i,1)); fq1=fq1(fq1<fct(i,2));
    
    if ~isempty(fq1)
        sf1=sf(i);
        
        Y=wavtransform_sk(fq1,data,fs,sf1,1);
        Ytot=Y(:,buff*fs+1:size(Y,2)-buff*fs,:);
        Y1=abs(Y(:,buff*fs+1:size(Y,2)-buff*fs,:));
        Y2=angle(Y(:,buff*fs+1:size(Y,2)-buff*fs,:));
        
        amp=[amp;Y1];
        ph=[ph;Y2];
        Yztotal=[Yztotal;Ytot];
    end
end