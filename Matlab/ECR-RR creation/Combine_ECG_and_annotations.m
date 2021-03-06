function Combine_ECG_and_annotations(ECG_nocare,Neonate,sheet,lead,FS, saving,savefolderECG,savefolderA)

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

longAnnot=max([length(aJB),length(aRO),length(aNB)])-1;  %length of annotation minus one because of flooring lenght of ECG to make it fit the 30 sec epochs
longECG=length(ECG_nocare);                              %length of ECG data
faktor=FS*30;                                            %30 second epochs via FS
    t=(0:1/FS:longECG/FS);                               %time vector
t=t(1,1:end-1);                                          %generate same length for time vector as for ECG vector
% longB=faktor*floor(longB/faktor);                      %make the length fitting to a integer of 30 epochs
% info=[Neonate,longB,faktor]                 
i=1;                                                     %set variables
j=1;

ECGwAnnotations=zeros(23,longECG);                       %preallocation

%%creating matrix, writing time and ECG into matrix
ECGwAnnotations(1,:)=t;                                  %copy time vector into matrix
ECGwAnnotations(2,:)=ECG_nocare;                         %copy ECG without care  into matrix

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
                ECGwAnnotations(3,i:i+faktor)=2; %QS
        
            elseif aRO(j,6) == 999
                ECGwAnnotations(3,i:i+faktor)=1; %AS
            
            elseif aRO(j,7) == 999
                ECGwAnnotations(3,i:i+faktor)=3; %quite alertness
            
            elseif aRO(j,8) == 999
                ECGwAnnotations(3,i:i+faktor)=3; %active alertness
            end
            if aRO(j,11)~=998
                ECGwAnnotations(3,i:i+faktor)=6; %transition 
            end
   
            if aRO(j,10)~=998
                ECGwAnnotations(3,i:i+faktor)=0; %Unable to score
            end   
            if aRO(j,13)==2
                ECGwAnnotations(3,i:i+faktor)=0; %Out of Bed
            end     
            if aRO(j,12) == 999
                ECGwAnnotations(6,i:i+faktor)=1; %not reliable..use as IS?
            end  
%             if aRO(j,14)~=998
%                 ECGwAnnotations(3,i:i+faktor)=1; %position 
%             end              
%%%%% Annotations of JB                
            if aJB(j,5) == 999
                ECGwAnnotations(4,i:i+faktor)=2; %QS
        
            elseif aJB(j,6) == 999
                ECGwAnnotations(4,i:i+faktor)=1; %AS
            
            elseif aJB(j,7) == 999
                ECGwAnnotations(4,i:i+faktor)=3; %quite alertness
            
            elseif aJB(j,8) == 999
                ECGwAnnotations(4,i:i+faktor)=3; %active alertness
            end
            if aJB(j,11)~=998
                ECGwAnnotations(4,i:i+faktor)=6; %transition 
            end
   
            if aJB(j,10)~=998
                ECGwAnnotations(4,i:i+faktor)=0; %Unable to score
            end   
            if aJB(j,13)==2
                ECGwAnnotations(4,i:i+faktor)=0; %Out of Bed
            end     
            if aJB(j,12) == 999
                ECGwAnnotations(7,i:i+faktor)=1; %not reliable..use as IS?
            end  
%             if aJB(j,14)~=998
%                 ECGwAnnotations(3,i:i+faktor)=1; %position 
%             end     
%%%%% Annotations of Nadice B
            if aNB(j,5) == 999
                ECGwAnnotations(5,i:i+faktor)=2; %QS
        
            elseif aNB(j,6) == 999
                ECGwAnnotations(5,i:i+faktor)=1; %AS
            
            elseif aNB(j,7) == 999
                ECGwAnnotations(5,i:i+faktor)=3; %quite alertness
            
            elseif aNB(j,8) == 999
                ECGwAnnotations(5,i:i+faktor)=3; %active alertness
            end
            if aNB(j,11)~=998
                ECGwAnnotations(5,i:i+faktor)=6; %transition 
            end
   
            if aNB(j,10)~=998
                ECGwAnnotations(5,i:i+faktor)=0; %Unable to score
            end   
            if aNB(j,13)==2
                ECGwAnnotations(5,i:i+faktor)=0; %Out of Bed
            end     
            if aNB(j,12) == 999
                ECGwAnnotations(8,i:i+faktor)=1; %not reliable..use as IS?
            end  
%             if aNB(j,14)~=998
%                 ECGwAnnotations(3,i:i+faktor)=1; %position 
%             end
        i=i+faktor;
    end 
    j=1; i=1; k=1;
   
    
    %ECGwithAnnotations looks now like: time, ECG, Annotations, Not reliable
    load(['C:\Users\310122653\Documents\PhD\Article_2_(EHV)\Raw_Data\Data files\All files\index of feeding moments\Baby' num2str(Neonate) '\indexFood'])

%     consence_ECG=nan(10,length(ECGwAnnotations));   %placeholder for annotations
    consence_ECG=nan(4,length(ECGwAnnotations));   %placeholder for annotations
    
    consence_ECG(1,:)=ECGwAnnotations(1,:);        %time                     
    consence_ECG(2,:)=ECGwAnnotations(2,:);        %ECG
    
    [Val,AMount,~]=mode(ECGwAnnotations([3 4 5],:));
    
    Pos=AMount==3; consence_ECG(3,Pos)=Val(Pos); % where all agree
    Pos=AMount==2; consence_ECG(3,Pos)=Val(Pos); % where two agree get most common value(mode) 
    Pos=AMount==1; consence_ECG(3,Pos)=ECGwAnnotations(3,Pos);% where non agree use Renees Annottations
    if sum(isnan(consence_ECG(3,:)))>0;  consence_ECG(3,Pos)=ECGwAnnotations(5,Pos);  end  % if still nans exist that measn Renee did not fully annotate, then rather choose nadice 
    consence_ECG(3,indexFood)=4;%Care Taking overwrites any 0 ; Taken from Toine

%  
%     Pos=nansum(ECGwAnnotations([6 7 8],:))>=2;    consence_ECG(3,Pos)=1;%AS
%     Pos=nansum(ECGwAnnotations([3 4 5],:))>=2;    consence_ECG(3,Pos)=2;%QS
%     Pos=nansum(ECGwAnnotations([9 10 11],:))>=2;  consence_ECG(3,Pos)=3;%quit alertness
%     Pos=nansum(ECGwAnnotations([12 13 14],:))>=2; consence_ECG(3,Pos)=3;%Active alertness
%     Pos=nansum(ECGwAnnotations([18 19 20],:))>=2; consence_ECG(3,Pos)=6;%transition
%     Pos=nansum(ECGwAnnotations([24 25 26],:))>=2; consence_ECG(3,Pos)=0;%Unable to score        
%     Pos=nansum(ECGwAnnotations([15 16 17],:))>=2; consence_ECG(4,Pos)=1;%Not reliable
%                                                   consence_ECG(3,indexFood)=4;%Care Taking
%     Pos=nansum(ECGwAnnotations([27 28 29],:))>=2; consence_ECG(3,Pos)=0;%Out of Bed 
%     
%   

%make 30s cells
    for j=1:faktor:floor(length(consence_ECG)/faktor)*faktor % for the length of ECG as long as it can be separated into 30s
        ECG_30s{i}=consence_ECG([1,2],[j:j+faktor]);      
        Annotations_30s{i}=mode(consence_ECG([3],[j:j+faktor]));
        i=i+1;
    end
    if floor(length(consence_ECG)/faktor)*faktor < (length(consence_ECG)/faktor)*faktor % for the last where not full 30s data exists
        ECG_30s{i}=consence_ECG([1,2],[j+faktor:end]);      
        Annotations_30s{i}=mode(consence_ECG(3,[j+faktor:end]));
    end    
    i=1;
% plain data in array form
    ECG=consence_ECG([1,2],:);      
    Annotations=consence_ECG(3,:);
    
    if saving
       if exist('ECG_30s','var') 
           save([savefolderECG 'ECG_' num2str(Neonate) '_win_30.mat'],'ECG_30s')  ; 
       end
       if exist('Annotations_30s','var') 
           save([savefolderA 'Annotations_' num2str(Neonate) '_win_30.mat'],'Annotations_30s')  ; 
       end    
       if exist('ECG','var') 
           save([savefolderECG 'ECG_' num2str(Neonate) '.mat'],'ECG')  ; 
       end
       if exist('Annotations','var') 
           save([savefolderA 'Annotations_' num2str(Neonate) '.mat'],'Annotations')  ; 
       end              
    end
end
