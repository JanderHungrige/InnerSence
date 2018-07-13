% RMSSD
% ouput is the RMSSD, which is the sqrt(MSE) of the 5 minute epochs of the NN
% intervales. 

function RMSSD(pat,saving,win)
            Neonate=pat;

      for j=1:length(win)

          %checking if file exist / loading
%          cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_30secepochs\Rpeaks\')
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
%%%%%%%%%%%%%AS            
          if exist ('RRdistanceAS_win','var')==1
              for i=1:length(RRdistanceAS_win)
                  if RRdistanceAS_win{1,i}
                      RRdistanceAS_win{1,i}(2,:)=circshift(RRdistanceAS_win{1,i}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                      [PSNR,MSEAS{1,i},MAXERR,L2RAT] = measerr(RRdistanceAS_win{1,i}(1),RRdistanceAS_win{1,i}(2)); %Calculating MSE
                      RMSSD_AS=cellfun(@sqrt,MSEAS, 'Un', false); %sqare root over the MSE of the adjacent NN intervals creates the RMSSD
                  end
              end
          end            
%%%%%%%%%%%% QS            
           
            if exist('RRdistanceQS_win','var')==1
               for i=1:length(RRdistanceQS_win)
                     RRdistanceQS_win{1,i}(any(isnan( RRdistanceQS_win{1,i})))=[]; %removing nans
                  if RRdistanceQS_win{1,i}
                      RRdistanceQS_win{1,i}(2,:)=circshift(RRdistanceQS_win{1,i}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                      [PSNR,MSEQS{1,i},MAXERR,L2RAT] = measerr(RRdistanceQS_win{1,i}(1),RRdistanceQS_win{1,i}(2)); %Calculating MSE
                      RMSSD_QS=cellfun(@sqrt,MSEQS, 'Un', false);
                  end
               end
            end
%%%%%%%%%%%%% WAKE           
          if exist ('RRdistanceAalertness_win','var')==1
              for i=1:length(RRdistanceAalertness_win)
                     RRdistanceAalertness_win{1,i}(any(isnan( RRdistanceAalertness_win{1,i})))=[]; %removing nans                  
                  if RRdistanceAalertness_win{1,i}
                      RRdistanceAalertness_win{1,i}(2,:)=circshift(RRdistanceAalertness_win{1,i}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                      [PSNR,MSEAalertness{1,i},MAXERR,L2RAT] = measerr(RRdistanceAalertness_win{1,i}(1),RRdistanceAalertness_win{1,i}(2)); %Calculating MSE
                      RMSSD_Aalertness=cellfun(@sqrt,MSEAalertness, 'Un', false); %sqare root over the MSE of the adjacent NN intervals creates the RMSSD
                  end
              end
          end                     
           
            if exist('RRdistanceQalertness_win','var')==1
               for i=1:length(RRdistanceQalertness_win)
                     RRdistanceQalertness_win{1,i}(any(isnan( RRdistanceQalertness_win{1,i})))=[]; %removing nans
                  if RRdistanceQalertness_win{1,i}
                      RRdistanceQalertness_win{1,i}(2,:)=circshift(RRdistanceQalertness_win{1,i}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                      [PSNR,MSEQalertness{1,i},MAXERR,L2RAT] = measerr(RRdistanceQalertness_win{1,i}(1),RRdistanceQalertness_win{1,i}(2)); %Calculating MSE
                      RMSSD_Qalertness=cellfun(@sqrt,MSEQalertness, 'Un', false);
                  end
               end
            end       
%%%%%%%%%%%%% TRANSITION           
          if exist ('RRdistancetransition_win','var')==1
              for i=1:length(RRdistancetransition_win)
                  if RRdistancetransition_win{1,i}
                      RRdistancetransition_win{1,i}(2,:)=circshift(RRdistancetransition_win{1,i}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                      [PSNR,MSEtransition{1,i},MAXERR,L2RAT] = measerr(RRdistancetransition_win{1,i}(1),RRdistancetransition_win{1,i}(2)); %Calculating MSE
                      RMSSD_transition=cellfun(@sqrt,MSEtransition, 'Un', false); %sqare root over the MSE of the adjacent NN intervals creates the RMSSD
                  end
              end
          end                  
 %%%%%%%%%%%%% POSITION           
          if exist ('RRdistanceposition_win','var')==1
              for i=1:length(RRdistanceposition_win)
                  if RRdistanceposition_win{1,i}
                      RRdistanceposition_win{1,i}(2,:)=circshift(RRdistanceposition_win{1,i}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                      [PSNR,MSEposition{1,i},MAXERR,L2RAT] = measerr(RRdistanceposition_win{1,i}(1),RRdistanceposition_win{1,i}(2)); %Calculating MSE
                      RMSSD_position=cellfun(@sqrt,MSEposition, 'Un', false); %sqare root over the MSE of the adjacent NN intervals creates the RMSSD
                  end
              end
          end 
 %%%%%%%%%%%%% NOT RELIABLE           
          if exist ('RRdistanceNot_reliable_win','var')==1
              for i=1:length(RRdistanceNot_reliable_win)
                  if RRdistanceNot_reliable_win{1,i}
                      RRdistanceNot_reliable_win{1,i}(2,:)=circshift(RRdistanceNot_reliable_win{1,i}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                      [PSNR,MSENot_reliable{1,i},MAXERR,L2RAT] = measerr(RRdistanceNot_reliable_win{1,i}(1),RRdistanceNot_reliable_win{1,i}(2)); %Calculating MSE
                      RMSSD_Not_reliable=cellfun(@sqrt,MSENot_reliable, 'Un', false); %sqare root over the MSE of the adjacent NN intervals creates the RMSSD
                  end
              end
          end          
%%%%%%%%%%%%replace [] with nan   

            if exist ('RMSSD_AS','var')
                ix=cellfun(@isempty,RMSSD_AS);
                RMSSD_AS(ix)={nan};  
            end
            if exist ('RMSSD_QS','var')
                ix=cellfun(@isempty,RMSSD_QS);
                RMSSD_QS(ix)={nan};
            end
            if exist ('RMSSD_Aalertness','var')
                ix=cellfun(@isempty,RMSSD_Aalertness);
                RMSSD_Aalertness(ix)={nan};  
            end
            if exist ('RMSSD_Qalertness','var')
                ix=cellfun(@isempty,RMSSD_Qalertness);
                RMSSD_Qalertness(ix)={nan};
            end            
            if exist ('RMSSD_transition','var')
                ix=cellfun(@isempty,RMSSD_transition);
                RMSSD_transition(ix)={nan};  
            end
            if exist ('RMSSD_position','var')
                ix=cellfun(@isempty,RMSSD_position);
                RMSSD_position(ix)={nan};
            end  
            if exist ('RMSSD_Not_reliable','var')
                ix=cellfun(@isempty,RMSSD_Not_reliable);
                RMSSD_Not_reliable(ix)={nan};
            end                    
%%%%%%%%%%%%saving          
                if saving
                    folder=('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\HRV features\');
%%%%%%%%% AS QS                    
                    if exist('RMSSD_AS','var')==1 & exist ('RMSSD_QS','var')==1
                     save([folder 'RMSSD_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'RMSSD_AS','RMSSD_QS');
                    elseif exist('RMSSD_AS','var') ==1
                     save([folder 'RMSSD_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'RMSSD_AS');
                    elseif exist('RMSSD_QS','var') ==1
                     save([folder 'RMSSD_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'RMSSD_QS');
                    end
%%%%%%%% WAKE                    
                    if exist('RMSSD_Aalertness','var')==1 & exist ('RMSSD_Qalertness','var')==1
                     save([folder 'RMSSD_Wake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'RMSSD_Aalertness','RMSSD_Qalertness');
                    elseif exist('RMSSD_Aalertness','var') ==1
                     save([folder 'RMSSD_Wake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'RMSSD_Aalertness');
                    elseif exist('RMSSD_Qalertness','var') ==1
                     save([folder 'RMSSD_Wake_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'RMSSD_Qalertness');
                    end   
%%%%%%%% TRANSITION
                    if exist('RMSSD_transition','var')==1 
                     save([folder 'RMSSD_transition_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'RMSSD_transition');
                    end    
%%%%%%%% POSITION
                    if exist('RMSSD_position','var')==1 
                     save([folder 'RMSSD_position_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'RMSSD_position');
                    end 
%%%%%%%% NOT RELIABLE
                    if exist('RMSSD_Not_reliable','var')==1 
                     save([folder 'RMSSD_Not_reliable_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat'],'RMSSD_Not_reliable');
                    end          
                    
                    clearvars -except j pat saving win Neonate
                end% saving
            
      end%win
end