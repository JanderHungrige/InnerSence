%Abstellgleis

%% Form callRpeakfunctions

% % % %%determine which state is looked for 
% % % if state=='QS'
% % % ecg=QS(2,:);
% % % t_ecg= (0:1/FS:length(QS(2,:))); % for ralph or pauls, time vector
% % % 
% % % else if state == 'AS'
% % % ecg=AS(2,:);
% % % t_ecg=AS(1,:); % for ralph or pauls, time vector
% % % 
% % %     else
% % %         fprintf=('please choose state QS or AS');
% % %     end
% % % end
% % % 
% % % % hr_max=200;     % for Ralph maximum HR
% % % 
%  cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\R peak detection and HRV');
% % % 
%%Pan Tomkin R peak detection 
% plot=0;           
% [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(ecg',fs,plot);
% 

%%Ralphs R peak detection
% [ecg_r_peak_idx, ecg_s_peak_idx, bbi_ecg] =Ralphs_ecg_find_rpeaks(t_ecg', ecg', fs, hr_max);
% 

% % Philips Toolbox R peak detection
% [r,r_n,ctx,s]=peak_detect(varargin)


%calculating R distance in seconds
 saving=1;
 [timebetweenR]=RRpeaksinms(RpeakAS,AS,QS,state,saving,Neonate);

%converting time string into HH:MM:SS
[hours,minutes,seconds]=timestampconversion(t_ecg(1,end))