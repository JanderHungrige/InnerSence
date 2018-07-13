function SlidingWindow(Neonate,window,saving,loadfolder,savefolder)   
% probelm: if the window reach the end and h is taking over. It could
% happen that e.g. the h=1 value is empty, that is skiped, but than with
% h=2 the index is subtracted 2 (h=2) which will be empty. The new value is
% therfore calculated from win and plus one empty value.
% Is that realy a problem? It could also just be fine. The value is then
% calculated by less values, still kind of correct.

 %%%%%%%%% loading data  
    for j=1:length(window)
        win=window(1,j); %array to single integer
        if win==30
            disp('should already exist. ')        
        else
           
%%%%%%%%%%% CREATING RR WINDOWS
            win=(win/30)-1; %how many field of a array put together. example 1 minute= 60sec = two fields of each 30 seconds;-1 because one is already choosen                    
            
            if exist([loadfolder 'consence_RR_' num2str(Neonate) '_win_30.mat'],'file')==2
            load([loadfolder 'consence_RR_' num2str(Neonate) '_win_30'])
            end
            
            % Runninng window looking into the future
           if exist('consence_RR_30s','var') == 1
               for k=1:length(consence_RR_30s)-win
                   if isempty(consence_RR_30s{1,k})==0 
                   consence_RR_windowed{1,k}=cell2mat(consence_RR_30s(1,k:k+win));
                   end
               end
               for h=1:win %for the end where the window is longer than the array
                   k=k+1;
                   if isempty(consence_RR_30s{1,k})==0
                   consence_RR_windowed{1,k}=cell2mat(consence_RR_30s(1,k-h:k+(win-h)));
                   end
               end
           end
           %
           
%%%%%%%%%%% CREATING ECG CHUNK WINDOWS
            if exist([loadfolder 'consence_ECG_' num2str(Neonate) '_win_30.mat'],'file')==2
            load([loadfolder 'consence_ECG_' num2str(Neonate) '_win_30'])
            end
            
            if exist('consence_ECG','var') == 1
               for k=1:length(consence_ECG)-win
                   if isempty(consence_ECG{1,k})==0
                   consence_ECG_windowed{1,k}=cell2mat(consence_ECG(1,k:k+win));
                   end
               end
               for h=1:win %for the end where the window is longer than the array
                   k=k+1;
                   if isempty(consence_ECG{1,k})==0
                   consence_ECG_windowed{1,k}=cell2mat(consence_ECG(1,k-h:k+(win-h)));
                   end
               end
            end     % if exist
            
%%%%%%%%%%%% savig AS QS
           if saving
               if exist('consence_RR_windowed','var') ==1 
                   save([savefolder 'consence_RR_' num2str(Neonate) '_win_' num2str((win+1)*30) '.mat'],'consence_RR_windowed')  ; 
               end
               if exist('consence_ECG_windowed','var') ==1 
                   save([savefolder 'consence_ECG_' num2str(Neonate) '_win_' num2str((win+1)*30) '.mat'],'consence_ECG_windowed')  ; 
               end   
           end
               
       end             % for length win              
    end                % if win==30            
end                    % end function   