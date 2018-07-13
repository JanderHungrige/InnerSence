%Calling RHV analysis functions
clear
clc
tic

Matlabbase='C:\Users\310122653\Documents\PhD\Matlab\InnerSence Data specific\HRV feature creation\';
path='E'; % the HDD file with the patient data. Needed for loading ECG

pat=[3,4,5,6,7,9,13,15]; 
% pat=5
saving=1;
plotting=0;
win=[30 60 150 300];
winXi=300;


%%
%  YOU CAN BETTER USE THE "CallingHRVfunctions" m FILE
%   This is now only for the innerSence dataset. The mentioned m file tries
%   to do that for any given ECG signal

%%

 for i=1:length(pat)
    disp('***************************************')
    disp(['Working on patient ' num2str(pat(i))])
    Neonate=pat(i);        
        
    
% %%%%%%%% ECG TIME DOMAIN   
%         cd(Matlabbase)   
%         loadfolder=([path ':\InnerSence\processed data\ECG\']);
%         savefolderHRVtime= ([path ':\InnerSence\processed data\HRV-features\timedomain\']);
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
%     SDNN(Neonate,saving,win,loadfolder,savefolderHRVtime);
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
 



 end
toc