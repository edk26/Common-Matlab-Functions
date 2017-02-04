function [trialdata1, trialdata2, num_rejects, rejects] = Artifact_Trial_Reject (trialdata1,data1,trialdata2,data2,llThr)

%%Takes 2d trial data and rejects trials with artifacts
%May fail if too few trials......

LL1=abs(data1(2:end)-data1(1:end-1)); LL1(end+1,:)=zeros(1,size(LL1,2));
LL2=abs(data2(2:end)-data2(1:end-1)); LL2(end+1,:)=zeros(1,size(LL2,2));

ll1=abs(trialdata1(2:end,:)-trialdata1(1:end-1,:)); ll1(end+1,:)=zeros(1,size(ll1,2));
mxll1=max(ll1);
ll2=abs(trialdata2(2:end,:)-trialdata2(1:end-1,:)); ll2(end+1,:)=zeros(1,size(ll2,2));
mxll2=max(ll2);


rejects1=find(mxll1>llThr*std(LL1));
rejects2=find(mxll2>llThr*std(LL2));



rejects=union(rejects1,rejects2);
num_rejects=size(rejects,2);

trialdata1(:,rejects)=[];
trialdata2(:,rejects)=[];



% 
% % 
% figure(2)
% hh1=subplot(211);
% t=linspace(-.25,.25,length(trialdata1));
% plot(t,trialdata1)
% hh2=subplot(212)
% plot(t,ll1)
% for ii=1:size(trialdata1,2)
%     lbl{ii}=num2str(ii);
% end
% legend(lbl)
% 
% figure(3)
% subplot(211)
% hist(mxll1,100)
% title('ll')
% subplot(212)
% mxA=max(abs(trialdata1));
% hist(mxA,100)
% title('Amp')
% figure(4)
% hh1=subplot(211)
% t=linspace(0,586,length(data));
% plot(t,data)
% hh2=subplot(212)
% plot(t,LL)
% linkaxes([hh1 hh2],'x')
% figure(5)
% hist(LL,100)


