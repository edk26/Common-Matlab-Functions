function [StimulusTimes, StimulusDuration, Trial, TrialNum] = MotivationTaskStimulusBlock2(EventTimes, SkipEvents, EventsPerTrial, Event, TaskDataLog)
%%Returns StimulusTimes and duration for a particular task epoch - e.g. cue
%%presentation
%%EventTimes - e.g. EventTimesDW2 **Don't use raw event times
%%SkipEvents - how many time stamps to skip - typically 3
%%EventsPerTrial - typically 4
%%Event - 1 = cue presentation; 2= Go Signal; 3=Feedback; 4=ITI
%%TaskDataLog is imported from txt file


TrialNum = floor((length(EventTimes)-SkipEvents)/EventsPerTrial);

%StimulusBlockTime = -pre:(1/sf):post;

for i = 1:TrialNum
    thisEvent = SkipEvents+Event+EventsPerTrial*(i-1);
    StimulusTimes(i) = EventTimes(thisEvent);
    if thisEvent<length(EventTimes)
        StimulusDuration(i) = EventTimes(thisEvent+1)-EventTimes(thisEvent);
    end
end

% find left and right trials
Trial.Left = find([TaskDataLog{:,6}]==1);
Trial.Right = find([TaskDataLog{:,6}]==2);

% find trials with different cue types
Trial.Win = [];
Trial.Lose = [];
Trial.Squeeze = find([TaskDataLog{:,6}]>0);

% find go and nogo trials
Trial.Go = find([TaskDataLog{:,6}]>0);
Trial.NoGo = [];
Trial.GoFast = [];
Trial.Stop = [];

% find correct and error trials
Trial.Correct = find([TaskDataLog{:,6}]>0);
Trial.Error = [];
