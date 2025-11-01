clear all;
close all;
clc;


fs=16384; % sampling rate (Hz) <- Insert the value of this parameter

% Load data (*.txt files)
load TUR1.txt; % <- Insert this parameter
load TUR2.txt;
x1=TUR1; % <- Insert this parameter
x2=TUR2;
P=length(x1); % Length of measured data (samples)


z1=TUR1(:,2); % Gs
z2=TUR2(:,2);
% convert to rms values
z1=0.707*z1; % G rms
z2=0.707*z2;

%                   Signal Denoising/smoothing

% (A) Savitzky-Golay filter for denoising .................................
 order = 2;
 framelen = 221;
% 
 z1 = sgolayfilt(z1,order,framelen);
 z2 = sgolayfilt(z2,order,framelen);

% (B) Wavelet for denoising ...............................................
 lev = 4;
 wname = 'sym8';

 z1 = wden(z1,'rigrsure','h','mln',lev,wname);
 z1 = wden(z1,'minimaxi','h','mln',lev,wname);
 z1 = wden(z1,'sqtwolog','h','mln',lev,wname);

 z2 = wden(z2,'rigrsure','h','mln',lev,wname);
 z2 = wden(z2,'minimaxi','h','mln',lev,wname);
 z2 = wden(z2,'sqtwolog','h','mln',lev,wname);

% *************************************************************************

t=0:1/fs:P/fs-1/fs; % time array
ff=0:fs/P:fs/2; % frequency array

%                          Waveform Graph of Signals

% Time waveform of measured data 
% TUR1
figure
	plot(t,z1,'k')
    ylabel('G rms','fontsize',14)
    xlabel('time s','fontsize',14)
	title('Signal TUR1','fontsize',14)
    set(gca,'XLim',[0,P/fs],'YLim', [-1,1],'fontsize',14);

% TUR2
figure
	plot(t,z2,'k')
    ylabel('G rms','fontsize',14)
    xlabel('time s','fontsize',14)
	title('Signal TUR2','fontsize',14)
    set(gca,'XLim',[0,P/fs],'YLim', [-1,1],'fontsize',14);

%                        Spectrum Analysis of Signals

Fy1=abs(fft(z1,P)/P);
Fy2=abs(fft(z2,P)/P);

l=length(Fy1); % length of spectrum

% Set DC=0
Fy1(1)=0;
Fy2(1)=0;

% Spectrum of measured data
% TUR1
figure
	plot(ff,Fy1(1:P/2+1),'k')
    ylabel('G rms','fontsize',14)
    xlabel('frequency Hz','fontsize',14)
	title('FFT TUR1','fontsize',14)
    set(gca,'XLim',[0,1200],'YLim', [0,0.04],'fontsize',14); 


%TUR2
figure
	plot(ff,Fy2(1:P/2+1),'k')
    ylabel('G rms','fontsize',14)
    xlabel('frequency Hz','fontsize',14)
	title('FFT TUR2','fontsize',14)
    set(gca,'XLim',[0,1200],'YLim', [0,0.04],'fontsize',14);


%                  Overall amplitude calculation
    
% convert to m/sec^2 rms
u1=9.81*z1; % m/sec^2 rms
     
Fu1=abs(fft(u1,P)/P); % m/sec^2 rms
        
% Set DC=0
Fu1(1)=0;
    
OA1=(1000/(2*pi))*(sqrt(sum(((Fu1(10:1000,1)).^2)./((ff(1,10:1000)').^2))))
       

    