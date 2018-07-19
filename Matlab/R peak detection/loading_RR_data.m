function loading_RR_data(k,Neonate,win,win2)

 
 %%%%%%%%%%%%%%% LOADING UNWINDOWED RR DATA %%%%%%%%%%%%%%%%%%%%%
 
if k==1 %for un windowed loading
     cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\Rpeaks');
     cd2=('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\');

%%%%%%% AS QS
           %Loading RR distance data from Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistance_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistance_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end
           
           %Loading ECG
           if exist(fullfile(cd2, ['Chunk30_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd2, ['Chunk30_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end
           
           
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['Rpeaks30_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['Rpeaks30_' num2str(Neonate) '.mat'])) % load R peaks
                
                
           end 
           
%%%%%%%% WAKE           
 %Loading RR distance data form Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistanceWake_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistanceWake_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end
           
           %Loading ECG
           if exist(fullfile(cd2, ['Qalertness_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd2, ['Qalertness_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end
           if exist(fullfile(cd2, ['Aalertness_' num2str(Neonate)  '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd2, ['Aalertness_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end           
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['RpeakWake_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RpeakWake_' num2str(Neonate) '.mat'])) % load R peaks   
           end
                
%%%%%%%% TRANSITION         
 %Loading RR distance data form Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistancetransition_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistancetransition_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end
           
           %Loading ECG
           if exist(fullfile(cd2, ['transition_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd2, ['transition_' num2str(Neonate)  '.mat'])) % load  RR differnces 
           end
           
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['Rpeaktransition_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['Rpeaktransition_' num2str(Neonate) '.mat'])) % load R peaks           
           end
                
%%%%%%%% POSITION       
 %Loading RR distance data form Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistanceposition_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistanceposition_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end
           
           %Loading ECG
           if exist(fullfile(cd2, ['position_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd2, ['position_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end
           
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['Rpeakposition_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['Rpeakposition_' num2str(Neonate) '.mat'])) % load R peaks   
           end
           
%%%%%%%% NOT RELIABLE  
 %Loading RR distance data form Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistanceNot_reliable_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistanceNot_reliable_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end
           
           %Loading ECG
           if exist(fullfile(cd2, ['Not_reliable_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd2, ['Not_reliable_' num2str(Neonate) '.mat'])) % load  RR differnces 
           end
           
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['RpeakNot_reliable_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RpeakNot_reliable_' num2str(Neonate) '.mat'])) % load R peaks   
           end  
end %(if k=1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LOADING WINDOWED RR DATA %%%%%%%%%%%%%%%%%%%%%%%


if k==2 % for loading windowed ECG/RR
     cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\ECG clustered by annotations\unsorted\');

%%%%%%%% AS QS   
           
           %Loading RR distance data form Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistance_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistance_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end        

            %Loading ECG            
           if exist(fullfile(cd, ['Chunk30_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['Chunk30_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end
                      
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['Rpeaks30_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['Rpeaks30_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load R peaks
           end 
 
%%%%%%%% WAKE           
 %Loading RR distance data form Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistanceWake_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistanceWake_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end
           
           %Loading ECG
           if exist(fullfile(cd, ['ChunkWake_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['ChunkWake_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end
%            if exist(fullfile(cd, ['Aalertness_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
%                 load(fullfile(cd, ['Aalertness_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
%            end           
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['RpeakWake_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RpeakWake_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load R peaks   
           end
                
%%%%%%%% TRANSITION         
 %Loading RR distance data form Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistancetransition_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistancetransition_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end
           
           %Loading ECG
           if exist(fullfile(cd, ['transition_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['transition_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end
           
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['Rpeaktransition_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['Rpeaktransition_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load R peaks           
           end
                
%%%%%%%% POSITION       
 %Loading RR distance data form Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistanceposition_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistanceposition_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end
           
           %Loading ECG
           if exist(fullfile(cd, ['position_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['position_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end
           
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['Rpeakposition_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['Rpeakposition_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load R peaks   
           end
           
%%%%%%%% NOT RELIABLE  
 %Loading RR distance data form Ralphs RR distance calculations
           if exist(fullfile(cd, ['RRdistanceNot_reliable_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RRdistanceNot_reliable_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end
           
           %Loading ECG
           if exist(fullfile(cd, ['Not_reliable_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['Not_reliable_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load  RR differnces 
           end
           
           %Loading R peaks from Raphs R peak detection      
           if exist(fullfile(cd, ['RpeakNot_reliable_' num2str(Neonate) '_win_' num2str(win) '.mat']), 'file') == 2 % ==> 0 or 2
                load(fullfile(cd, ['RpeakNot_reliable_' num2str(Neonate) '_win_' num2str(win) '.mat'])) % load R peaks   
           end
end
           win=win2;
           
        folder=('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\R peak detection and HRV\');
        save(fullfile(folder, ['loading_RR_data workspace'])); % this saves the total workspace to be used in the "base" workspace
end