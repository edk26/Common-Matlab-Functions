function [reject] = Artifact_Trial_Reject2 (trialdata1,data1,llThr,rangeThr)

%%Takes 2d trial data and rejects trials with artifacts
%May fail if too few trials......
reject=0;
LL1=abs(data1(2:end)-data1(1:end-1)); LL1(end+1,:)=zeros(1,size(LL1,2));
ll1=abs(trialdata1(2:end,:)-trialdata1(1:end-1,:)); ll1(end+1,:)=zeros(1,size(ll1,2));
mxll1=max(ll1);

qntl=quantile(data1,rangeThr);
rng=range(trialdata1);

if mxll1 > llThr*std(LL1) || rng > qntl
    reject=1;
end


