%Calling RHV analysis functions
clear
clc
tic

Matlabbase='C:\Users\310122653\Documents\PhD\Matlab\InnerSence Data specific\HRV feature creation\';
addpath('C:\Users\310122653\Documents\PhD\Matlab');
addpath('C:\Users\310122653\Documents\PhD\Matlab\cECG Data specific')
addpath('C:\Users\310122653\Documents\PhD\Matlab\cECG Data specific\R peak detection')

path='E'; % the HDD file with the patient data. Needed for loading ECG
loadfolder=([path ':\cECG_study\Annotations\Datafiles\For Quick Annotator\']);
savefolderHRVtime= ([path ':\InnerSence\processed data\HRV-features\timedomain\']);



pat=[4,5,6,7,9,10,11,12,13]; 
pat=7
saving=0;
plotting=0;
win=[30 60 150 300];
winXi=300;


 for I=1:length(pat)
    disp('***************************************')
    disp(['Working on patient ' num2str(pat(I))])
    Neonate=pat(I);      
    
  
%% ************ Load data **************

    filetype='Intellivue';
    filelocation=([loadfolder 'participant' num2str(Neonate) '\' filetype '\']);
    Datum=dir([filelocation '2012*']); % folder name differnt on this stage
    filelocation=([filelocation Datum.name '\']);
    Sessions=dir([filelocation filetype '*']);
    
    for S=1:length(Sessions)
        load([filelocation Sessions(S,1).name])
        
%% ************ Creating RR signal for ECG-Signal **************
        Ralphsfactor={1;-1;-1;1;1;-1;1;-1; 1; 1;-1; 1;-1; 1;-1;-1;-1;-1};%Determine if the ECG signal should be turned -1 or not 1. 
                     %1  2 3  4 5  6 7  8  9  10 11 12 13 14 15 16 17 18
        padding=0; %Determine if the RR should be same length as ECG. Don`t have to be
        FS_ecg=500;
        plotting=0; %plotting Ralphs RR detection

        t_ECG=linspace(0,length(ECG.values)/FS_ecg,length(ECG.values))';
%         RR=nan(1,length(ECG.values));
        [RR_idx, ~, ~, ~, ~, RR, ~] = ecg_find_rpeaks(t_ECG,Ralphsfactor{Neonate,1}*ECG.values, FS_ecg, 250,plotting,0); %, , , maxrate,plotting,saving   -1* because Ralph optimized for a step s slope, we also have steep Q slope. inverting fixes that probel 


%% ************ calculate HRV **************

        % %%%%%%%% ECG TIME DOMAIN   
        %         cd(Matlabbase)   

        %     Beats_per_Epoch(Neonate,saving,win,loadfolder,savefolderHRVtime)
        %     
        % % cd('C:\Users\310122653\Documents\PhD\Matlab\ECG analysis')
        % %         if exist('arclenAS','var')==0
        % %             arclenAS=[];arclenQS=[];
        % %         end
        % %         cd('C:\Users\310122653\Documents\PhD\EEG_MMC Data\Matlab\ECG analysis')
        % %         [arclenAS,arclenQS]=linelength(Neonate,saving,arclenAS,arclenQS);
        % %         cd('C:\Users\310122653\Documents\PhD\EEG_MMC Data\Matlab\ECG analysis')
        % %          meanarclength(Neonate,pat,arclenAS,arclenQS);
        %
        % 
        % %%%%%%%% HRV TIME DOMAIN
        %         disp('HRV time domain start')
        %         loadfolder=([path ':\InnerSence\processed data\ECG\']);
        %         savefolderHRVtime= ([path ':\InnerSence\processed data\HRV-features\timedomain\']);
        %         cd(Matlabbase)   
        %     SDNN(consence_RR_windowed,Neonate,saving,win,loadfolder,savefolderHRVtime);
        % %         disp('SDNN finished') 
        % %         cd(Matlabbase)
        %     RMSSD(Neonate,saving,win,loadfolder,savefolderHRVtime);
        % %         disp('RMSSD finished')  
        % %         cd(Matlabbase)
        %     NNx(Neonate,saving,win,loadfolder,savefolderHRVtime);
        % %         disp('NNx finished') 
        % %         cd(Matlabbase)
        %     pNNx(Neonate,saving,win,loadfolder,savefolderHRVtime);
        %         disp('pNNx finished') 
        %         cd(Matlabbase) 
        % %     SDANN(Neonate,saving,win,loadfolder,savefolderHRVtime);
        % %         disp('SDANN finished')  
        % %         cd(Matlabbase)        
        %         disp('HRV time domain finished')   
        % 
        %     
        % %%%%%%% HRV Frequency domain
        %         disp('Frequency time domain start')
        %         loadfolder=([path ':\InnerSence\processed data\ECG\Spectrum\']);
        %         savefolderHRVfreq= ([path ':\InnerSence\processed data\HRV-features\freqdomain\']);        
        %         cd(Matlabbase)
        %    freqdomainHRV (Neonate,plotting,win,saving,loadfolder,savefolderHRVfreq)
        %         cd(Matlabbase)
        %  disp('Frequency time domain finished')   

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - XI - %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         cd(Matlabbase)  
%         Xifolder=genpath('C:\Users\310122653\Documents\PhD\Matlab\Xi features\ecg');
%         addpath(Xifolder);
% 
%         settings.HRV_SPECTRAL_BANDS= [   0.04,0.15;...
%                                          0.15,0.4;...
%                                          0.4, 0.7 ];  %+[0.7, 1.5] three bands expected
%         settings.EPOCH_LENGTH=30; % in s
%         settings.HRV_WINDOW_LENGTH=300; % 5min
%         settings.CONSIDER_COVERAGE=1; % yes/no
%         settings.PROCESSING_THR_WINDOW_COVERAGE= 1;% yes/no
% 
%                     % settings.HRV_WINDOW_LENGTH being expressed in seconds, assuming an
%                     % average of 1 beat per second, the computation of features is
%                     % performed only if enough RR-intervals are present
% 
%         %%%%%%% loading RR data
%                 loadfolder=([path ':\InnerSence\processed data\ECG\']);
% 
%                 [consence_RR_windowed,winlength]=load_RR(loadfolder,Neonate,winXi);
%                 if winlength==1
%                     return
%                 end; clearvars winlength
% 
%         %%%%%%% Get going 
% 
%                 loadfolder=([path ':\InnerSence\processed data\ECG\']);
%                 savefolderHRVtime= ([path ':\InnerSence\processed data\HRV-features\Xi\']);
% 
%         ret = extract_ecg_hrv_fd_adpt(consence_RR_windowed, settings, savefolderHRVtime);
    end %Session
 end% Patient
toc