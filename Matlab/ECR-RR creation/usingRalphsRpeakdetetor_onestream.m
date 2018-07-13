function usingRalphsRpeakdetetor_onestream(Neonate,FS,plotting,saving,loadfolder,savefolder)
cd('C:\Users\310122653\Documents\PhD\Matlab\R peak detection and HRV\RAlps Rpeak detection')
    if Neonate==13
    FS=500;% The FS of pat 13 is interpolatet before to 500 HZ
    end
    
%%%%%% loading annotated ECG signals
    if exist  (([loadfolder '' num2str(Neonate) '.mat']),'file')
     load ([loadfolder 'consence_ECG_consence_ECG_' num2str(Neonate) '.mat']);
    end
    
    if exist (([loadfolder 'consence_ECG_' num2str(Neonate) '_win_30.mat']),'file')
     load ([loadfolder 'consence_ECG_' num2str(Neonate) '_win_30.mat']);
    end
   
%%%%%%%%%%%%%% R-PEAK DETECTION


%%%%%%%%%%% AS and QS    
      if exist('consence_ECG_30s','var')==1
        for i=1:length(consence_ECG_30s)
            if isempty(consence_ECG_30s{1,i})== 0 & nansum(consence_ECG_30s{1,i}(2,:))~=0  % due to the elimination of caregiving there can be nan`s instead of values    
               if range(consence_ECG_30s{1,i}(2,:))~=0
                     [ecg_r_peak_idx, ~,~,~, ~, bbi_ecg, bpm_ecg] = ...
                                        ecg_find_rpeaks(consence_ECG_30s{1,i}(1,:)', consence_ECG_30s{1,i}(2,:)', FS, 250,0,saving);
               end
               %The data
               consence_RR_30s{1,i}(1,:)=consence_ECG_30s{1,i}(1,ecg_r_peak_idx); % time vector for R peak in time from ECG
               consence_RR_30s{1,i}(2,:)=bbi_ecg;
               %The annotations
               consence_RR_30s{1,i}(3,:)=consence_ECG_30s{1,i}(3,ecg_r_peak_idx);
               consence_RR_30s{1,i}(4,:)=consence_ECG_30s{1,i}(4,ecg_r_peak_idx);
               consence_RR_30s{1,i}(5,:)=consence_ECG_30s{1,i}(5,ecg_r_peak_idx);
               consence_RR_30s{1,i}(6,:)=consence_ECG_30s{1,i}(6,ecg_r_peak_idx);
               consence_RR_30s{1,i}(7,:)=consence_ECG_30s{1,i}(7,ecg_r_peak_idx);
               consence_RR_30s{1,i}(8,:)=consence_ECG_30s{1,i}(8,ecg_r_peak_idx);
               consence_RR_30s{1,i}(9,:)=consence_ECG_30s{1,i}(9,ecg_r_peak_idx);
               
               if length(consence_RR_30s{1,i}) <= 10 % due to false R peak detection cell can be very small. To avoid errors we delet this specific cell
                   consence_RR_30s{1,i}=[];
               end
                                             
               consence_RR_30s{1,i}=consence_RR_30s{1,i}(:,2:end); %removing first value due to nan in RRdistance    
            end % if isempty
        end     % for length 
      end       % if exist
      
      if saving
          if exist('consence_RR_30s','var')
              save([savefolder 'consence_RR_' num2str(Neonate) '_win_30.mat'],'consence_RR_30s')  ; 
          end
      end

end             % function
      
     
