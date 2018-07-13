%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file :
% ECGs are loaded per patient.
% annotations are loaded per patient.
%   If two annotators agree, we take the annotation
% The data is split in 30 sec epochs
% If possible remove outliers
% The Rpeaks per patient are created
% The features per patient are created
% A Feature and annotation Matirx is created per patient

% This file soes not cut the data into AS or QS. It is a single stream of
% HRV values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load ECG per patient
tic
clearvars -except p o
clc
Matlabbase='C:\Users\310122653\Documents\PhD\Matlab\InnerSence Data specific\ECR-RR creation\';



pat=[3,4,5,6,7,9,10,13,15];
% pat=[3,4,5,6,7,9,13,15]; 
% pat=4
saving=1;
plotting=0;

path='E'; % the HDD file with the patient data. Needed for loading ECG

win=[30 60 150 300];

%%%%%%%%%%%%%% start calling functions         

    for i=1:length(pat)
        disp('..........................')
        disp(['working on patient ' num2str(pat(i))] )
        Neonate=pat(i);

%%%%%%%%%%%%%% Load ECG information 
        cd(Matlabbase)
       [sheet,lead,FS]=callingSheetsLeadsandFS(Neonate); % calling which sheet has to be chosen for the annotation, which lead for the ECG and which FS results from that
       
%%%%%%%%%%%%%% Load the data
        cd(Matlabbase)
       [~,ECG_raw]=loading_ecg(path,Neonate,sheet,lead,FS);
        disp('Data loaded')

%%%%%%%%%%%%% eliminating the cargiving in the ECG (nan) %%%%%%%%%%
       cd(Matlabbase)

      [ECG_nocare]=eliminate_care_giving(path,Neonate,sheet,lead,FS,Matlabbase); % Caregiving events in ECG are nan deteted by temperature drops
% 
      if FS==250 % interpolating the ECG data fom 250Hz to 500Hz FS
          ECG_nocare=interp(ECG_nocare,2);
          FS=500;
          disp(['for patient ' num2str(Neonate) ' the ECG was interpolated to 500 Hz' ] )
      end
      
    disp('caregiving eliminated')     
 
%%%%%%%%%%%%% Load and sort Annotaion per patient
% The outputfile has One ECG stream with annotations for each value. The annotations are expanded to 30s
    cd(Matlabbase)
    savefolderECG=([path ':\InnerSence\processed data\ECG\']);
   [FS,consence_ECG,consence_ECG_30s]=Combine_ECG_and_annotations(ECG_nocare,Neonate,sheet,lead,FS, saving, savefolderECG); % +quiet alertness, active alertness, reliability, transition, position
                                                                                                                            % consence_ECG is all ECG samples joint with annotations
                                                                                                                            % consence_ECG_30s is all ECG samples joint with annotations separated into 30s cells
    disp('ECG and annotations combined')
%%%%%%%%%%%%% Calculate RR peaks

    cd(Matlabbase)
    loadfolder=savefolderECG;

    usingRalphsRpeakdetetor_onestream(Neonate,FS,plotting,saving,loadfolder,savefolderECG)

%%%%%%%%%%%%% Create x min windows
    cd(Matlabbase)
    loadfolder=savefolderECG;

    SlidingWindow(Neonate,win,saving,loadfolder,savefolderECG)  
    disp(['data is merged into windows of length: ' num2str(win) ] )
    
%%%%%%%%%%%%% Power specturm with lomb scargle
    loadfolder=savefolderECG;
    savefolderSpectrum=([path ':\InnerSence\processed data\ECG\Spectrum\']);
    cd(Matlabbase)
    
    Lomb_scargel_30secepoch(Neonate,plotting,win,saving, loadfolder, savefolderSpectrum)

    toc 
    end