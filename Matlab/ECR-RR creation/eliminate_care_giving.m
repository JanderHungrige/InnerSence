function [ECG_nocare]= eliminate_care_giving(path,Neonate,sheet,lead,FS,Matlabbase)
%this function eliminates the caregiving moments which are annotated by
%edwin and detected by Toine.
%This functions loads the original ECG and loads the index of the feeding
%moment. Therby we can create a new ECG without the feeding moments.
%Leaving this parts nan.

%for testing
% Neonate=3;
% lead=13;
% FS=250;
clearvars ECG_nocare
%loading the ECG
% load(['C:\Users\310122653\Documents\PhD\InnerSense Data\Data files\All files\Baby' num2str(Neonate) '\sfull']); %Full set
[s,ECG_raw]=loading_ecg(path,Neonate,sheet,lead,FS);
ECG_nocare=ECG_raw;
sec=length(ECG_raw)/FS; %duration of ecg in s
FS_temp=length(s.Data{1,2})/sec; %FS of temperatur
load([path ':\InnerSence\Data files\All files\index of feeding moments\Baby' num2str(Neonate) '\indexFood'])

cd(Matlabbase)
totsec=length(ECG_nocare)/FS;
%[totsec]=timestampconversion(s.tstart, s.tend);   % duration in seconds calculated from start and end time
t=(0:1/FS:totsec);                           %time vector
t=t(1,1:end-1);                              %generate same length for time vector as for ECG vector


Tkern(indexFood)=1;

% resampling temperature to ECG
% new timevectores for the Temperature for interp1
Ttkern=(0:length(Tkern)-1);

% Resampling becuause we have different FS for Temperature and ECG
Tkern=interp1(Ttkern,Tkern,t);
Tkern(isnan(Tkern))=0;
Tkern=logical(Tkern);
ECG_nocare(Tkern)=nan; 


end