function [wplv,sqplv,wsign,sqsign]=PLV(Ph,fq,tr_ind,tail)
%trial numbers
wltrials=tr_ind{1};
sqtrials=tr_ind{2};
%steps in frequency 
fn=length(fq);
wltn=length(wltrials);
sqtn=length(sqtrials);
wph1=zeros(size(Ph,2),length(wltrials));
sph1=zeros(size(Ph,2),length(sqtrials));
wph2=zeros(size(Ph,2),length(wltrials));
sph2=zeros(size(Ph,2),length(sqtrials));
for f=1:fn;
    f1=fq(f);
wph1=squeeze(Ph(f1,:,wltrials,1));
sph1=squeeze(Ph(f1,:,sqtrials,1));

wph2=squeeze(Ph(f1,:,wltrials,2));
sph2=squeeze(Ph(f1,:,sqtrials,2));
wplv(:,f)=phaselockvalue(wph1,wph2);
sqplv(:,f)=phaselockvalue(sph1,sph2);
wtemppls=plvshuffle(wph1,wph2);
wPLS(:,:,f)=wtemppls;
sqtemppls=plvshuffle(sph1,sph2);
sqPLS(:,:,f)=sqtemppls;
switch tail
    case 1
Y=quantile(squeeze(wPLS(:,:,f)),0.95,2);
wsign1=find(gt(wplv(:,f),Y)==1);
wsign(1:length(wsign1),f)=wsign1;
Y=quantile(squeeze(sqPLS(:,:,f)),0.95,2);
sqsign1=find(gt(sqplv(:,f),Y)==1);
sqsign(1:length(sqsign1),f)=sqsign1;
    case 2
Y=quantile(squeeze(wPLS(:,:,f)),[0.025 0.975],2);
wsign1=find(gt(wplv(:,f),Y(:,2))==1);
wsign(1:length(sqsign1),2,f)=wsign1;
wsign1=find(gt(wplv(:,f),Y(:,2))==1);
wsign(1:length(sqsign1),1,f)=wsign1;
Y=quantile(squeeze(sqPLS(:,:,f)),[0.025 0.975],2);
sqsign1=find(gt(sqplv(:,f),Y(:,2))==1);
sqsign(1:length(sqsign1),2,f)=sqsign1;
sqsign1=find(lt(sqplv(:,f),Y(:,1))==1);
sqsign(1:length(sqsign1),1,f)=sqsign1;
end

end


