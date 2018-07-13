%Calculate mean std, and mean and inter quartile range
clear
clc
tic

Matlabbase='C:\Users\310122653\Documents\PhD\Matlab\InnerSence Data specific\Additional stuff';
path='E'; % the HDD file with the patient data. Needed for loading ECG
datapath=([path ':\InnerSence\processed data\']);

pat=[3,4,5,6,7,9,13,15]; 
% pat=5
saving=1;
plotting=0;
win=[60 150 300];
AS_60=[];QS_60=[];AS_150=[];QS_150=[];AS_300=[];QS_300=[];

for i=1:length(pat)
        disp('..........................')
        disp(['creating Matrix for patient ' num2str(pat(i))] )
        Neonate=pat(i);
       cd(Matlabbase) 
         loadfolder=([datapath 'Matrices\']);
[medianAS_300,medianQS_300,InterQrang_AS_300,InterQrang_QS_300,AS_60,QS_60,AS_150,QS_150,AS_300,QS_300]=statisticsbetweenAS_QS(Neonate,win,loadfolder,AS_60,QS_60,AS_150,QS_150,AS_300,QS_300)

end
toc
