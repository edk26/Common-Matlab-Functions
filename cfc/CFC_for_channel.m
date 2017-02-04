function [mi, fps, fas, amp_ph, zmi] = CFC_for_channel (Plfp, Alfp, fp, fa, resP, resA, fs, niter, method, trialinfo)

fps=fp(1):resP:fp(2);
fas=fa(1):resA:fa(2);
wavwid=15;
if method==1
    xfp=wavtransform(fps,Plfp,fs,wavwid)';
    xfa=wavtransform(fas,Alfp,fs,wavwid)';
    xfp=xfp(5*fs:end-5*fs,:);%Get rid of edge effects by chopping 5s either side
    xfa=xfa(5*fs:end-5*fs,:);
    Afa=abs(xfa);
    Pfp=angle(xfp);
elseif method==2
    %xfp
    fpm=0.1*mean(fp);
    [xfp]=butterysmooth(Plfp,fs,fp,[fp(1)-fpm,fp(2)+fpm]);
    Pfp=angle(hilbert(xfp));
    
    %xfa
    fam=1;%max(fp);%--Width of fa band must be 2x max fp
    [xfa]=butterysmooth(Alfp,fs,fa,[fa(1)-fam,fa(2)+fam]);
    Afa=abs(hilbert(xfa));
end

if nargin<10
    [mi,amp_ph,zmi]=cfcMI(Pfp,Afa,32,niter,2);

elseif nargin==10
    [Afaxtrials, ~, ~] = LFPStimulus(trialinfo.StimulusTimes, trialinfo.Trial, 'Correct&Win|Lose&Go', trialinfo.TrialNum, trialinfo.pre, trialinfo.post, Afa);
    [Pfpxtrials, ~, ~] = LFPStimulus(trialinfo.StimulusTimes, trialinfo.Trial, 'Correct&Win|Lose&Go', trialinfo.TrialNum, trialinfo.pre, trialinfo.post, Pfp);

    
    Afa_stitched=stitch_3d_to_2d(Afaxtrials);
    Pfp_stitched=stitch_3d_to_2d(Pfpxtrials);
    [mi,amp_ph,zmi]=cfcMI(Pfp_stitched,Afa_stitched,32,niter,2);
    
end


