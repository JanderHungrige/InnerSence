function usingRalphsRpeakdetetor30(Neonate,FS,plotting,saving)
    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\ECG clustered by annotations\unsorted\';

    if Neonate==13
    FS=500;% The FS of pat 13 is interpolatet before to 500 HZ
    end
    
%%%%%% loading annotated ECG signals
    if exist  (([folder 'Chunk30_' num2str(Neonate) '.mat']),'file')
     load ([folder 'Chunk30_' num2str(Neonate) '.mat']);
    end
    if exist  (([folder 'Qalertness_' num2str(Neonate) '.mat']),'file')
     load ([folder 'Qalertness_' num2str(Neonate) '.mat']);
    end
    if exist  (([folder 'Aalertness_' num2str(Neonate) '.mat']),'file')
     load ([folder 'Aalertness_' num2str(Neonate) '.mat']);
    end
    if exist  (([folder 'transition_' num2str(Neonate) '.mat']),'file')
     load ([folder 'transition_' num2str(Neonate) '.mat']);
    end     
    if exist  (([folder 'position_' num2str(Neonate) '.mat']),'file')
     load ([folder 'position_' num2str(Neonate) '.mat']);
    end   
    if exist  (([folder 'Not_reliable_' num2str(Neonate) '.mat']),'file')
     load ([folder 'Not_reliable_' num2str(Neonate) '.mat']);
    end      
    
%%%%%% cd save folder    
    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\R peak detection and HRV\RAlps Rpeak detection')
    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\Rpeaks\';

    
%%%%%%%%%%%%%% R-PEAK DETECTION
 
%%%%%%%%%%% AS and QS    
      if exist('ChunkAS','var')==1
        for i=1:length(ChunkAS)
            if isempty(ChunkAS{1,i})== 0
               if nansum(ChunkAS{1,i}(2,:))~=0 % due to the elimination of caregiving there can be nan`s instead of values   
                   if range(ChunkAS{1,i}(2,:))~=0
                   [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                            ecg_find_rpeaks(ChunkAS{1,i}(1,:)', ChunkAS{1,i}(2,:)', FS, 250,plotting,saving);
                   end
                    RpeakAS{1,i}=ecg_r_peak_idx; SpeakAS{1,i}=ecg_s_peak_idx;QRslopeAS{1,i}=ecg_qr_slope_idx;
                    RSslopeAS{1,i}=ecg_rs_slope_idx;STslopeAS{1,i}=ecg_st_slope_idx;RRdistanceAS{1,i}=bbi_ecg;bpm_ecg_AS{1,i}=bpm_ecg;
%                     RpeakAStiming{1,i}=ChunkAS{1,i}(1,RpeakAS{1,i});%creating continues timevector with the Rpeaks from the ECG
                    RpeakAStiming{1,i}=ChunkAS{1,i}(1,RpeakAS{1,i}(1,2:end)); %removing first value due to nan in RRdistance

               end
            end
        end
      end
      
      if exist('ChunkQS','var')==1
        for j=1:length(ChunkQS)
            if isempty(ChunkQS{1,j})== 0
               if nansum(ChunkQS{1,j}(2,:))~=0 % due to the elimination of caregiving ther can be nan`s instead of values          
                  if range(ChunkQS{1,j}(2,:))~=0
                   [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                            ecg_find_rpeaks(ChunkQS{1,j}(1,:)', ChunkQS{1,j}(2,:)', FS, 250,plotting,saving);
                  end
                    RpeakQS{1,j}=ecg_r_peak_idx; SpeakQS{1,j}=ecg_s_peak_idx;QRslopeQS{1,j}=ecg_qr_slope_idx;
                    RSslopeQS{1,j}=ecg_rs_slope_idx;STslopeQS{1,j}=ecg_st_slope_idx;RRdistanceQS{1,j}=bbi_ecg;bpm_ecg_QS{1,j}=bpm_ecg;
                    RpeakQStiming{1,j}=ChunkQS{1,j}(1,RpeakQS{1,j}(1,2:end)); %removing first value due to nan in RRdistance            
%                     RpeakQStiming{1,j}=ChunkQS{1,j}(1,RpeakQS{1,j});
               end
            end
        end   
      end

%%%%%%%%%%%%%%% WAKE
      if exist('Qalertness','var')==1
        for i=1:length(Qalertness)
            if isempty(Qalertness{1,i})== 0
               if (nansum(Qalertness{1,i}(2,:))~=0) % due to the elimination of caregiving there can be nan`s instead of values   
                   if range(Qalertness{1,i}(2,:))~=0
                   [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                            ecg_find_rpeaks(Qalertness{1,i}(1,:)', Qalertness{1,i}(2,:)', FS, 250,plotting,saving);
                   end
                    RpeakQalertness{1,i}=ecg_r_peak_idx; SpeakQalertness{1,i}=ecg_s_peak_idx;QRslopeQalertness{1,i}=ecg_qr_slope_idx;
                    RSslopeQalertness{1,i}=ecg_rs_slope_idx;STslopeQalertness{1,i}=ecg_st_slope_idx;RRdistanceQalertness{1,i}=bbi_ecg;bpm_ecg_Qalertness{1,i}=bpm_ecg;
%                     RpeakAStiming{1,i}=ChunkAS{1,i}(1,RpeakAS{1,i});%creating continues timevector with the Rpeaks from the ECG
                    RpeakQalertnesstiming{1,i}=Qalertness{1,i}(1,RpeakQalertness{1,i}(1,2:end)); %removing first value due to nan in RRdistance
               end
            end
        end
      end
      
      if exist('Aalertness','var')==1
        for j=1:length(Aalertness)
            if isempty(Aalertness{1,j})== 0
               if nansum(Aalertness{1,j}(2,:))~=0 % due to the elimination of caregiving ther can be nan`s instead of values          
                   if range(Aalertness{1,j}(2,:))~=0
                   [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                            ecg_find_rpeaks(Aalertness{1,j}(1,:)', Aalertness{1,j}(2,:)', FS, 250,plotting,saving);
                   end
                    RpeakAalertness{1,j}=ecg_r_peak_idx; SpeakAalertness{1,j}=ecg_s_peak_idx;QRslopeAalertness{1,j}=ecg_qr_slope_idx;
                    RSslopeAalertness{1,j}=ecg_rs_slope_idx;STslopeAalertness{1,j}=ecg_st_slope_idx;RRdistanceAalertness{1,j}=bbi_ecg;bpm_ecg_Aalertness{1,j}=bpm_ecg;
                    RpeakAalertnesstiming{1,j}=Aalertness{1,j}(1,RpeakAalertness{1,j}(1,2:end)); %removing first value due to nan in RRdistance            
%                     RpeakQStiming{1,j}=ChunkQS{1,j}(1,RpeakQS{1,j});
               end
            end
        end   
      end

%%%%%%%%%%%% TRANSITION
      if exist('transition','var')==1
        for i=1:length(transition)
            if isempty(transition{1,i})== 0
               if nansum(transition{1,i}(2,:))~=0 %==1 % due to the elimination of caregiving there can be nan`s instead of values   sum(~isnan(transition{1,i}(2,:)))>2
                  if range(transition{1,i}(2,:))~=0 % if all values are the same, r peaks cannot be found
                   [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                            ecg_find_rpeaks(transition{1,i}(1,:)', transition{1,i}(2,:)', FS, 250,plotting,saving);
                  end
                    Rpeaktransition{1,i}=ecg_r_peak_idx; Speaktransition{1,i}=ecg_s_peak_idx;QRslopetransition{1,i}=ecg_qr_slope_idx;
                    RSslopetransition{1,i}=ecg_rs_slope_idx;STslopetransition{1,i}=ecg_st_slope_idx;RRdistancetransition{1,i}=bbi_ecg;bpm_ecg_transition{1,i}=bpm_ecg;
%                     RpeakAStiming{1,i}=ChunkAS{1,i}(1,RpeakAS{1,i});%creating continues timevector with the Rpeaks from the ECG
                    Rpeaktransitiontiming{1,i}=transition{1,i}(1,Rpeaktransition{1,i}(1,2:end)); %removing first value due to nan in RRdistance
               end
            end
        end
      end
  
%%%%%%%%%%%% POSITION
      if exist('position','var')==1
        for i=1:length(position)
            if isempty(position{1,i})== 0   
               if (nansum(position{1,i}(2,:))~=0) % due to the elimination of caregiving there can be nan`s instead of values   
                   if range(position{1,i}(2,:))~=0
                   [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                            ecg_find_rpeaks(position{1,i}(1,:)', position{1,i}(2,:)', FS, 250,plotting,saving);
                   end
                    Rpeakposition{1,i}=ecg_r_peak_idx; Speakposition{1,i}=ecg_s_peak_idx;QRslopeposition{1,i}=ecg_qr_slope_idx;
                    RSslopeposition{1,i}=ecg_rs_slope_idx;STslopeposition{1,i}=ecg_st_slope_idx;RRdistanceposition{1,i}=bbi_ecg;bpm_ecg_position{1,i}=bpm_ecg;
%                     RpeakAStiming{1,i}=ChunkAS{1,i}(1,RpeakAS{1,i});%creating continues timevector with the Rpeaks from the ECG
                    Rpeakpositiontiming{1,i}=position{1,i}(1,Rpeakposition{1,i}(1,2:end)); %removing first value due to nan in RRdistance
               end
            end
        end
      end

%%%%%%%%%%%% NOT RELIABLE
      if exist('Not_reliable','var')==1
        for i=1:length(Not_reliable)
            if isempty(Not_reliable{1,i})== 0
               if (nansum(Not_reliable{1,i}(2,:))~=0)  % due to the elimination of caregiving there can be nan`s instead of values   
                   if range(Not_reliable{1,i}(2,:))~=0                   
                   [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                            ecg_find_rpeaks(Not_reliable{1,i}(1,:)', Not_reliable{1,i}(2,:)', FS, 250,plotting,saving);
                   end
                    RpeakNot_reliable{1,i}=ecg_r_peak_idx; SpeakNot_reliable{1,i}=ecg_s_peak_idx;QRslopeNot_reliable{1,i}=ecg_qr_slope_idx;
                    RSslopeNot_reliable{1,i}=ecg_rs_slope_idx;STslopeNot_reliable{1,i}=ecg_st_slope_idx;RRdistanceNot_reliable{1,i}=bbi_ecg;bpm_ecg_Not_reliable{1,i}=bpm_ecg;
%                     RpeakAStiming{1,i}=ChunkAS{1,i}(1,RpeakAS{1,i});%creating continues timevector with the Rpeaks from the ECG
                    RpeakNot_reliabletiming{1,i}=Not_reliable{1,i}(1,RpeakNot_reliable{1,i}(1,2:end)); %removing first value due to nan in RRdistance
               end
            end
        end
      end

%%%%%%% SAVING
    if saving %saving folder at the top
%%%% AS QS       
       if exist('RRdistanceAS','var') ==1 & exist('RRdistanceQS','var') ==1
           save([folder 'RRdistance_' num2str(Neonate) '.mat'],'RRdistanceAS','RRdistanceQS')  ; 
       elseif exist('RRdistanceAS','var') ==1
           save([folder 'RRdistance_' num2str(Neonate) '.mat'],'RRdistanceAS')  ; 
       elseif exist('RRdistanceQS_win','var') ==1
           save([folder 'RRdistance_' num2str(Neonate) '.mat'],'RRdistanceQS')  ; 
       end  
       
       if exist('RpeakAS','var') ==1 & exist('RpeakQS','var') ==1
           save([folder 'Rpeaks30_' num2str(Neonate) '.mat'],'RpeakAS','RpeakQS','RpeakAStiming','RpeakQStiming')  ; 
       elseif exist('RpeakAS','var') ==1
           save([folder 'Rpeaks30_' num2str(Neonate) '.mat'],'RpeakAS','RpeakAStiming')  ; 
       elseif exist('RpeakQS','var') ==1
           save([folder 'Rpeaks30_' num2str(Neonate) '.mat'],'RpeakQS','RpeakQStiming')  ; 
       end 
%%%% WAKE 
       if exist('RRdistanceAalertness','var') ==1 & exist('RRdistanceQalertness','var') ==1
           save([folder 'RRdistanceWake_' num2str(Neonate) '.mat'],'RRdistanceQalertness','RRdistanceAalertness')  ; 
       elseif exist('RRdistanceAalertness','var') ==1
           save([folder 'RRdistanceWake_' num2str(Neonate) '.mat'],'RRdistanceAalertness')  ; 
       elseif exist('RRdistanceQalertness','var') ==1
           save([folder 'RRdistance_' num2str(Neonate) '.mat'],'RRdistanceQalertness')  ; 
       end  
       
       if exist('RpeakAalertness','var') ==1 & exist('RpeakQalertness','var') ==1
           save([folder 'RpeakWake_' num2str(Neonate) '.mat'],'RpeakAalertness','RpeakQalertness','RpeakAalertnesstiming','RpeakQalertnesstiming')  ; 
       elseif exist('RpeakAalertness','var') ==1
           save([folder 'RpeakWake_' num2str(Neonate) '.mat'],'RpeakAalertness','RpeakAalertnesstiming')  ; 
       elseif exist('RpeakQalertness','var') ==1
           save([folder 'RpeakWake_' num2str(Neonate) '.mat'],'RpeakQalertness','RpeakQalertnesstiming')  ; 
       end 
       
%%%% TRANSITION 
       if exist('RRdistancetransition','var') ==1 
           save([folder 'RRdistancetransition_' num2str(Neonate) '.mat'],'RRdistancetransition')  ; 
       end     
       if exist('Rpeaktransition','var') ==1 
           save([folder 'Rpeaktransition_' num2str(Neonate) '.mat'],'Rpeaktransition','Rpeaktransitiontiming')  ; 
       end
        
%%%% POSTITION 
       if exist('RRdistanceposition','var') ==1 
           save([folder 'RRdistanceposition_' num2str(Neonate) '.mat'],'RRdistanceposition')  ; 
       end    
       if exist('Rpeakposition','var') ==1 
           save([folder 'Rpeakposition_' num2str(Neonate) '.mat'],'Rpeakposition','Rpeakpositiontiming')  ; 
       end       
       
%%%% NOT RELIABLE 
       if exist('RRdistanceNot_reliable','var') ==1 
           save([folder 'RRdistanceNot_reliable_' num2str(Neonate) '.mat'],'RRdistanceNot_reliable')  ; 
       end   
       if exist('RpeakNot_reliable','var') ==1 
           save([folder 'RpeakNot_reliable_' num2str(Neonate) '.mat'],'RpeakNot_reliable','RpeakNot_reliabletiming')  ; 
       end  
    end
end
