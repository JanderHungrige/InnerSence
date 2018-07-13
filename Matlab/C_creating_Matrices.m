% this m file calls functions to create annotation Matrix and feature matrix  

clear
clc
tic

Matlabbase='C:\Users\310122653\Documents\PhD\Matlab\InnerSence Data specific\Matrices creation\';
path='E'; % the HDD file with the patient data. Needed for loading ECG
datapath=([path ':\InnerSence\processed data\']);

pat=[3,4,5,6,7,9,13,15]; 
% pat=5
saving=0;
plotting=0;
win=[30 60 150 300];

savefolderNames=[path ':\InnerSence\processed data\'];


for i=1:length(pat)
        disp('..........................')
        disp(['creating Matrix for patient ' num2str(pat(i))] )
        Neonate=pat(i);

        LoadfolderTimedomain=([datapath 'HRV-features\timedomain\']);
        LoadfolderFreqdomain=([datapath 'HRV-features\freqdomain\']);
        LoadfolderAnnotations=([datapath 'ECG\']);
        savefolder=([datapath 'Matrices\']);

        cd(Matlabbase)
    create_Featurematrix_per_patient(Neonate,win,saving,LoadfolderAnnotations,LoadfolderTimedomain,LoadfolderFreqdomain,savefolder,savefolderNames);
    
        cd(Matlabbase)
        Loadfolder=savefolder;
    RemoveNaNoverallMatrices(Neonate,win,saving,Loadfolder,savefolder);

end
toc