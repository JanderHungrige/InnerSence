% SDNN
function SDNN(pat,saving,win)
Neonate=pat;
 
  for j=1:length(win)
         
%%%%%%%%%%%%%%%checking if file exist / loading
%     cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\Rpeaks\')
    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\ECG clustered by annotations\unsorted')        
    if exist(fullfile(cd, ['RRdistance_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['RRdistance_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']))
    end
    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\ECG clustered by annotations\unsorted')        
     if exist(fullfile(cd, ['RRdistanceWake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['RRdistanceWake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']))
     end       

    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\ECG clustered by annotations\unsorted')        
     if exist(fullfile(cd, ['RRdistancetransition_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['RRdistancetransition_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']))
     end 

    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\ECG clustered by annotations\unsorted')        
     if exist(fullfile(cd, ['RRdistanceposition_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['RRdistanceposition_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']))
     end   

    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\ECG clustered by annotations\unsorted')        
     if exist(fullfile(cd, ['RRdistanceNot_reliable_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['RRdistanceNot_reliable_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']))
    end  
            
%%%%%%%%%%%%%%calculate STD

%%%%%%%%%%%%% AS QS
                  if exist('RRdistanceAS_win','var')
                   for i=1:length(RRdistanceAS_win)
                         SDNN_AS{1,i}=nanstd(RRdistanceAS_win{1,i});
                   end
                  end
                  if exist('RRdistanceQS_win','var')
                   for i=1:length(RRdistanceQS_win)
                         SDNN_QS{1,i}=nanstd(RRdistanceQS_win{1,i});
                   end
                  end
%%%%%%%%%%%%% WAKE
                  if exist('RRdistanceAalertness_win','var')
                   for i=1:length(RRdistanceAalertness_win)
                         SDNN_Aalertness{1,i}=nanstd(RRdistanceAalertness_win{1,i});
                   end
                  end
                  if exist('RRdistanceQalertness_win','var')
                   for i=1:length(RRdistanceQalertness_win)
                         SDNN_Qalertness{1,i}=nanstd(RRdistanceQalertness_win{1,i});
                   end
                  end
%%%%%%%%%%%%% TRANSITION
                  if exist('RRdistancetransition_win','var')
                   for i=1:length(RRdistancetransition_win)
                         SDNN_transition{1,i}=nanstd(RRdistancetransition_win{1,i});
                   end
                  end    
%%%%%%%%%%%%% POSITION
                  if exist('RRdistanceposition_win','var')
                   for i=1:length(RRdistanceposition_win)
                         SDNN_position{1,i}=nanstd(RRdistanceposition_win{1,i});
                   end
                  end    
%%%%%%%%%%%%% NOT RELIABLE
                  if exist('RRdistanceNot_reliable_win','var')
                   for i=1:length(RRdistanceNot_reliable_win)
                         SDNN_Not_reliable{1,i}=nanstd(RRdistanceNot_reliable_win{1,i});
                   end
                  end                        
%%%%%%%%%%%%replace [] with nan
%%%%%%%%%%% AS QS
            if exist ('SDNN_AS','var')
                ix=cellfun(@isempty,SDNN_AS);
                SDNN_AS(ix)={nan};  
            end
            if exist ('SDNN_QS','var')
                ix=cellfun(@isempty,SDNN_QS);
                SDNN_QS(ix)={nan};
            end
%%%%%%%%%%% WAKE
            if exist ('SDNN_Aalertness','var')
                ix=cellfun(@isempty,SDNN_Aalertness);
                SDNN_Aalertness(ix)={nan};  
            end
            if exist ('SDNN_Qalertness','var')
                ix=cellfun(@isempty,SDNN_Qalertness);
                SDNN_Qalertness(ix)={nan};
            end
%%%%%%%%%%% TRANSITION
            if exist ('SDNN_transition','var')
                ix=cellfun(@isempty,SDNN_transition);
                SDNN_transition(ix)={nan};  
            end        
%%%%%%%%%%% POSITION
            if exist ('SDNN_position','var')
                ix=cellfun(@isempty,SDNN_position);
                SDNN_position(ix)={nan};  
            end                  
%%%%%%%%%%% NOT RELIABLE
            if exist ('SDNN_Not_reliable','var')
                ix=cellfun(@isempty,SDNN_Not_reliable);
                SDNN_Not_reliable(ix)={nan};  
            end  
            
%%%%%%%%%%%%SAVING            
                if saving                     %saving R peaks positions in mat file
                    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\HRV features\';
%%%%%%%%%%% AS QS                    
                    if exist('SDNN_AS')==1 & exist ('SDNN_QS')
                     save([folder 'SDNN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDNN_AS','SDNN_QS');
                    elseif exist('SDNN_AS') ==1
                     save([folder 'SDNN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDNN_AS');
                    elseif exist('SDNN_QS') ==1
                     save([folder 'SDNN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDNN_QS');
                    end       
                
%%%%%%%%%%% WAKE                  
                    if exist('SDNN_Aalertness')==1 & exist ('SDNN_Qalertness')
                     save([folder 'SDNN_Wake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDNN_Aalertness','SDNN_Qalertness');
                    elseif exist('SDNN_Aalertness') ==1
                     save([folder 'SDNN_Wake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDNN_Aalertness');
                    elseif exist('SDNN_Qalertness') ==1
                     save([folder 'SDNN_Wake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDNN_Qalertness');
                    end                
%%%%%%%%%%% Transition                 
                    if exist('SDNN_transition')==1 
                     save([folder 'SDNN_transition_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDNN_transition');       
                    end
%%%%%%%%%%% Position                 
                    if exist('SDNN_position')==1 
                     save([folder 'SDNN_position_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDNN_position');       
                    end     
%%%%%%%%%%% Not Reliable                 
                    if exist('SDNN_Not_reliable')==1 
                     save([folder 'SDNN_Not_reliable_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDNN_Not_reliable');       
                    end                 
                end% end if saving
                

 
 
 
    end%win
        
end
