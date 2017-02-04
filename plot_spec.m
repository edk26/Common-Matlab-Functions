function plot_spec(data,t,fq,fs,w)

t11=t(1)-.25;t22=t(2)+.25;

Y=wavtransform(fq,data(round(t11*fs):round(t22*fs)),fs,w,1);
Y1=abs(Y(:,round(.25*fs)+1:length(Y)-round(.25*fs),:));

tt=linspace(t(1),t(2),size(Y1,2));

figure
subplot(3,1,1:2),pcolor(tt,fq,Y1),shading interp
subplot(3,1,3),plot(tt,data(round(t(1)*fs):round(t(2)*fs)))


