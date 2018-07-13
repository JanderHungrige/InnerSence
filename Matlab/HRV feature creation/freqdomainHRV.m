% frequency domain measures of HRV
% this functioncalculates the frequenc donain features over 30 sec epochs,
% while " freqdomain_single.m"  alculates the features over a non splittet 
% signal,ecept for the states AS,QS,...

%%%%%short term analysis (5min)
% 5min total power (<0.4 Hz) % new (<1.5 Hz)
% VLF power in very low frequency range (adult 0.003-0.04 Hz)
% LF  power in low frequency range (adult 0.04-0.15 Hz)
% LFnorm  LF power in normalized units LF/(total power-vlf)*100 or LF/(LF+HF)*100
% HF power in high frequency range (adult 0.15-0.4 Hz)
% HFnorm HF power in normalized units HF/(total power-vlf)*100 or HF/(LF+HF)*100
% LF/HF Ratio LF/HF
% super high frequency sHF(0.4-0.7 Hz)
% ultra high frequency uHF(0.7-1.5 Hz)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function freqdomainHRV (pat,plotting,win,saving,loadfolder,savefolder)
 Neonate=pat;

    for j=1:length(win)
         
%%%%%%%%%%%%%%%checking if file exist / loading

        load([loadfolder 'spectrum_' num2str(Neonate) '_win_' num2str(win(1,j))],'pxx','pxx_normalized','f');
                   
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
    %% total power (< 1.5 Hz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
upperboundary=1.5;

            if exist('pxx','var')
                totpow=cell(3,length(pxx));
                for k=1:length(pxx)
                    if isempty(pxx{1,k})==0
                        totpow{1,k}=nansum(pxx{1,k}(f{1,k}<upperboundary));
                        totpow{2,k}=pxx{2,k};% add annotations
                        totpow{3,k}=pxx{3,k};
                    end
                end
            end
            if exist('pxx_normalized','var')
                totpow_normalized=cell(3,length(pxx_normalized));                
                for k=1:length(pxx_normalized)
                    if isempty(pxx_normalized{1,k})==0
                        totpow_normalized{1,k}=nansum(pxx_normalized{1,k}(f{1,k}<upperboundary));
                        totpow_normalized{2,k}=pxx_normalized{2,k};% add annotations                 
%                         totpow_normalized{3,k}=pxx_normalized{3,k};                        
                    end
                end
            end

%%%%%%%%%%%%%% SAVING            
            if saving
                powersaving(totpow,savefolder,Neonate,win(1,j))
                powersaving(totpow_normalized,savefolder,Neonate,win(1,j))                
            end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% VLF power in very low frequency range (adult 0.003-0.04 Hz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
upperboundary=0.04;
lowerboundary=0.003;

           if exist('pxx','var')
               VLF_band=cell(1,length(pxx)); %preallocation
               for k=1:length(pxx)
                   if isempty(pxx{1,k})==0
                       F=f{1,k}<upperboundary; % F is binary 1 
                       F(f{1,k}<lowerboundary)=0; % binray F becomes 0 for indices under lowerboundary
    %                        VLF_band{1,l}=f{1,k}(F,1); % determine the frequency bands
                       VLF_band{1,k}=pxx{1,k}(F,1);%power
                   end
               end
               VLF=cellfun(@sum,VLF_band,'UniformOutput',false);
    %                 VLF(find([VLF{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx) % add annotations
                   VLF{2,k}=pxx{2,k};
                   VLF{3,k}=pxx{3,k};
               end                   
           end % exist

            if exist('pxx_normalized','var')
                VLF_band_normalized=cell(1,length(pxx_normalized)); %preallocation
                for k=1:length(pxx_normalized)
                    if isempty(pxx_normalized{1,k})==0
                        F=f{1,k}<upperboundary;
                        F(f{1,k}<lowerboundary)=0;
    %                         VLF_band_normalized{1,l}=f{1,l}(F,1); % determine the frequency bands
                        VLF_band_normalized{1,k}=pxx_normalized{1,k}(F,1);%power
                    end
                end
                VLF_normalized=cellfun(@sum,VLF_band_normalized,'UniformOutput',false);
    %                 VLF(find([VLF{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx_normalized) % add annotations
                   VLF_normalized{2,k}=pxx_normalized{2,k};
%                    VLF_normalized{3,k}=pxx_normalized{3,k};
               end      
             end
           
     
%%%%%%%%%% SAVING            
            if saving
                powersaving(VLF,savefolder,Neonate,win(1,j))
                powersaving(VLF_normalized,savefolder,Neonate,win(1,j))                
            end
clearvars F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
    %% LF  power in low frequency range (adult 0.04-0.15 Hz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
upperboundary=0.15;
lowerboundary=0.04;
            if exist('pxx','var')
                LF_band=cell(1,length(pxx));
                for k=1:length(pxx)
                    if isempty(pxx{1,k})==0
                        F=f{1,k}<upperboundary;
                        F(f{1,k}<lowerboundary)=0;
%                         LF_band{1,l}=f{1,l}(F,1);%frequency
                        LF_band{1,k}=pxx{1,k}(F,1);%power
                    end
                end
                LF=cellfun(@sum,LF_band,'UniformOutput',false);
%                 LF(find([LF{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx) % add annotations
                   LF{2,k}=pxx{2,k};
                   LF{3,k}=pxx{3,k};
               end   
            end

            if exist('pxx_normalized','var')
                LF_band=cell(1,length(pxx_normalized));                
                for k=1:length(pxx_normalized)
                    if isempty(pxx_normalized{1,k})==0
                        F=f{1,k}<upperboundary;
                        F(f{1,k}<lowerboundary)=0;
%                         LF_band{1,l}=f{1,l}(F);% frequency 
                        LF_band{1,k}=pxx_normalized{1,k}(F);% power 
                    end
                end
                LF_normalized=cellfun(@sum,LF_band,'UniformOutput',false);
%                 LF_mormalized(find([LF_mormalized{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx_normalized) % add annotations
                   LF_normalized{2,k}=pxx_normalized{2,k};
%                    LF_normalized{3,k}=pxx_normalized{3,k};
               end  
            end
      
%%%%% SAVING
            if saving
                powersaving(LF,savefolder,Neonate,win(1,j))
                powersaving(LF_normalized,savefolder,Neonate,win(1,j))                
            end
clearvars  F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% LFnorm  LF power in normalized units LF/(total power-vlf)*100 or LF/(LF+HF)*100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          if exist('pxx','var')
               for k=1:length(LF)
                    LFnorm{1,k}=(LF{1,k}./(totpow{1,k}-VLF{1,k}))*100; % before LFnorm_AS=((cell2mat(LF_AS))./totpowAS)*100;
                    LFnorm{2,k}=pxx{2,k};
                    LFnorm{3,k}=pxx{3,k};                    
    %                 LFnorm_AS(LFnorm_AS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
               end
          end
          
          if exist('pxx_normalized','var')
               for k=1:length(LF_normalized)
                    LFnorm_normalized{1,k}=(LF_normalized{1,k}./(totpow_normalized{1,k}-VLF_normalized{1,k}))*100;
                    LFnorm_normalized{2,k}=pxx_normalized{2,k};
%                     LFnorm_normalized{3,k}=pxx_normalized{3,k};                    
%                     LFnorm_QS(LFnorm_QS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
               end
          end

%%%% SAVING
            if saving
                powersaving(LFnorm,savefolder,Neonate,win(1,j))
                powersaving(LFnorm_normalized,savefolder,Neonate,win(1,j))                
            end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% HF power in high frequency range (adult 0.15-0.4 Hz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
upperboundary=0.4;
lowerboundary=0.15;
          if exist('pxx','var')
                HF_band=cell(1,length(pxx)); %preallocation
                for k=1:length(pxx)
                    if isempty(pxx{1,k})==0
                        F=f{1,k}<upperboundary;
                        F(f{1,k}<lowerboundary)=0;
    %                         HF_band{1,l}=f{1,l}(F,1);% frequency
                        HF_band{1,k}=pxx{1,k}(F,1);% power
                    end
                end
                HF=cellfun(@sum,HF_band,'UniformOutput',false);
    %                     HF(find([HF{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx) % add annotations
                   HF{2,k}=pxx{2,k};
                   HF{3,k}=pxx{3,k};
               end     
          end

          if exist('pxx_normalized','var')          
                HF_band=cell(1,length(pxx_normalized)); %preallocation
                for k=1:length(pxx_normalized)
                    if isempty(pxx_normalized{1,k})==0
                        F=f{1,k}<upperboundary;
                        F(f{1,k}<lowerboundary)=0;
    %                             HF_QS_band{1,l}=fQS{1,l}(FQS);% frequency
                        HF_band{1,k}=pxx_normalized{1,k}(F);% power
                    end
                end
                HF_normalized=cellfun(@sum,HF_band,'UniformOutput',false);
    %                     HF_normalized(find([HF_normalized{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx_normalized) % add annotations
                   HF_mormalized{2,k}=pxx_normalized{2,k};
%                    HF_mormalized{3,k}=pxx_normalized{3,k};
               end  
          end
%%%%%%%%% Saving
            if saving
                powersaving(HF,savefolder,Neonate,win(1,j))
                powersaving(HF_normalized,savefolder,Neonate,win(1,j))                
            end
clearvars F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% HFnorm HF power in normalized units HF/(total power-vlf)*100 or HF/(LF+HF)*100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

              if exist('pxx','var')
               for k=1:length(HF)
                    HFnorm{1,k}=(HF{1,k}./(totpow{1,k}-VLF{1,k}))*100; % before LFnorm_AS=((cell2mat(LF_AS))./totpowAS)*100;
                    HFnorm{2,k}=pxx{2,k};%annotaions
                    HFnorm{3,k}=pxx{3,k};                    
    %                 LFnorm_AS(LFnorm_AS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
               end
              end
              
              if exist('pxx_normalized','var')
               for k=1:length(HF_normalized)
                    HFnorm_normalized{1,k}=(HF_normalized{1,k}./(totpow_normalized{1,k}-VLF_normalized{1,k}))*100; % before LFnorm_AS=((cell2mat(LF_AS))./totpowAS)*100;
                    HFnorm_normalized{2,k}=pxx_normalized{2,k};%annotations
%                     HFnorm_normalized{3,k}=pxx_normalized{3,k};                    
    %                 LFnorm_AS(LFnorm_AS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
               end                  
              end
              
%%%%%% SAVING              
            if saving
                powersaving(HFnorm,savefolder,Neonate,win(1,j))
                powersaving(HFnorm_normalized,savefolder,Neonate,win(1,j))                
            end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  sHF power in super high frequency range (preterm 0.4-0.7 Hz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
upperboundary=0.7;
lowerboundary=0.4;
            if exist('pxx','var')
                sHF_band=cell(1,length(pxx)); %preallocation
                for k=1:length(pxx)
                    if isempty(pxx{1,k})==0
                        F=f{1,k}<upperboundary;
                        F(f{1,k}<lowerboundary)=0;
%                         sHF_band{1,l}=f{1,l}(F,1);% frequency
                        sHF_band{1,k}=pxx{1,k}(F,1);% power
                    end
                end
                sHF=cellfun(@sum,sHF_band,'UniformOutput',false);
%                sHF(find([sHF{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx) % add annotations
                   sHF{2,k}=pxx{2,k};
                   sHF{3,k}=pxx{3,k};
               end  
            end

          if exist('pxx_normalized','var')          
                sHF_band=cell(1,length(pxx_normalized)); %preallocation
                for k=1:length(pxx_normalized)
                    if isempty(pxx_normalized{1,k})==0
                        F=f{1,k}<upperboundary;
                        F(f{1,k}<lowerboundary)=0;
%                        sHF_band{1,l}=f{1,l}(F);% frequency
                        sHF_band{1,k}=pxx_normalized{1,k}(F);% power
                    end
                end
                sHF_normalized=cellfun(@sum,sHF_band,'UniformOutput',false);
%                sHF_normalized(find([sHF_normalized{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx_normalized) % add annotations
                   sHF_normalized{2,k}=pxx_normalized{2,k};
%                    sHF_normalized{3,k}=pxx_normalized{3,k};
               end  
          end

          
%%%%%% SAVING
            if saving
                powersaving(sHF,savefolder,Neonate,win(1,j))
                powersaving(sHF_normalized,savefolder,Neonate,win(1,j))                
            end
clearvars  F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% sHFnorm sHF power in normalized units HF/(total power-vlf)*100 or HF/(LF+HF)*100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
          if exist('pxx','var')
               for k=1:length(sHF)
                    sHFnorm{1,k}=(sHF{1,k}./(totpow{1,k}-VLF{1,k}))*100; % before LFnorm_AS=((cell2mat(LF_AS))./totpowAS)*100;
                    sHFnorm{2,k}=pxx{2,k};
                    sHFnorm{3,k}=pxx{3,k};                    
    %                 LFnorm_AS(LFnorm_AS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
               end              
          end

          if exist('pxx_normalized','var')
               for k=1:length(sHF_normalized)
                    sHFnorm_normalized{1,k}=(sHF_normalized{1,k}./(totpow_normalized{1,k}-VLF_normalized{1,k}))*100; % before LFnorm_AS=((cell2mat(LF_AS))./totpowAS)*100;
                    sHFnorm_normalized{2,k}=pxx_normalized{2,k};
%                     sHFnorm_normalized{3,k}=pxx_normalized{3,k};                    
    %                 LFnorm_AS(LFnorm_AS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
               end                  
          end

%%%%%% SAVING              
            if saving
                powersaving(sHFnorm,savefolder,Neonate,win(1,j))
                powersaving(sHFnorm_normalized,savefolder,Neonate,win(1,j))                
            end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  uHF power in ultra high frequency range (preterm 0.7-1.5 Hz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
upperboundary=1.5;
lowerboundary=0.7;
          if exist('pxx','var')
            uHF_band=cell(1,length(pxx)); %preallocation
            for k=1:length(pxx)
                if isempty(pxx{1,k})==0
                    F=f{1,k}<upperboundary;
                    F(f{1,k}<lowerboundary)=0;
%                         uHF_band{1,l}=f{1,l}(F,1);% frequency
                    uHF_band{1,k}=pxx{1,k}(F,1);% power
                end
            end
            uHF=cellfun(@sum,uHF_band,'UniformOutput',false);
%                     uHF(find([uHF{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx) % add annotations
                   uHF{2,k}=pxx{2,k};
                   uHF{3,k}=pxx{3,k};
               end  
          end

          if exist('pxx_normalized','var')          
            uHF_band=cell(1,length(pxx_normalized)); %preallocation
            for k=1:length(pxx_normalized)
                if isempty(pxx_normalized{1,k})==0
                    F=f{1,k}<upperboundary;
                    F(f{1,k}<lowerboundary)=0;
%                             uHF_band{1,l}=f{1,l}(F);% frequency
                    uHF_band{1,k}=pxx_normalized{1,k}(F);% power
                end
            end
            uHF_normalized=cellfun(@sum,uHF_band,'UniformOutput',false);
%                     uHF_normalized(find([uHF_normalized{:}] == 0))={nan};  % 0 into nan
               for k=1:length(pxx_normalized) % add annotations
                   uHF_normalized{2,k}=pxx_normalized{2,k};
%                    uHF_normalized{3,k}=pxx_normalized{3,k};
               end  
          end
 
%%%%%% SAVING
            if saving
                powersaving(uHF,savefolder,Neonate,win(1,j))
                powersaving(uHF_normalized,savefolder,Neonate,win(1,j))                
            end
clearvars  F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% uHFnorm uHF power in normalized units uHF/(total power-vlf)*100 or uHF/(LF+HF+sHF+uHF)*100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
              if exist('pxx','var')
               for k=1:length(uHF)
                    uHFnorm{1,k}=(uHF{1,k}./(totpow{1,k}-VLF{1,k}))*100; % before LFnorm_AS=((cell2mat(LF_AS))./totpowAS)*100;
                    uHFnorm{2,k}=pxx{2,k};
                    uHFnorm{3,k}=pxx{3,k};                    
    %                 LFnorm_AS(LFnorm_AS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
               end  
              end
              
              if exist('pxx_normalized','var')
               for k=1:length(uHF_normalized)
                    uHFnorm_normalized{1,k}=(uHF_normalized{1,k}./(totpow_normalized{1,k}-VLF_normalized{1,k}))*100; % before LFnorm_AS=((cell2mat(LF_AS))./totpowAS)*100;
                    uHFnorm_normalized{2,k}=pxx_normalized{2,k};
%                     uHFnorm_normalized{3,k}=pxx_normalized{3,k};                    
    %                 LFnorm_AS(LFnorm_AS==0)=nan; %all zeroes to nan to avoid confusion between AS and QS
               end  
              end
           
%%%%%% SAVING              
            if saving
                powersaving(uHFnorm,savefolder,Neonate,win(1,j))
                powersaving(uHFnorm_normalized,savefolder,Neonate,win(1,j))                
            end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% LF/HF Ratio LF/HF  LF/HFsHFuHF Ratio LF/(HF+sHF+uHF )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

              if exist('pxx','var')
                  for k=1:length(pxx)
                      ratioLFHF{1,k}=LF{1,k}/HF{1,k};
                      ratioLFHF{2,k}=pxx{2,k}; %annotations
                      ratioLFHF{3,k}=pxx{3,k};
                      
                      ratioLFHFsHFuHF{1,k}=LF{1,k}/(HF{1,k}+sHF{1,k}+uHF{1,k});
                      ratioLFHFsHFuHF{2,k}=pxx{2,k}; %annotations
                      ratioLFHFsHFuHF{3,k}=pxx{3,k};         
                      
                      ratioLFsHFuHF{1,k}=LF{1,k}/(sHF{1,k}+uHF{1,k});
                      ratioLFsHFuHF{2,k}=pxx{2,k}; %annotations
                      ratioLFsHFuHF{3,k}=pxx{3,k};                        
                      
                      
                  end
              end
              if exist('pxx_normalized','var')                                  
                  for k=1:length(pxx_normalized)
                      ratioLFHF_normalized{1,k}=LF_normalized{1,k}/HF_normalized{1,k};
                      ratioLFHF_normalized{2,k}=pxx_normalized{2,k}; %annotations
%                       ratioLFHF_normalized{3,k}=pxx_normalized{3,k};
                      
                      ratioLFHFsHFuHF_normalized{1,k}=LF_normalized{1,k}/(HF_normalized{1,k}+sHF_normalized{1,k}+uHF_normalized{1,k});
                      ratioLFHFsHFuHF_normalized{2,k}=pxx{2,k}; %annotations
%                       ratioLFHFsHFuHF_normalized{3,k}=pxx{3,k};         
                      
                      ratioLFsHFuHF_normalized{1,k}=LF{1,k}/(sHF_normalized{1,k}+uHF_normalized{1,k});
                      ratioLFsHFuHF_normalized{2,k}=pxx{2,k}; %annotations
%                       ratioLFsHFuHF_normalized{3,k}=pxx{3,k};                            
                  end
              end                                  
           
%%%%%%% SAVING
            if saving
                powersaving(ratioLFHF,savefolder,Neonate,win(1,j))
                powersaving(ratioLFHF_normalized,savefolder,Neonate,win(1,j))                
            end
            
   
    end % win end
        
%% Nested saving        
    function powersaving(Feature,savefolder, Neonate, win)
        if exist('Feature','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_' num2str(Neonate) '_win_' num2str(win)],'Feature')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end

end

