% % SDANN

function SDANN(pat,saving,win)

Neonate=pat;

  for j=1:length(win)

    %checking if file exist / loading
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

%%%%%%%%%%%%% AS
    if exist('RRdistanceAS_win','var')==1     
      % calculating mean distance    
      for i=1:length(RRdistanceAS_win)
          if RRdistanceAS_win{1,i}  
             meanRRdistanceAS(1,i)=mean(RRdistanceAS_win{1,i});
          end
      end
       % calculating STD
      for i=1:length(RRdistanceAS_win)
          if meanRRdistanceAS(1,i)~=0
          SDANN_AS(1,i)=nanstd(meanRRdistanceAS);
          end
      end
       SDANN_AS(SDANN_AS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
    end% if exist AS
%%%%%%%%%%%%% QS
    if exist('RRdistanceQS_win','var')==1      
       for i=1:length(RRdistanceQS_win)
          if RRdistanceQS_win{1,i}
             meanRRdistanceQS(1,i)=mean(RRdistanceQS_win{1,i});
          end
       end                 
        %calculate STD
       for i=1:length(RRdistanceQS_win)
           if meanRRdistanceQS(1,i)~=0
             SDANN_QS(1,i)=nanstd(meanRRdistanceQS);
           end
       end 
       SDANN_QS(SDANN_QS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
    end%if exist QS
%%%%%%%%%%%%% WAKE
    if exist('RRdistanceAalertness_win','var')==1      
       for i=1:length(RRdistanceAalertness_win)
          if RRdistanceAalertness_win{1,i}
             meanRRdistanceAalertness(1,i)=mean(RRdistanceAalertness_win{1,i});
          end
       end                 
        %calculate STD
       for i=1:length(RRdistanceAalertness_win)
           if meanRRdistanceAalertness(1,i)~=0
             SDANN_Aalertness(1,i)=nanstd(meanRRdistanceAalertness);
           end
       end 
       SDANN_Aalertness(SDANN_Aalertness==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
    end%if exist Aalertness  
    if exist('RRdistanceQalertness_win','var')==1      
       for i=1:length(RRdistanceQalertness_win)
          if RRdistanceQalertness_win{1,i}
             meanRRdistanceQalertness(1,i)=mean(RRdistanceQalertness_win{1,i});
          end
       end                 
        %calculate STD
       for i=1:length(RRdistanceQalertness_win)
           if meanRRdistanceQalertness(1,i)~=0
             SDANN_Qalertness(1,i)=nanstd(meanRRdistanceQalertness);
           end
       end 
       SDANN_Qalertness(SDANN_Qalertness==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
    end%if exist Aalertness    
%%%%%%%%%%%%% TRANSITION
    if exist('RRdistancetransition_win','var')==1      
       for i=1:length(RRdistancetransition_win)
          if RRdistancetransition_win{1,i}
             meanRRdistancetransition(1,i)=mean(RRdistancetransition_win{1,i});
          end
       end                 
        %calculate STD
       for i=1:length(RRdistancetransition_win)
           if meanRRdistancetransition(1,i)~=0
             SDANN_transition(1,i)=nanstd(meanRRdistancetransition);
           end
       end 
       SDANN_transition(SDANN_transition==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
    end%if exist transition  
%%%%%%%%%%%%% POSITION
    if exist('RRdistanceposition_win','var')==1      
       for i=1:length(RRdistanceposition_win)
          if RRdistanceposition_win{1,i}
             meanRRdistanceposition(1,i)=mean(RRdistanceposition_win{1,i});
          end
       end                 
        %calculate STD
       for i=1:length(RRdistanceposition_win)
           if meanRRdistanceposition(1,i)~=0
             SDANN_position(1,i)=nanstd(meanRRdistanceposition);
           end
       end 
       SDANN_position(SDANN_position==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
    end%if exist position 
%%%%%%%%%%%%% Not Reliable
    if exist('RRdistanceNot_reliable_win','var')==1      
       for i=1:length(RRdistanceNot_reliable_win)
          if RRdistanceNot_reliable_win{1,i}
             meanRRdistanceNot_reliable(1,i)=mean(RRdistanceNot_reliable_win{1,i});
          end
       end                 
        %calculate STD
       for i=1:length(RRdistanceNot_reliable_win)
           if meanRRdistanceNot_reliable(1,i)~=0
             SDANN_Not_reliable(1,i)=nanstd(meanRRdistanceNot_reliable);
           end
       end 
       SDANN_Not_reliable(SDANN_Not_reliable==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
    end%if exist Not reliable 
%%%%%%%%%%%%%saving

        if saving
            folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\HRV features\';
%%%%%%% AS QS            
            if exist('SDANN_AS','var')==1 & exist ('SDANN_QS','var')==1
             save([folder 'SDANN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDANN_AS','SDANN_QS');
            elseif exist('SDANN_AS','var') ==1
             save([folder 'SDANN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDANN_AS');
            elseif exist('SDANN_QS','var') ==1
             save([folder 'SDANN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDANN_QS');
            end
%%%%%%%%% WAKE        
        if saving
            if exist('SDANN_Aalertness','var')==1 & exist ('SDANN_Qalertness','var')==1
             save([folder 'SDANN_wake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDANN_Aalertness','SDANN_Qalertness');
            elseif exist('SDANN_Aalertness','var') ==1
             save([folder 'SDANN_wake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDANN_Aalertness');
            elseif exist('SDANN_Qalertness','var') ==1
             save([folder 'SDANN_wake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDANN_Qalertness');
            end
        end      
%%%%%%%%%% TRANSITION        
            if exist('SDANN_transition','var')==1 
             save([folder 'SDANN_transition_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDANN_transition');
            end
%%%%%%%%%% POSITION        
            folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\HRV features\';
            if exist('SDANN_position','var')==1 
             save([folder 'SDANN_position_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDANN_position');
            end        
%%%%%%%%%% NOT RELIABLE        
            folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\HRV features\';
            if exist('SDANN_Not_reliable','var')==1 
             save([folder 'SDANN_Not_reliable_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'SDANN_Not_reliable');
            end               
            
        end% if saving
  end %window

end
