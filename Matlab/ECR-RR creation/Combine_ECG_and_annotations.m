function [FS,consence_ECG,consence_ECG_30s]=Combine_ECG_and_annotations(ECG_nocare,Neonate,sheet,lead,FS, saving,savefolder)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file loads the annotation
% elonginates the annotations to 30 sec epoch to join with ECG (Annot. are per 30s epoch)
% Finds where at least two anntotators agree
% Put the ECG time and agreed annotations in one Matrix
% Sae that Matrix per patient
%
%Input: Neonate: which neonate form 3,4,5,6,7,9,10,13,15
       %sheet: excel sheet with annotations of neonate
       %lead: which ECG lead 13 to 18 possible
       %FS: sample frequency. This will actually be calculated from the length and time in this function 
       %saving: if you want to save; 1= Yes
       %savefolder: Where to save. This is set in the Main_one_stream.m 


%%loadig annotations
aRO=xlsread ('C:\Users\310122653\Documents\PhD\InnerSense Data\Annotation\AnnotationsCBT_RO',sheet); % Annotations by Renee Otte
aJB=xlsread ('C:\Users\310122653\Documents\PhD\InnerSense Data\Annotation\AnnotationsCBT_JB',sheet); % Annotations by ...
aNB=xlsread ('C:\Users\310122653\Documents\PhD\InnerSense Data\Annotation\AnnotationsCBT_NB',sheet);

aRO(isnan(aRO))=998;
aJB(isnan(aJB))=998;
aNB(isnan(aNB))=998;

longECG=length(ECG_nocare);                     %length of ECG data
longAnnot=size(aRO)-1;                          %length of annotation minus one because of flooring lenght of ECG to make it fit the 30 sec epochs
faktor=FS*30;                                   %30 second epochs via FS
    t=(0:1/FS:longECG/FS);                      %time vector
t=t(1,1:end-1);                                 %generate same length for time vector as for ECG vector
% longB=faktor*floor(longB/faktor);             %make the length fitting to a integer of 30 epochs
% info=[Neonate,longB,faktor]                 
i=1;                                            %set variables
j=1;

ECGwAnnotations=zeros(23,longECG);              %preallocation

%%creating matrix, writing time and ECG into matrix
ECGwAnnotations(1,:)=t;                          %copy time vector into matrix
ECGwAnnotations(2,:)=ECG_nocare;                 %copy ECG without care  into matrix

%%connecting ECG and annotations over the whole time
%transition phases
                % 0	unable to score
                % 1	Deep -> Active	
                % 2	Active -> Deep	
                % 3	Active -> Awake	
                % 4	Awake -> Active	
%positions
                % 0	unable to score epoch
                % 1	back
                % 2	belly
                % 3	left
                % 4	right
                % 5	knees
                % 6	transition

    for j=1:longAnnot(1,1)
%%%%% Annotations of Renee Otte     
            if aRO(j,5) == 999
                ECGwAnnotations(3,i:i+faktor)=1; %QS
            end
            if aRO(j,6) == 999
                ECGwAnnotations(4,i:i+faktor)=1; %AS
            end
            if aRO(j,7) == 999
                ECGwAnnotations(9,i:i+faktor)=1; %quite alertness
            end
            if aRO(j,8) == 999
                ECGwAnnotations(10,i:i+faktor)=1; %active alertness
            end
            if aRO(j,12) == 999
                ECGwAnnotations(11,i:i+faktor)=1; %not reliable..use as IS?
            end
            if aRO(j,11)~=998
                ECGwAnnotations(12,i:i+faktor)=1; %transition 
            end
            if aRO(j,14)~=998
                ECGwAnnotations(21,i:i+faktor)=1; %position 
            end               
%%%%% Annotations of JB                
            
             if aJB(j,5) == 999
                ECGwAnnotations(5,i:i+faktor)=1; %QS
            end
            if aJB(j,6) == 999
                ECGwAnnotations(6,i:i+faktor)=1; %AS
            end
            if aJB(j,7) == 999
                ECGwAnnotations(13,i:i+faktor)=1; %quite alertness
            end
            if aJB(j,8) == 999
                ECGwAnnotations(14,i:i+faktor)=1; %active alertness
            end
            if aJB(j,12) == 999
                ECGwAnnotations(15,i:i+faktor)=1; %not reliable..use as IS?
            end
            if aJB(j,11)~=998
                ECGwAnnotations(16,i:i+faktor)=1; %transition
            end
            if aJB(j,14)~=998
                ECGwAnnotations(22,i:i+faktor)=1; %position 
            end                
%%%%% Annotations of Nadice B
             if aNB(j,5) == 999
                ECGwAnnotations(7,i:i+faktor)=1; %QS
            end
            if aNB(j,6) == 999
                ECGwAnnotations(8,i:i+faktor)=1; %AS
            end
            if aNB(j,7) == 999
                ECGwAnnotations(17,i:i+faktor)=1; %quite alertness
            end
            if aNB(j,8) == 999
                ECGwAnnotations(18,i:i+faktor)=1; %active alertness
            end
            if aNB(j,12) == 999
                ECGwAnnotations(19,i:i+faktor)=1; %not reliable..use as IS?
            end
            if aNB(j,11)~=998
                ECGwAnnotations(20,i:i+faktor)=1; %transition 
            end
            if aNB(j,14)~=998
                ECGwAnnotations(23,i:i+faktor)=1; %position 
            end    
            
        i=i+faktor;
    end 
    j=1; i=1; k=1;
   
    
    %ECGwithAnnotations looks now like: time, ECG, Annotations (QS,AS,QS,AS,QS,AS)

            consence_ECG=nan(9,length(ECGwAnnotations));   %placeholder for annotations
            consence_ECG(1,:)=ECGwAnnotations(1,:);        %time                     
            consence_ECG(2,:)=ECGwAnnotations(2,:);        %ECG
            
    %%Creating one file with ECG of agreed annotations
        
        Pos=nansum(ECGwAnnotations([4 6 8],:))>=2;    consence_ECG(3,Pos)=1;%AS
        Pos=nansum(ECGwAnnotations([3 5 7],:))>=2;    consence_ECG(4,Pos)=1;%QS
        Pos=nansum(ECGwAnnotations([9 13 17],:))>=2;  consence_ECG(5,Pos)=1;%quit alertness
        Pos=nansum(ECGwAnnotations([10 14 18],:))>=2; consence_ECG(6,Pos)=1;%Active alertness
        Pos=nansum(ECGwAnnotations([11 15 19],:))>=2; consence_ECG(7,Pos)=1;%Not reliable
        Pos=nansum(ECGwAnnotations([11 15 19],:))>=2; consence_ECG(8,Pos)=1;%transition
        Pos=nansum(ECGwAnnotations([12 16 20],:))>=2; consence_ECG(9,Pos)=1;%position
        
    i=1;
    for j=1:faktor:faktor*longAnnot(1,1)-faktor % for length of the annotation minus one window with steps of window

        consence_ECG_30s{i}=consence_ECG(:,j:j+faktor);
        i=i+1;
        
    end
        
    if saving
       if exist('consence_ECG','var') 
           save([savefolder 'consence_ECG_' num2str(Neonate) '.mat'],'consence_ECG')  ; 
       end
       if exist('consence_ECG_30s','var') 
           save([savefolder 'consence_ECG_' num2str(Neonate) '_win_30.mat'],'consence_ECG_30s')  ; 
       end       
       
    end
end
