%Frequency analysis

%[pxx,f] = plomb(x,t) returns the Lomb-Scargle power spectral density (PSD) estimate, pxx, of a signal, x, that is sampled at the instants specified in t. 
% t must increase monotonically but need not be uniformly spaced. All elements of t must be nonnegative. pxx is evaluated at the frequencies returned in f.

% clc
% clear
% win=[60,120,180,240,300]; %window in seconds
% overlap=[0.5,1];

function [powerspectrumR,f]=Lomb_scargel_single(RR,RR_idx,t,Neonate,saving,savefolder,win)  
if isrow(RR);  RR=RR'; end
if isrow(RR_idx);  RR_idx=RR_idx'; end
if isrow(t);  t=t'; end

   all_idx=cell(length(RR),1);
   timing=cell(length(RR),1);
 % creating time vector  
 for M=1:length(RR)
     if all(isnan(RR{M,1}))==1
         powerspectrumR{M,1}=nan;f{1,M}=nan;
     elseif  nnz(~isnan(RR{M,1}))<2 %need more then 2 values otherthan nan (nnz=Number of nonzero matrix elements
         powerspectrumR{M,1}=nan;f{1,M}=nan;         
     else    
    %     RR{1,M}(any(isnan(RR{1,M})))=[]; %removing nans
        timing{M,1}=t{M,1}(RR_idx{M,1},1); % get the timestamp from AS time vector at the Rpeaks in s

        % removing outlier
        all_idx{M,1} = 1:length(RR{M,1});
        outlier_idx = abs(RR{M,1} - median(RR{M,1})) > 3*std(RR{M,1}); % Find outlier idx
        RR{M,1}(outlier_idx) = interp1(all_idx{M,1}(~outlier_idx), RR{M,1}(~outlier_idx), all_idx{M,1}(outlier_idx)); % Linearly interpolate over outlier idx for x
        clearvars outlier_idx

        %lomb scargel
        [powerspectrumR{M,1},f{1,M}] = plomb(RR{M,1},timing{M,1});
        %convert to dB / frequency
        pxxdB{M,1}=10*log10(powerspectrumR{M,1});
     end

 end
            %normalizing
%                         maximum=max(pxx);
%                         pxx=pxx./maximum;
%                         pxx=pxx/length(pxx);


%%%%%%%%%%%% SAVING            
if saving                     %saving R peaks positions in mat file                 
    Saving(powerspectrumR,savefolder,Neonate,win) 
end% end if saving 


end

%% Nested saving
    function Saving(Feature,savefolder, Neonate, win,Session,S)
        if exist('Feature','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_win_' num2str(win)],'Feature')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end
                

 
 
 





