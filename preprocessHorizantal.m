function[data_H_LPF,thresh_H]=preprocessHorizantal()
clc;clear all; close all;
% data=load('atousa_HEOG.txt');
data_H=load ('atousa_HEOG.txt');
Fs=1000;
L=length(data_H);
t=(0:L-1)./Fs;
%% Baseline drift remove

%% data filtering
h=fdesign.lowpass('Fp,Fst,Ap,Ast',0.01,0.08,1,110);
d=design(h,'equiripple'); %Lowpass FIR filter
data_H_LPF=filtfilt(d.Numerator,1,data_H); %zero-phase filtering
%% find peak
CA_H = cwt(data_H_LPF,20,'haar');
b=1;
find_delay=diff(CA_H)*100;
[pks,locs] = findpeaks(abs(find_delay));
for i=3:length(pks)-3
       if abs(pks(i))>0.1
          loc2(b)=locs(i);
          b= b+1;
       end
end
tt1=diff(loc2);
for i=1:fix((length(loc2)/2))-1
ttime(i)=tt1(2*i+1); %Transition time
end
delayt=round(ttime(1)/2); %Delay time
delay=delayt./Fs;
%% Find threshold
ampl=mean(abs(data_H(loc2([2,6]))));
thresh_H=ampl*0.8;
%% plot
subplot(3,1,1)
plot(t,data_H_LPF)
hold on
plot(t(loc2)-delay,data_H_LPF(loc2),'r*')
subplot(3,1,2)
plot(t(20:end-20),CA_H(20:end-20))
subplot(3,1,3)
plot(t(1:end-1),find_delay)
hold on
plot(t(loc2),find_delay(loc2),'r*')
