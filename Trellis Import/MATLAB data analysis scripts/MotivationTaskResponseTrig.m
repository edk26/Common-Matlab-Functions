function [ResponseBlockTime, ResponseTimes, ForceResponseBlock] = MotivationTaskResponseTrig(Force, BinSize, pre, post, sf, threshold, mm)
% mm - 1 = find up inflection, 2 = find down inflection
MinISI = 2.5*sf;
%threshold = 200;

%h = waitbar(0,'Calculating derivative...');

DelForce = zeros(size(Force));
nsteps = size(Force,1)-2*BinSize-1;
parfor i=(BinSize+1):(size(Force,1)-BinSize)
    DelForce(i,:) = (mean(Force(i:(i+BinSize)),1)-mean(Force((i-BinSize):i),1))/(BinSize/sf);
    %waitbar(i/nsteps,h);
end

%waitbar(0,h,'Imposing MinISI...');
if mm == 1
    trig = find(DelForce>threshold);
elseif mm == 2
    trig = find(DelForce<-threshold);
end



lasttrig = trig(1);
for i = 2:length(trig)
    if (trig(i)-lasttrig) < MinISI
        trig(i)=-1;
    else
        lasttrig = trig(i);
    end
    %waitbar(i/(length(trig)-1),h);
end
trig(trig==-1)=[];

%waitbar(0,h,'Generating Force matrix...');

for i = 1:length(trig)
    ForceResponseBlock(:,i) = Force((trig(i)-pre*sf):(trig(i)+post*sf));
    %waitbar(i/length(trig),h);
end

%close(h);

%figure; plot(Force); hold on; plot(DelForce, 'r');

ResponseBlockTime = -pre:(1/sf):post;
ResponseTimes = trig;