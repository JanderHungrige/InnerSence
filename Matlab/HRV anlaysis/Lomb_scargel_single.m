%Frequency analysis

%[pxx,f] = plomb(x,t) returns the Lomb-Scargle power spectral density (PSD) estimate, pxx, of a signal, x, that is sampled at the instants specified in t. 
% t must increase monotonically but need not be uniformly spaced. All elements of t must be nonnegative. pxx is evaluated at the frequencies returned in f.

% clc
% clear
% win=[60,120,180,240,300]; %window in seconds
% overlap=[0.5,1];
function Lomb_scargel_single(pat,plotting,saving)
%     pat=[3];
    for i=1:length(pat)
                 cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG no care separated into AS and QS (total)\HRV analysis\Ralphs')
                  if exist(fullfile(cd, ['RRdistanceAS_total_' num2str(pat(1,i)) '.mat']), 'file') == 2 % ==> 0 or 2
                        load(fullfile(cd, ['RRdistanceAS_total_' num2str(pat(1,i)) '.mat'])) % load  RR differnces 
                        
                       if exist(fullfile(cd, ['Rpeaks_total' num2str(pat(1,i)) '.mat']), 'file') == 2 % ==> 0 or 2
                            load(fullfile(cd, ['Rpeaks_total' num2str(pat(1,i)) '.mat'])) % load R peaks
                       end
                       
                    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG no care separated into AS and QS (total)')
                       if exist(fullfile(cd, ['ECGstate_nocare_' num2str(pat(1,i)) '.mat']), 'file') == 2 % ==> 0 or 2
                            load(fullfile(cd, ['ECGstate_nocare_' num2str(pat(1,i)) '.mat']))  % load QS and AS; data and time vector of all AS/QS


                            RRdistanceAS(any(isnan(RRdistanceAS)))=[]; %removing nans

                            % creating time vector                                        
                            timingAS=AS(1,RpeakAS(1,2:length(RpeakAS))); % get the timestamp from AS time vector at the Rpeaks in s
                            timingQS=QS(1,RpeakQS(1,2:length(RpeakQS))); % get the timestamp from QS time vector at the Rpeaks in s

                       end

                        % removing outlier
                        all_idx = 1:length(RRdistanceAS);
                        outlier_idx = abs(RRdistanceAS - median(RRdistanceAS)) > 3*std(RRdistanceAS); % Find outlier idx
                        RRdistanceAS(outlier_idx) = interp1(all_idx(~outlier_idx), RRdistanceAS(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
                        

                        %lomb scargel
                        [pxxAS,fAS] = plomb(RRdistanceAS,timingAS);
                        %convert to dB / frequency
                        pxxQSdB=10*log10(pxxAS);
                        
                        %normalizing
%                         maximum=max(pxx);
%                         pxx=pxx./maximum;
%                         pxx=pxx/length(pxx);
                        
                        
                        %plotting
                        if plotting
                            
                            figure
                            plomb(RRdistanceAS,timingAS)                         
                            title (['Lomb-Scargle periodogram AS patient: ' num2str(pat)])
%                             xlabel('Frequency')

                        end
                   end
                                               
                   
                   
                   
%%%%%%%%%%%%%%%%QS
                    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG no care separated into AS and QS (total)\HRV analysis\Ralphs\')
                    if exist(fullfile(cd, ['RRdistanceQS_total_' num2str(pat(1,i)) '.mat']), 'file') == 2 % ==> 0 or 2
                        load(fullfile(cd, ['RRdistanceQS_total_' num2str(pat(1,i)) '.mat']))     
                          
                                               
                        RRdistanceQS(any(isnan(RRdistanceQS)))=[]; %removing nans


                        
                       % removing outlier
                        all_idx = 1:length(RRdistanceQS);
                        outlier_idx = abs(RRdistanceQS - median(RRdistanceQS)) > 3*std(RRdistanceQS); % Find outlier idx
                        RRdistanceQS(outlier_idx) = interp1(all_idx(~outlier_idx), RRdistanceQS(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
                        
                        
                                                
                        %lomb scargel
                        [pxxQS,fQS] = plomb(RRdistanceQS,timingQS);
                        %converting to dB/frequency
                         pxxdBQS=10*log10(pxxQS);

                        %normalizing
%                         maximum=max(pxx);
%                         pxx=pxx./maximum;
%                         pxx=pxx./length(pxx);
                        
                        %plotting
                        if plotting
                            figure
                            plomb(RRdistanceQS,timingQS)
                            title (['Lomb-Scargle periodogram QS patient: ' num2str(pat)])
%                             xlabel('Frequency')
                        end
                                               
                    end
                %saving
                if saving
                    folder=('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG no care separated into AS and QS (total)\HRV analysis\Ralphs\');
                    %saving power and frequency in mat file
                    save([folder 'PowerspectrumAS_' num2str(pat(i)) '.mat'],'pxxAS', 'fAS');
                    save([folder 'PowerspectrumQS_' num2str(pat(i)) '.mat'],'pxxQS', 'fQS');
                end
    end
    %back to the begining folder
    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\HRV anlaysis')

end





