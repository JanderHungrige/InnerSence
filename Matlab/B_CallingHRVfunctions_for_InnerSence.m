%Calling RHV analysis functions

% About Patient Nr4. Session 2 (1341399361) does not have Intellivue data. Therefore,
% create DAQ data for that particular session(or pat 4 in total) rename it
% to Intellivue manually and do the same with the annotations(if total 4
% delete the others). Then you can create the matrix without lost data(6h).
% You cannot simply use the DAQ data as there are annotations missing and
% to correct for that is more difficult. 
%
% For single addition: outcomment the for loop command and end command for the sessions loop ( Line 75) and fill in e.g. S=2

clear
clc
tic
PatientID=[3,4,5,6,7,9,13,15]; % core. Show all patients in the folder
pat=[3,4,5,6,7,9,13,15]; 
% pat=3
pat=[6,7,9,13,15]; 

user='c3po'; % c3po Philips

RRMethod='R'; %M or R to calculate the RR with Michiel or Ralphs algorythm
saving=1;
plotting1=0; % raw signals
plotting=0; % R peaks etc.
win=30;
faktor=30; % how much is the data moving forward? 30s is classic
FS_ecg=500;
S=1;

onlyAnnotations=0;


Pat_weight=[1845,2265,1740,1235,1700,1665,1460,1615];
Pat_GA=[31*7+5,33*7+6,28*7+6,30*7+1,32*7+6,30 ,25*7+4,29*7+6]; %pat 9 does not have any
Pat_CA=[33*7+6,34*7+6,34*7+6,31*7+2,33*7+5,37+4,31*7+5,32*7];
Pat_GACA=Pat_CA-Pat_GA; % difference between the birth and recording of data
NICU_info=[1, 2, 1, 1, 2, 1, 1, 1];% NICU=1, NMCU=2
C02=[]; %1=CPAP, 2=lowflow 3=no

if strcmp(user,'c3po')
    basepath='C:\Users\C3PO';
elseif strcmp(user,'Philips')
    basepath='C:\Users\310122653';
end

Matlabbase=[basepath '\Documents\GitHub\InnerSence\Matlab'];
cd(Matlabbase)
addpath(Matlabbase)
addpath([basepath '\Documents\GitHub\InnerSence\Matlab\EDR creation'])
addpath([basepath '\Documents\GitHub\InnerSence\Matlab\R peak detection'])
addpath([basepath '\Documents\GitHub\InnerSence\Matlab\ECG feature creation'])
addpath([basepath '\Documents\GitHub\InnerSence\Matlab\HRV feature creation'])
addpath([basepath '\Documents\GitHub\InnerSence\Matlab\ECR-RR creation'])
addpath([basepath '\Documents\GitHub\InnerSence\Matlab\R peak detection\RAlps Rpeak detection'])

path='C:\'; % partition with the patient data. Needed for loading ECG
loadfolder=([basepath '\Documents\PhD\Article_2_(EHV)\Processed Data\ECG\']);
loadfolderA=([basepath '\Documents\PhD\Article_2_(EHV)\Processed Data\Annotations\']);



savefolder= ([basepath '\Documents\PhD\Article_2_(EHV)\Processed data\']);
SavefolderAnnotations=([ savefolder 'Annotations\']);

if strcmp(RRMethod,'R')
    if (exist([savefolder 'HRV_features\RR\']) )==0;  mkdir([savefolder 'HRV_features\RR\']);end
    if (exist([savefolder 'HRV_features\EDR\']) )==0;  mkdir([savefolder 'HRV_features\EDR\']);end
    if (exist([savefolder 'HRV_features\timedomain\']) )==0;  mkdir([savefolder 'HRV_features\timedomain\']);end
    if (exist([savefolder 'HRV_features\freqdomain\']) )==0;  mkdir([savefolder 'HRV_features\freqdomain\']);end
    if (exist([savefolder 'HRV_features\nonlinear\']) )==0;   mkdir([savefolder 'HRV_features\nonlinear\']);end
    if (exist([savefolder 'HRV_features\weigthAge\']) )==0;   mkdir([savefolder 'HRV_features\weigthAge\']);end

elseif  strcmp(RRMethod,'M')    
    if (exist([savefolder 'HRV_features\RR_M\']) )==0;  mkdir([savefolder 'HRV_features\RR_M\']);end
    if (exist([savefolder 'HRV_features\EDR_M\']) )==0;  mkdir([savefolder 'HRV_features\EDR_M\']);end    
    if (exist([savefolder 'HRV_features\timedomain_M\']) )==0; mkdir([savefolder 'HRV_features\timedomain_M\']);end
    if (exist([savefolder 'HRV_features\freqdomain_M\']) )==0; mkdir([savefolder 'HRV_features\freqdomain_M\']);end
    if (exist([savefolder 'HRV_features\nonlinear_M\']) )==0;  mkdir([savefolder 'HRV_features\nonlinear_M\']);end
end

if strcmp(RRMethod,'R')
    savefolderECG= ([ savefolder 'HRV_features\ECG\']);
    savefolderRR= ([ savefolder 'HRV_features\RR\']);
    savefolderEDR= ([ savefolder 'HRV_features\EDR\']);    
    savefolderHRVtime= ([ savefolder 'HRV_features\timedomain\']);
    savefolderHRVfreq= ([ savefolder 'HRV_features\freqdomain\']);        
    savefolderHRVnonlin= ([ savefolder 'HRV_features\nonlinear\']);  
    savefolderHRVweightAge=([savefolder 'HRV_features\weigthAge\']);
elseif  strcmp(RRMethod,'M')
    savefolderECG= ([ savefolder 'HRV_features\ECG_M\']);    
    savefolderRR= ([ savefolder 'HRV_features\RR_M\']);
    savefolderEDR= ([ savefolder 'HRV_features\EDR_M\']);     
    savefolderHRVtime= ([ savefolder 'HRV_features\timedomain_M\']);
    savefolderHRVfreq= ([ savefolder 'HRV_features\freqdomain_M\']);        
    savefolderHRVnonlin= ([ savefolder 'HRV_features\nonlinear_M\']);        
end


 for I=1:length(pat)
    disp('***************************************')
    disp(['Working on patient ' num2str(pat(I))])
    Neonate=pat(I);   
    N_I=find(PatientID==Neonate); % IF we do not start with 1 we have to choose the correct index
    Sessions.name=num2str(Neonate);
  
%% ************ Load data **************
    Loadsession=dir(loadfolder);Loadsession=Loadsession(3:end-1,:); %-1 as we created also a folder which is located at the end (win30)
    for J=1:length(Loadsession)
        if strcmp(Loadsession(J).name ,['ECG_' num2str(Neonate) '.mat']) && onlyAnnotations ~=1
            load([loadfolder Loadsession(J).name])
            disp('Patient file found')
        end
    end
  

%% ************ Load annotations (1s) **************  

    load([loadfolderA 'win30\Annotations_' num2str(Neonate) '_win_30.mat']);
    disp('* Annotation loaded')


 %% ************ Window  ECG /  Annotation signals 
    if onlyAnnotations ~=1    
        t_ECG=linspace(0,length(ECG(2,:))/FS_ecg,length(ECG))';
    %       
        % The differnec in t_300 and t_ECG_300 is that t_ECG_300 is a
        % continuous run of time, while t_300 is 0 to t for each cell element
       [ECG_win_300,ECG_win_30,t_ECG_300,t_ECG_30]=SlidingWindow_ECG(ECG(2,:),t_ECG,Neonate,1,savefolderECG,faktor); 

        disp(['* Data is merged into windows of length: ' num2str(win) 's and ' num2str(30) 's'] )  
    end
    
    if onlyAnnotations
        continue 
    end
    %% ************ Creating RR signal for ECG-Signal **************
        Ralphsfactor=1;%{1;1;1;1;1;-1;1;-1; 1; 1;-1; 1;-1; 1;-1;-1;-1;-1};%Determine if the ECG signal should be turned -1 or not 1. 
                     %1  2 3  4 5  6 7  8  9  10 11 12 13 14 15 16 17 18
        padding=0; %Determine if the RR should be same length as ECG. Don`t have to be

        
        if strcmp(RRMethod,'M')
%Michiel
            for R=1:length(ECG_win_300)
                t_300{1,R}=linspace(0,length(ECG_win_300{1,R})/FS_ecg,length(ECG_win_300{1,R}))';
                if all(isnan(ECG_win_300{1,R}'))==1 || range(ECG_win_300{1,R}')==0  % if only Nan Ralph cannot handle it or if all values are the same (Flat line)
                     RR_300{R,1}=NaN(1,length(ECG_win_300{1,R})) ;
                else
                    ECG_win_300{1,R}(isnan(ECG_win_300{1,R})) = []; %Michiels cannot handle a single NAN
                    t_300{1,R}=linspace(0,length(ECG_win_300{1,R})/FS_ecg,length(ECG_win_300{1,R}))';                   
                    [RR_idxM] = streamingpeakdetection(ECG_win_300{1,R}', 500, [60 256], plotting, 18.5, 1024);
                    RR_300{R,1}=diff(RR_idxM.peakPositionArray)./500; % Calculating the time between the R peaks in seconds
                    RR_300{R,1}=[NaN RR_300{R,1}];% NAn is needed to make RR and RR_idx same length which is needed for lomb scargle
                    RR_idx_300{R,1}=RR_idxM.peakPositionArray; 
                end
            end           
            for R=1:length(ECG_win_30)
                t_30{1,R}=linspace(0,length(ECG_win_30{1,R})/FS_ecg,length(ECG_win_30{1,R}))';
                if all(isnan(ECG_win_30{1,R}'))==1 || range(ECG_win_30{1,R}')==0  % if only Nan Ralph cannot handle it or if all values are the same (Flat line)
                     RR_30{R,1}=NaN(1,length(ECG_win_30{1,R})) ;
                else
                    ECG_win_30{1,R}(isnan(ECG_win_30{1,R})) = []; %Michiels cannot handle a single NAN
                    t_30{1,R}=linspace(0,length(ECG_win_30{1,R})/FS_ecg,length(ECG_win_30{1,R}))';                   
                    [RR_idxM] = streamingpeakdetection(ECG_win_30{1,R}', 500, [60 256], plotting, 18.5, 1024);
                    RR_30{R,1}=diff(RR_idxM.peakPositionArray)./500; % Calculating the time between the R peaks in seconds
                    RR_30{R,1}=[NaN RR_30{R,1}];                    
                    RR_idx_30{R,1}=RR_idxM.peakPositionArray; 
                end
            end                
        elseif strcmp(RRMethod,'R')
%Ralph            
            for R=1:length(ECG_win_300)
                t_300{1,R}=linspace(0,length(ECG_win_300{1,R})/FS_ecg,length(ECG_win_300{1,R}))';
                if all(isnan(ECG_win_300{1,R}))==1 || range(ECG_win_300{1,R})==0  % if only Nan Ralph cannot handle it or if all values are the same (Flat line)
                   RR_300{R,1}=NaN(1,length(ECG_win_300{1,R})) ;
                else
                    [RR_idx_300{R,1}, ~, ~, ~, ~, RR_300{R,1}, ~] = ecg_find_rpeaks(t_300{1,R},Ralphsfactor*ECG_win_300{1,R}, FS_ecg, 250,plotting,0); %, , , maxrate,plotting,saving   -1* because Ralph optimized for a step s slope, we also have steep Q slope. inverting fixes that probel 
                end
            end
            for R=1:length(ECG_win_30)  
                t_30{1,R}=linspace(0,length(ECG_win_30{1,R})/FS_ecg,length(ECG_win_30{1,R}))';        
                if all(isnan(ECG_win_30{1,R}))==1 || range(ECG_win_30{1,R})==0 % if all elements are NAN or the same value, R peaks cannot be calculated
                   RR_30{R,1}=NaN(1,length(ECG_win_30{1,R})) ;
                else        
                    [RR_idx_30{R,1}, ~, ~, ~, ~, RR_30{R,1}, ~] = ecg_find_rpeaks(t_30{1,R},Ralphsfactor*ECG_win_30{1,R}, FS_ecg, 250,plotting,0); %, , , maxrate,plotting,saving   -1* because Ralph optimized for a step s slope, we also have steep Q slope. inverting fixes that probel             
                end
            end        
        end
        disp('* RR calcuated')
        
        if saving
           Saving(RR_30,savefolderRR, Neonate, win)
           Saving(RR_300,savefolderRR, Neonate, win)           
           disp('* RR saved')
        end
% MAKENG THE INDEX CELL THE SAME LENGTH AS TEH ECG.THIS IS IMPORTANT FOR THE EDR        
        if length(RR_idx_30)<length(RR_30)
            while length(RR_idx_30)<length(RR_30)
                RR_idx_30{end+1}=NaN;
            end
        end
            
        if length(RR_idx_300)<length(RR_300)
            while length(RR_idx_300)<length(RR_300)
                RR_idx_300{end+1}=NaN;
            end
        end
                    
        %% ************ Creating EDR signal from 30s epoch ECG **************
        [EDR_30] =Respiration_from_ECG(ECG_win_30,RR_idx_30,RR_30,500);        
        [EDR_300]=Respiration_from_ECG(ECG_win_300,RR_idx_300,RR_300,500);   

        if saving
           Saving(EDR_30,savefolderEDR, Neonate, win)
           Saving(EDR_300,savefolderEDR, Neonate, win)           
           disp('* EDR saved')
        end        
        
    %% ************ Creating spectrum for ECG-Signal **************         
       [powerspectrum,f]=Lomb_scargel_single(RR_300,RR_idx_300,t_300,Neonate,saving,savefolderHRVfreq,win) ;
       [powerspectrumEDR,fEDR]=Lomb_scargel_single(EDR_300,RR_idx_300,t_300,Neonate,saving,savefolderHRVfreq,win) ;

        disp('* Periodogram calculated')

    %%  ************ AGE & Weight **************    
    for k=1:length(RR_30)
        Birthweight{k}=Pat_weight(I);
        GA{k}=Pat_GA(I); 
        CA{k}=Pat_CA(I);
        Age_diff{k}=Pat_GACA(I);
    end
    if saving
        Saving(Birthweight,savefolderHRVweightAge, Neonate, win)
        Saving(GA,savefolderHRVweightAge, Neonate, win)
        Saving(CA,savefolderHRVweightAge, Neonate, win)
        Saving(Age_diff,savefolderHRVweightAge, Neonate, win)        
        disp('* Age and Weight saved')
    end  

    %% ************ CALCULATE FEATURES **************
    %%%%%%%% FULL SIGNALS 
        disp('Full Signal analysis start') 
    
          ECG_HRV_power(powerspectrum,RR_30,ECG_win_30,RR_300,ECG_win_300,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S)
             disp('- totalECG finished')
          if strcmp('ECG',dataset)==1
            Resp_EDR(Resp_win_300,Resp_win_30,EDR_win_300,EDR_win_30,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S)    
             disp('- EDR finished')
          end
% 
%     %%%%%%%% ECG TIME DOMAIN     
        disp('ECG time domain analysis start') 

        Beats_per_Epoch(RR_300,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S)   % S for session number
             disp('- aBpE finished') 
        linelength(ECG_win_300,t_300,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S)     
             disp('- Linelength finished')
        meanarclength(ECG_win_30,t_30,Neonate,saving,savefolderHRVtime,win,faktor,Sessions(S,1).name,S) 
             disp('- Mean linelength finished')
        SDLL(ECG_win_30,t_30,Neonate,saving,savefolderHRVtime,win,faktor,Sessions(S,1).name,S) %Standart derivation of 5min linelength
             disp('- SDLL finsihed')
        SDaLL(ECG_win_30,t_30,Neonate,saving,savefolderHRVtime,win,faktor,Sessions(S,1).name,S) %Standart derivation of 30s linelength meaned over 5min
             disp('- SDaLL finished') 

% 
% %   %%%%%%%% HRV TIME DOMAIN
        disp('HRV time domain analysis start')

        SDNN(RR_300,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S);
            disp('- SDNN finished') 
        RMSSD(RR_300,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S);
            disp('- RMSSD finished')  
        NNx(RR_300,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S);
            disp('- NNx finished') 
        pNNx(RR_300,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S);
            disp('- pNNx finished') 
        SDANN(RR_30,Neonate,saving,savefolderHRVtime,win,faktor,Sessions(S,1).name,S);
            disp('- SDANN finished')
        pDec(RR_300,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S);
            disp('- pDEC finished') 
        SDDec(RR_300,Neonate,saving,savefolderHRVtime,win,Sessions(S,1).name,S);
           disp('- SDDec finished')
 
%           
% %   %%%%%%% HRV Frequency domain
        disp('Frequency time domain start')

        freqdomainHRV (powerspectrum,f,Neonate,win,saving,savefolderHRVfreq,Sessions(S,1).name,S)
           disp('- Frequency finished') 
        freqdomainEDR (powerspectrumEDR,fEDR,Neonate,win,saving,savefolder,S)
           disp('- EDR requency finished')    
% 
%     %%%%%%% HRV Non linear
        disp('Nonlinear analysis start')

        SampEn_QSE_SEAUC(RR_300,Neonate,saving,savefolderHRVnonlin,win,faktor,Sessions(S,1).name,S ) %
            disp('- SampEn QSE SEAUC finished')
        LempelZivECG(ECG_win_300,Neonate,saving,savefolderHRVnonlin,win,Sessions(S,1).name,S)  
          disp('- LepelZiv ECG finished')         
        LempelZivRR(RR_300,Neonate,saving,savefolderHRVnonlin,win,Sessions(S,1).name,S);
          disp('- LepelZiv HRV finished')   
%         LempelZivEDR(EDR_300,Neonate,saving,savefolderHRVnonlin,win,Sessions(S,1).name,S);
%           disp('- LepelZivR HRV finished') 
%         SampEn_QSE_SEAUC_EDR(EDR_300,Neonate,saving,savefolder,win,Sessions(S,1).name,S);
%             disp('- SampEn QSE SEAUC finished R')

        clearvars ECG_win_300 ECG_win_30 t_ECG_300 t_ECG_30 RR_idx_300 RR_300 RR_idx_30 RR_30 powerspectrum f
        
%     end %Sessionp
 end% Patient
 toc
 %% Nested saving
    function Saving(Feature,savefolder, Neonate, win)
        if exist('Feature','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_win_' num2str(win) '_' num2str(Neonate)],'Feature')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end
    function SavingAnnotations(Annotations,savefolder, Neonate, win)
        if exist('Annotations','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_win_' num2str(win) '_' num2str(Neonate)],'Annotations')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end
