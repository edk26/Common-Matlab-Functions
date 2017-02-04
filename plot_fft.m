function p=plot_fft(y,fs)

% fs = 1000;                    % Sampling frequency
T = 1/fs;                     % Sample time
L = length(y);                     % Length of signal
t = (0:L-1)*T;                % Time vector

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
%figure
p=plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')