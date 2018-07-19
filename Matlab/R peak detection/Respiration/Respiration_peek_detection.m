function ret=Respiration_peek_detection(Resp,t_Resp,fs)

%% Subsampling settings (Pedro)
settings.RESP_RESAMPLE = 1; % enable subsampling, needed to for the Ehv data set
settings.RESP_TARGET_SAMPLE_RATE = 10; % same sampling rate as for the Boston data set


%% Parameters respiratory features

settings.RESP_BASELINE_WINLEN = 4;   % Preprocessing parameters (given in seconds)
settings.RESP_BASELINE_MOVAVR_LEN = 120;

settings.THR_SEGM = Inf; % Pedro: data_array_all_resp_aw.mat used Inf..., code received from Sandrine had 3.8. Used Inf to replicate results
settings.THR_SEGM_RESP = 0;      % if set to zero, only use criterion based on arc length applied to filtered-out resp signal
settings.MIN_LENGTH_CLEAN = 20;  % in seconds, minimal length of clean intervals allowed
settings.MARGIN_NOISE = 4;
settings.RESP_RESEGMENT = 0;  % Resegment respiratory effort signal according to the amount of abnormal peaks?

settings.WINDOW_MEDIAN_AMP = 30;  % nr of peak-to-trough and trough-to-peak amplitudes taken into account to estimate local median amplitude

settings.THR_AMPLITUDE = 0.07;

settings.THR_AMP_PEAKS = 0.05;
settings.THR_AMP_TROUGHS = 0.05;
settings.THR_AMPLITUDE_2 = 0.15;
settings.QUANTILE_THR = 0.5;

%% Downsampling from 500 to 10 Hz

Resp10Hz = downsample(Resp,10);
Resp10Hz = downsample(Resp10Hz,5);
new_fs=10;

%% Call Xi longs Resp peak deteciotn
disp('Start finding Respiration peeks')
ret = resp_preprocess(Resp10Hz, new_fs, settings);

t_10Hz= linspace(1,length(ret.resp)/10,length(ret.resp));


% MAKE ADAPTIVE
posThreshold=-1;
negThreshold=-2;
% ONLY PEAKS ALLOWED WHO ARE NEIGBORED BY A OPOSITE PEAK
    %FIRST ONLY ON POS WITH LEFT
    %THEN WITH NEG FOR LEFT AND RIGHT
    %INCLUDE STEEPNESS OF FLANK/
posPeeks=nan(1,length(ret.resp));
posPeeks(ret.valid_turning_point.index(ret.valid_turning_point.extremum==1))=ret.resp(ret.valid_turning_point.index(ret.valid_turning_point.extremum==1));
for i=1:length(posPeeks)
    if posPeeks(1,i) <= posThreshold
        posPeeks(1,i)=nan;
    end
end
        

negPeeks=nan(1,length(ret.resp));
negPeeks(ret.valid_turning_point.index(ret.valid_turning_point.extremum==-1))=ret.resp(ret.valid_turning_point.index(ret.valid_turning_point.extremum==-1));
for i=1:length(negPeeks)
    if negPeeks(1,i) >= negThreshold
        negPeeks(1,i)=nan;
    end
end
        
figure
Resppeeks(ret.valid_turning_point.index)=ret.resp(ret.valid_turning_point.index);
plot(t_10Hz,ret.resp); hold on
plot(t_10Hz, negPeeks,'xk' ); title('ret.resp ')


figure
Resppeeks(ret.valid_turning_point.index(ret.valid_turning_point.extremum==1))=ret.resp(ret.valid_turning_point.index(ret.valid_turning_point.extremum==1));
plot(t_10Hz,ret.resp); hold on
plot(t_10Hz, posPeeks,'xr' ); title('ret.resp ')
% 
% figure
% Resppeeks=nan(1,length(Resp10Hz));
% Resppeeks(ret.valid_turning_point.index)=Resp10Hz(ret.valid_turning_point.index);
% plot(Resp10Hz); hold on
% plot(Resppeeks,'xr' );title('Resp')
% 
% figure
% Resppeeks=nan(1,length(Resp));
% Resppeeks(Resppeeks500Hz)=Resp(Resppeeks500Hz);
% plot(Resp); hold on
% plot(Resppeeks,'xr' );title('Resp')
% 
% 
% 







% diffResp=fs*[0; diff(Resp')];
% 
% 
% 
% 
% 
% 
% %% Threshold
% Threshold=2.5*mean(diffResp(diffResp > 0));
% peakidx=find(diffResp>Threshold);
% excedingThreshold=NaN(length(diffResp),1); excedingThreshold(peakidx)=diffResp(peakidx);
% 
% 
% 
% % intv = ecg_qr_slope_idx(i) : ecg_rs_slope_idx(i);
% %     [tmp, max_idx] = max(ecg(intv));
% %     ecg_r_peak_idx(i) = max_idx + intv(1) - 1;
% %% Search area for peak
% % where is the change from nan to values and vice versa
% [pks,locs,w,p] = findpeaks(excedingThreshold);
% underThres=num2str(isnan(excedingThreshold)); 
% strfind(underThres,['1' ;'0'])
% stringsearcj
% 
% 
% ax1=subplot(2,1,1);
% plot(t_Resp,Resp); hold on;
% plot(locs/500,Resp(locs),'xr' );hold on;
% 
% ax2=subplot(2,1,2);
% linkaxes([ax1,ax2],'x')
% 
% 
% %% plotting
% ax1=subplot(2,1,1);
% plot(t_Resp,Resp); hold on;
% plot(t_Resp,Resp(find(Resp>Threshold)),'*r')
% ax2=subplot(2,1,2);
% plot(t_Resp,diffResp);hold on;
% plot([t_Resp(1) t_Resp(end)], Threshold*[1 1], '--r')
% plot(t_Resp,excedingThreshold,'*k')
% linkaxes([ax1,ax2],'x')


end