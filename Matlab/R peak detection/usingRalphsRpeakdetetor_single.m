function usingRalphsRpeakdetetor_single(Neonate,FS,plotting,saving)
    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG no care separated into AS and QS (total)\';

    if Neonate==13
    FS=500;% The FS of pat 13 is interpolatet before to 500 HZ
    end

    if exist  (([folder 'ECGstate_nocare_' num2str(Neonate) '.mat']))
     load([folder 'ECGstate_nocare_' num2str(Neonate) '.mat'])
        
    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\R peak detection and HRV\RAlps Rpeak detection')
    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG no care separated into AS and QS (total)\HRV analysis\Ralphs\';

%%%%%%%%%AS
      if exist('AS')==1
          AS=AS';
                       
                       [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                                ecg_find_rpeaks(AS(:,1), AS(:,2), FS, 250,plotting,saving);

                                RpeakAS=ecg_r_peak_idx; SpeakAS=ecg_s_peak_idx;QRslopeAS=ecg_qr_slope_idx;
                                RSslopeAS=ecg_rs_slope_idx;STslopeAS=ecg_st_slope_idx;RRdistanceAS=bbi_ecg;bpm_ecg_AS=bpm_ecg;
                         
        
        if saving
        %saving R to R distance in mat file
        save([folder 'RRdistanceAS_total_' num2str(Neonate) '.mat'],'RRdistanceAS');
        end
      end
      
%%%%%%%%QS      
      if exist('QS')==1
      

                   [ecg_r_peak_idx, ecg_s_peak_idx, ecg_qr_slope_idx,ecg_rs_slope_idx, ecg_st_slope_idx, bbi_ecg, bpm_ecg] = ...
                                            ecg_find_rpeaks(QS(1,:)', QS(2,:)', FS, 250,plotting,saving);
                                        
                                RpeakQS=ecg_r_peak_idx; SpeakQS=ecg_s_peak_idx;QRslopeQS=ecg_qr_slope_idx;
                                RSslopeQS=ecg_rs_slope_idx;STslopeQS=ecg_st_slope_idx;RRdistanceQS=bbi_ecg;bpm_ecg_QS=bpm_ecg;
               
                
         if saving              
         %saving R to R distance in mat file
         save([folder 'RRdistanceQS_total_' num2str(Neonate) '.mat'],'RRdistanceQS');
         end       
      end

    %saving the peak indices
    if saving
        if exist('RpeakQS')==1
        save([folder 'Rpeaks_total' num2str(Neonate) '.mat'],'RpeakQS','RpeakAS')     
        end
    end
    
                                          
end
