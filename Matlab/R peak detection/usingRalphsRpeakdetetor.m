function usingRalphsRpeakdetetor(Neonate,FS,plotting,saving,win,overlap)
    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_chunks\';

    if Neonate==13
    FS=500;% The FS of pat 13 is interpolatet before to 500 HZ
    end

    if exist  (([folder 'ChunkAS' num2str(Neonate) '_win' num2str(win) '_overlap' num2str(overlap) '.mat']))
     load ([folder 'ChunkAS' num2str(Neonate) '_win' num2str(win) '_overlap' num2str(overlap) '.mat']);
    end
    if exist([folder 'ChunkQS' num2str(Neonate) '_win' num2str(win) '_overlap' num2str(overlap) '.mat'])
     load ([folder 'ChunkQS' num2str(Neonate) '_win' num2str(win) '_overlap' num2str(overlap) '.mat']);
    end
        
    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\R peak detection and HRV\RAlps Rpeak detection')
    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks\Ralphs\';

      if exist('ChunkAS')==1
        for i=1:length(ChunkAS)
            if isempty(ChunkAS{1,i})== 0
               if sum(~isnan(ChunkAS{1,i}(2,:)))>2 %(nansum(ChunkAS{1,i}(2,:))~=0) ==1 % due to the elimination of caregiving ther can be nan`s instead of values   
                   
                       [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                                ecg_find_rpeaks(ChunkAS{1,i}(1,:)', ChunkAS{1,i}(2,:)', FS, 250,plotting,saving);

                                RpeakAS{1,i}=ecg_r_peak_idx; SpeakAS{1,i}=ecg_s_peak_idx;QRslopeAS{1,i}=ecg_qr_slope_idx;
                                RSslopeAS{1,i}=ecg_rs_slope_idx;STslopeAS{1,i}=ecg_st_slope_idx;RRdistanceAS{1,i}=bbi_ecg;bpm_ecg_AS{1,i}=bpm_ecg;
               end
            end
        end
        if saving
        %saving R to R distance in mat file
        save([folder 'RRdistanceAS' num2str(Neonate) ' _ ' num2str(win) 's_win_overlap_' num2str(overlap) '.mat'],'RRdistanceAS');
        end
      end
      
      if exist('ChunkQS')==1
        for j=1:length(ChunkQS)
            if isempty(ChunkQS{1,j})== 0
               if sum(~isnan(ChunkQS{1,j}(2,:)))>2 %(nansum(ChunkQS{1,j}(2,:))~=0) ==1 % due to the elimination of caregiving ther can be nan`s instead of values          

                   [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                            ecg_find_rpeaks(ChunkQS{1,j}(1,:)', ChunkQS{1,j}(2,:)', FS, 250,plotting,saving);
                                        
                                RpeakQS{1,j}=ecg_r_peak_idx; SpeakQS{1,j}=ecg_s_peak_idx;QRslopeQS{1,j}=ecg_qr_slope_idx;
                                RSslopeQS{1,j}=ecg_rs_slope_idx;STslopeQS{1,j}=ecg_st_slope_idx;RRdistanceQS{1,j}=bbi_ecg;bpm_ecg_QS{1,j}=bpm_ecg;
               end
            end
        end
         if saving              
         %saving R to R distance in mat file
         save([folder 'RRdistanceQS' num2str(Neonate) ' _ ' num2str(win) 's_win_overlap_' num2str(overlap) '.mat'],'RRdistanceQS');
         end       
      end

    
    if saving
        if exist('RpeakQS')==1
        save([folder 'Rpeaks' num2str(Neonate) ' _ ' num2str(win) 's_win_overlap_' num2str(overlap) '.mat'],'RpeakQS','RpeakAS')     
        end
    end
    
                                          
end
