% %Downsample
% [LFPdataDW, fs] = stath_decimate (LFPdataDW, fs, 10);
% time30kHzDW=linspace(time1kHzDW(1),time1kHzDW(end),size(LFPdataDW,1));
% %Notch Filter
% thresh=[8,0]; minfq=20; maxfq=1400;%****************
% [badfqz]=find_bad_FFT(LFPdataDW, fs, thresh, minfq, maxfq);
% filtered=notch_bad_FFT(LFPdataDW, fs, badfqz);


centers={'Cue','Command','Feedback','ITI'};
conds={'Correct&Squeeze&Go','Correct&Win&Go','Correct&Lose&Go'};
combos = [1,3; 1,4; 2,3; 2,4];
prms=[0.1,12,1;12,30,1;30,80,5;80,250,10;250,600,15];


for j=1:size(centers,2)%Centers
    
    
    trial=centers{j};
    eval(['trialinfo.StimulusTimes=' trial 'StimulusTimes;']);
    eval(['trialinfo.Trial=' trial 'Trial;']);
    eval(['trialinfo.TrialNum=' trial 'TrialNum;']);
    trialinfo.pre=5;
    trialinfo.post=5;
    
    for k=1:size(conds,2)%Conditions
        Conditions=conds{k};
        [lfpxtrials, lfpxtrials_forspect, ~] = LFPStimulus(trialinfo.StimulusTimes, trialinfo.Trial, Conditions, trialinfo.TrialNum, fs, trialinfo.pre, trialinfo.post, filtered);
        [forcextrials, ~, ~] = LFPStimulus(trialinfo.StimulusTimes, trialinfo.Trial, Conditions, trialinfo.TrialNum, 1000, trialinfo.pre, trialinfo.post, ForceDW);
        
        for i=1:size(combos,1)%Combos
            dataA= squeeze ( lfpxtrials(:,:,combos(i,1)) );
            dataH= squeeze ( lfpxtrials(:,:,combos(i,2)) );
            
            for m=1:size(prms,1)
                [movingwin, params] = initialize_params ([0.5,0.1], prms(m,3), prms(m,1:2));
                
                [C,phi,S12,S1,S2,t,f,confC,phistd,Cerr]=cohgramc(dataA,dataH,movingwin,params);
                S1=S1';S2=S2';t=t';f=f';C=C';
                t=t-trialinfo.pre;
                
                temp=strrep(conds{k},'&','a');
                cond=strrep(temp,'|','o');
                figure(2)
                S11=f*ones(1,length(t)).*S1;
                h1=subplot(411);
                pcolor(t,f,S11),shading interp
                title(sprintf('%d-%d\n%s\nCenter on %s\n%s',round(params.fpass(1)),round(params.fpass(2)),cond,trial,labels{combos(i,1)}))
                h2=subplot(412);
                S22=f*ones(1,length(t)).*S2;
                pcolor(t,f,S22),shading interp
                title(labels{combos(i,2)})
                h3=subplot(413);
                pcolor(t,f,C),shading interp
                set(h3,'CLim',[0,1])
                title('Coherence')
                h4=subplot(414);
                t2=linspace(-trialinfo.pre,trialinfo.post,size(forcextrials,1));
                plot(t2,squeeze(forcextrials(:,:,1)),'--');
                hold on
                plot(t2,squeeze(forcextrials(:,:,2)));
                %             h5=subplot(415);
                %             t1=linspace(-trialinfo.pre,trialinfo.post,size(lfpxtrials,1));
                %             plot(t1,squeeze(lfpxtrials(:,:,1)));
                linkaxes([h1 h2 h3 h4],'x')
                cl=get(h1,'CLim');
                set(h2,'CLim',cl);
                
                set(gcf,'units','centimeters','position',[1,1,40,25])
                
                
                figname=fullfile('CoherenceFigs',sprintf('%s_%s_%s%s_%s_%dto%d.jpg',cond,centers{j},labels{combos(i,1)},labels{combos(i,2)},trial,round(params.fpass(1)),round(params.fpass(2))))
                saveas(figure(1),figname)
                
                close(1)
            end
        end
    end
end

    
    % t=t-trialinfo.pre;
    % tstep=30;
    % set([h1,h2,h3],'xtick',1:tstep:length(t),'xticklabel',t(1:tstep:end));
    % linkaxes([h1 h2],'xy')
    %
    %
    %

% S11=f*ones(1,length(t)).*S1;

