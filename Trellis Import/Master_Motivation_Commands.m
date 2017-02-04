%------------------ DATA ANALYSIS ---------------------------%
RecID='DW';
fsF=1000;
fs=30000;

%Gives Force
[time1kHz, Force, AnalogElectrodeIDs] = GetAnalogData('datafileMW_EO0002.ns2', fsF, [10241 10242]);
figure; plot(time1kHz, Force)

tstart= 1; %start of task
tend=540; %end of task
getForceData

%Plot all response times together
figure; plot(ResponseBlockTime, LeftForceResponseBlock)
figure; plot(ResponseBlockTime, RightForceResponseBlock)
%Average the above
figure; plot(ResponseBlockTime, mean(LeftForceResponseBlock,2))
hold on; plot(ResponseBlockTime, mean(RightForceResponseBlock,2), 'r'); legend('R','L')

%Put in channels and import labels
% ch=ch1;%[55:64, 129:132];
% %--Placeholder, import electrode labels
% [~,ia,ib]=intersect(cell2mat(ECoGElectrodeKeys(:,3)),ch');
% labels=ECoGElectrodeKeys(ia,1);
% uiimport

[ch, labels] = Get_Labels(ElectrodeKey,AnalogElectrodeIDs);


%Get LFP Data ***Remember that 65->129 **Check AnalogElectrodeIDs
[time30kHz, LFPdata30kHz, AnalogElectrodeIDs] = GetAnalogData('datafileMW_EO0002.ns5', fs, ch);
%Chop LPFdata to match Force
eval(['LFPdata',RecID,'=LFPdata30kHz(fs*tstart:fs*tend,:);']);
time30kHz=time30kHz(fs*tstart:fs*tend)';

%Timestamps for task parameters -- Just gotta know the order they appear
[EventTimes] = GetEventData('datafileMW_EO0002.nev');
% skips=sum(EventTimes<tstart);
%Account for chopping relative to tstart and tend
eval(['EventTimes',RecID,' = EventTimes(find(EventTimes>tstart,1,''first''):find(EventTimes<tend,1,''last''))-tstart;']);
eval(['figure; plot(time1kHz',RecID,', Force',RecID,')']);
% hold on; plot((1/fsF)*LeftResponseTimes*[1 1], ylim, 'm');
% hold on; plot((1/fsF)*RightResponseTimes*[1 1], ylim, 'c');
eval(['hold on; plot(EventTimes',RecID,'*[1 1], ylim, ''k'')']);

skips=7; trialskips=1;
celldata=BilateralDelayMotivationTaskIntraopData;
celldata(trialskips,:)=[];
%Indexing event times
%Get BilateralDelayMotivationTaskIntraopData using import from txt
eval(['[CueStimulusTimes, CueStimulusDuration, CueTrial, CueTrialNum] = MotivationTaskStimulusBlock(EventTimes',RecID,', skips, 4, 1, celldata);']);
eval(['[CommandStimulusTimes, CommandStimulusDuration, CommandTrial, CommandTrialNum] = MotivationTaskStimulusBlock(EventTimes',RecID,', skips, 4, 2, celldata);']);
eval(['[FeedbackStimulusTimes, FeedbackStimulusDuration, FeedbackTrial, FeedbackTrialNum] = MotivationTaskStimulusBlock(EventTimes',RecID,', skips, 4, 3, celldata);']);
eval(['[ITIStimulusTimes, ITIStimulusDuration, ITITrial, ITITrialNum] = MotivationTaskStimulusBlock(EventTimes',RecID,', skips, 4, 4, celldata);']);
lrResponseTimes=[LeftResponseTimes;RightResponseTimes]/1000;
[ResponseStimulusTimes, ResponseStimulusDuration, ResponseTrial, ResponseTrialNum] = MotivationTaskStimulusBlock(lrResponseTimes, 0, 1, 1, BilateralDelayMotivationTaskIntraopData);
% 
% %Gives windows about events of interest
% LFP=LFPdataDW2(:,1);
% [LFPxtrials, StimulusTimes] = LFPStimulus(CueStimulusTimes, CueTrial, 'Correct&Win|Lose&Go', TrialNum, LFP);