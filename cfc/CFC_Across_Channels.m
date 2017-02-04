%CFC_About_Events
ilabels=labels(end:-1:1);
%Notch Filter
thresh=[8,0]; minfq=20; maxfq=1400;%****************
[badfqz]=find_bad_FFT(raw, fs, thresh, minfq, maxfq);
filtered=notch_bad_FFT(raw, fs, badfqz);


%% All Channels
%xfp
fp=[1,8]; fpm=0.1*mean(fp);
[xfp]=butterysmooth(LFPfiltered,fs,fp,[fp(1)-fpm,fp(2)+fpm]);
Pfp=angle(hilbert(xfp));

%xfa
fa=[30,50]; fam=1;%max(fp);%--Width of fa band must be 2x max fp
[xfa]=butterysmooth(LFPfiltered,fs,fa,[fa(1)-fam,fa(2)+fam]);
Afa=abs(hilbert(xfa));

mi=cfcMI(Pfp,Afa,32);

figure
pcolor(mi)
set(gca,'xtick',1:length(mi),'xticklabel',labels)%Are these oriented correctly??? Check in cfcMI script
set(gca,'ytick',1:length(mi),'yticklabel',ilabels)
title(gca,sprintf('CFC Amp (%d-%d), Phase (%d-%d)',fa(1),fa(2),fp(1),fp(2)))
xlabel('Phase')
ylabel('Amp')

pre=0; post=1;
%Cue -------------
[Afaxtrials, Afaxtrials_forspect, StimulusTimes] = LFPStimulus(ResponseStimulusTimes, ResponseTrial, 'Correct&Win|Lose&Go', ResponseTrialNum, pre, post, Afa);
[Pfpxtrials, Pfpxtrials_forspect, StimulusTimes] = LFPStimulus(ResponseStimulusTimes, ResponseTrial, 'Correct&Win|Lose&Go', ResponseTrialNum, pre, post, Pfp);
F=ForceDW2;
[Fxtrials, Fxtrials_forspect, FStimulusTimes] = LFPStimulus(CueStimulusTimes, CueTrial, 'Correct&Win|Lose&Go', TrialNum, pre, post, F);



Afa_stitched=stitch_3d_to_2d(Afaxtrials);
Pfp_stitched=stitch_3d_to_2d(Pfpxtrials);

mixtrials=cfcMI(Pfp_stitched,Afa_stitched,32);
figure
pcolor(mixtrials)
set(gca,'xtick',1:length(mi),'xticklabel',labels)%Are these oriented correctly??? Check in cfcMI script
set(gca,'ytick',1:length(mi),'yticklabel',ilabels)
title(gca,sprintf('CFC Amp (%d-%d), Phase (%d-%d), 1sec Following Response',fa(1),fa(2),fp(1),fp(2)))
xlabel('Phase')
ylabel('Amp')

%% Per Channel
channel=labels;
for i=1:length(channel)
Pch_label=channel{i};
Ach_label=channel{i};
resP=0.25;
resA=1;
fp=[0.25 12];
fa=[20 600];

Pch=find(strcmp(labels,Pch_label));
Ach=find(strcmp(labels,Ach_label));
start=30*fs;  stop=60*fs;
Plfp=filtered(start:stop,Pch);
Alfp=filtered(start:stop,Ach);

trial='Response';
eval(['trialinfo.StimulusTimes=' trial 'StimulusTimes;']);
eval(['trialinfo.Trial=' trial 'Trial;']);
eval(['trialinfo.TrialNum=' trial 'TrialNum;']);
trialinfo.pre=1;
trialinfo.post=1;

niter=100; method=1;

[mi.(channel{i}), fps.(channel{i}), fas.(channel{i}), amp_ph.(channel{i}), zmi.(channel{i})] = CFC_for_channel (Plfp, Alfp, fp, fa, resP, resA, fs, niter, method, trialinfo);
                    
end
figure(1)
% subplot(2,2,i)
for i=1:length(channel)
subplot(2,4,i)
imagesc(zmi.(channel{i}))
set(gca,'xtick',1:3:length(fps.(channel{i})),'xticklabel',fps.(channel{i})(1:3:end))%Are these oriented correctly??? Check in cfcMI script
set(gca,'ytick',1:50:length(fas.(channel{i})),'yticklabel',fas.(channel{i})(1:50:end))
title(gca,sprintf('%s\nAmp (%.1f-%.1f), Phase (%.1f-%.1f)',channel{i},fa(1),fa(2),fp(1),fp(2)))
xlabel('Phase')
ylabel('Amp')
set(gca,'Clim',[4,10])
end
