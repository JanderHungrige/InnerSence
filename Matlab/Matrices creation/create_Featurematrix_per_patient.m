    % this function will create the input feature matrix for principal
% component analysis
%Thereby, the n by m matrix will have the fearture values as collums (x)and
%the features as rows (y)
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%THIS M FILE INCLUDES ALL CLASSES, AS QS WAKE IS ...
%WHILE pcaMatrix.m ONLY INCLUDES AS AND QS
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Feature List

%%%%%short term frequency domain features (1,2.5,5min)
% total power (<0.1.5 Hz)
% VLF power in very low frequency range (adult 0.003-0.04 Hz)
% LF  power in low frequency range (adult 0.04-0.15 Hz)
% LFnorm  LF power in normalized units LF/(total power-vlf)x100 or LF/(LF+HF)*100
% HF power in high frequency range (adult 0.15-0.4 Hz)
% HFnorm HF power in normalized units HF/(total power-vlf)x100 or HF/(LF+HF)*100
% LF/HF Ratio LF/HF
% LF/HFsHFuHF
% LF/sHFuHF
% sHF (0.4-0.7 Hz)
% uHF (0.7-1.5 Hz)

% normalized total power 
% normalized VLF
% normalized LF  
% normalized LFnorm 
% normalized HF power 
% normalized HFnorm 
% noralized LF/HF 
% normalized LF/HFsHFuHF
% normalized LF/sHFuHF
% normalized sHF 
% normalized uHF 

%%%%%short term time domain features (1,2.5,5min)
% SDNN;
% (SDANN)
% RMSSD
% NNx (50,30,20,10)
% pNNx (50,30,20,10)
% BpE


function create_Featurematrix_per_patient(Neonate,win,saving,LoadfolderAnnotations,LoadfolderTimedomain,LoadfolderFreqdomain,savefolder,savefolderNames)
disp('creating feature Matrix')
    for j=1:length(win)
        Neonate;
        disp(['working on window: ' num2str(win(1,j))]);

        folderT=dir([LoadfolderTimedomain '*_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']);
        folderF=dir([LoadfolderFreqdomain '*_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']);
%% 
%%%%% Feature Matrix per patient 

%Time domain
        Feature_Matrix_time=[];
        for k=1:length(folderT)
            load([LoadfolderTimedomain folderT(k,1).name],'Feature'); 
            featurenamesTMP{k,1}=split(folderT(k,1).name,'_');featurenamesTMP{k,1}=featurenamesTMP{k,1}(1,1);
            for n=1:length(Feature)  
                if isnan(Feature{1,n})==0 & isempty(Feature{1,n})==0
                    tmp(1,n)=Feature {1,n};
                end
            end
            Feature_Matrix_time(k,:)=tmp;% could also work with: ...Feature_Matrix=[Feature_Matrix ; tmp];
        end
        clearvars tmp

%Frequency domain
        Feature_Matrix_frequeny=[];
        for k=1:length(folderF)
            load([LoadfolderFreqdomain folderF(k,1).name],'Feature'); 
            featurenamesTMP2{k,1}=split(folderF(k,1).name,'_');featurenamesTMP2{k,1}=featurenamesTMP2{k,1}(1,1);            
            for n=1:length(Feature)  
                if isnan(Feature{1,n})==0 & isempty(Feature{1,n})==0
                    tmp(1,n)=Feature {1,n};
                end
            end
            Feature_Matrix_frequeny(k,:)=tmp;% could also work with: ...Feature_Matrix=[Feature_Matrix ; tmp];
        end
        clearvars tmp 
        
%Mergin Time and Frequency Features in one Matrix        
        Feature_Matrix=[Feature_Matrix_time;  Feature_Matrix_frequeny];
        FeatureNames=[featurenamesTMP; featurenamesTMP2];
        
        
        
%% 
%%%%% Annotation Matrix per patient

%preallocation. Is needed , otherwise [] epochs are merged and lead to dimension missmatch
            tmp0=nan(1,length(Feature));
            tmp =nan(1,length(Feature));
            tmp2=nan(1,length(Feature));
            tmp3=nan(1,length(Feature));   
            tmp4=nan(1,length(Feature));  
            
            load([LoadfolderTimedomain folderT(1,1).name],'Feature'); 
            sampleWeight=ones(1,length(Feature)); % First declare samleWeight with every sample weighted 1 (more precice later the sample weight can be multiplied with this vector. Then 1* x stays the same)           
            for n=1:length(Feature)  
                if isnan(Feature{1,n})==0 & isempty(Feature{1,n})==0
                    if Feature{2,n}(1)==1 %AS
                        tmp0(1,n)=1;    % for AS / QS
                        tmp (1,n)=1;    % for AS / QS / QA / AA
                        tmp2(1,n)=1;    % for AS / QS / W
                        tmp3(1,n)=1;    % for AS / QS / W  / T
                        tmp4(1,n)=1;    % for S  / W                        
                    elseif Feature{2,n}(2)==1 %QS
                        tmp0(1,n)=2;
                        tmp (1,n)=2;
                        tmp2(1,n)=2;
                        tmp3(1,n)=2;   
                        tmp4(1,n)=1;                               
                    elseif Feature{2,n}(3)==1 %Quite allertness
                        tmp0(1,n)=nan;                        
                        tmp (1,n)=3;
                        tmp2(1,n)=3;
                        tmp3(1,n)=3;  
                        tmp4(1,n)=3;                               
                    elseif Feature{2,n}(4)==1 %Active allertness
                        tmp0(1,n)=nan;                        
                        tmp (1,n)=4;
                        tmp2(1,n)=3;
                        tmp3(1,n)=3; 
                        tmp4(1,n)=3;                               
                    end
                    %-------------------------------------------    
                    if Feature{2,n}(5)==1 % Not reliable
                        %count them as the class but create new MAtrix. The samples can be weighted individual ( http://scikit-learn.org/stable/auto_examples/svm/plot_weighted_samples.html )                                     
                        sampleWeight(1,n)=0.5; % Reduce the multiplication factor of sampleWeigth by e.g. 0.5
                    end  
                    if Feature{2,n}(6)==1 % Transition
                        tmp3(1,n)=6; % 
                    end                                                                          
                end   % if isnan or empty     
            end% for each epoch         
            
            %If no annotation or no data from the Feature the annotation is NaN to keep the proper length. Otheriwse dimension mismatch. Deleting the NaN to [] is not possible as the NaN at the end will shorten the MAtrix again leading to dimension missmatch
            Annotation_Matrix_ASQS=tmp0;               % This Matrix consists of:  AS QS;
            Annotation_Matrix_all_except_Trans=tmp;   % This Matrix consists of:  AS QS Quite allertness and Active allertness                    
            Annotation_Matrix_combined_wake=tmp2;     % This Matrix consists of:  AS QS Wake;            
            Annotation_Matrix_incl_transition=tmp3;   % This Matrix consists of:  AS QS Wake Transition;  
            Annotation_Matrix_sleep_wake=tmp4;        % This Matrix consists of:  Sleep Wake;  

            [r c]=find(isnan(Feature_Matrix(1,:))); Feature_Matrix(:,c)=nan; %mix of Nan and 0. All into Nan
            
%%
%%%%% Saving
        if saving==1
            Saving(Feature_Matrix,                      savefolder,Neonate, win(1,j))

            Saving(Annotation_Matrix_ASQS,              savefolder,Neonate, win(1,j))        
            Saving(Annotation_Matrix_all_except_Trans,  savefolder,Neonate, win(1,j))
            Saving(Annotation_Matrix_combined_wake,     savefolder,Neonate, win(1,j))
            Saving(Annotation_Matrix_incl_transition,   savefolder,Neonate, win(1,j))
            Saving(Annotation_Matrix_sleep_wake,        savefolder,Neonate, win(1,j))
            
            Saving(sampleWeight,                        savefolder,Neonate, win(1,j))
            
            % saving names of the features
            saving ([savefolderNames 'FeatureNames'],'FeatureNames')
        end
    
    end %window
%%                    
%%%%% Nested saving        
    function Saving(Matrix,savefolder, Neonate, win)
        if exist('Feature','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_' num2str(Neonate) '_win_' num2str(win)],'Matrix')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end    
        
end