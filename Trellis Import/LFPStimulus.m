function [LFPxtrials, LFPxtrials_forspect, StimulusTimes] = LFPStimulus(StimulusTimes, Trial, TrialTypes, TrialNum, sf, pre, post, LFP)
%%StimulusTimes - choose what you want to center on - e.g. CueStimulusTimes
%Trial - 1 = cue presentation; 2= Go Signal; 3=Feedback; 4=ITI
%TrialTypes - e.g. Correct&Win|Lose&Go
% options -Correct, Error ; Win, Lose; Go, NoGo --->All from fields in
% Trial structure from MotivationTaskStimulusBlock
%TrialNum - total number of trials, as before
%LFP - one channel from LFP data **Does this only on per channel basis

%***Think about modifying so that this can be run to center on response times
%instead of event times
%sf = 1000;
% pre = 1;%Set window size here
% post = 5;

AndTypes = regexp(TrialTypes,'\&','split');

OrTypes = regexp(AndTypes{1},'\|','split');
ind = Trial.(OrTypes{1});
for j = 1:length(OrTypes)
    ind = union(ind, Trial.(OrTypes{j}));
end

ind=Trial.(AndTypes{1});

for i = 1:length(AndTypes)
    OrTypes = regexp(AndTypes{i},'\|','split');
    Orind = Trial.(OrTypes{1});
    for j = 1:length(OrTypes)
        Orind = union(Orind, Trial.(OrTypes{j}));
    end
    ind = intersect(ind, Orind);
end
SelectedTimes = StimulusTimes(ind(ind<=TrialNum));
SelectedSamples = round(sf*SelectedTimes);


for j=1:size(LFP,2)
    for i = 1:length(SelectedTimes)
        LFPxtrials(:,i,j) = LFP((SelectedSamples(i)-sf*pre):(SelectedSamples(i)+sf*post),j);
        LFPxtrials_forspect(:,i,j) = LFP((SelectedSamples(i)-sf*pre-sf*1):(SelectedSamples(i)+sf*post+sf*1));
%         LFPxtrials_forspect=[];
    end
end
% figure; plot((1:size(LFPxtrials,1))/sf-pre, LFPxtrials);
a=1;
end

