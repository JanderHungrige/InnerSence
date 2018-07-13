%Frequency analysis

%[pxx,f] = plomb(x,t) returns the Lomb-Scargle power spectral density (PSD) estimate, pxx, of a signal, x, that is sampled at the instants specified in t. 
% t must increase monotonically but need not be uniformly spaced. All elements of t must be nonnegative. pxx is evaluated at the frequencies returned in f.


function Lomb_scargel_30secepoch(Neonate,plotting,win,saving, loadfolder, savefolder)
        for j=1:length(win)
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% UN-WINDOWED DATA (30 sec epochs only)       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if win(1,j)==30
                load([loadfolder 'consence_RR_' num2str(Neonate) '_win_30'],'consence_RR_30s')  
                
%Data preprocessing
%                   if exist('consence_RR_30s','var') == 1
%             %removing outlier
%                     for l=1:length(consence_RR_30s)
%                         if isempty(consence_RR_30s{1,l})==0
%                             all_idx = 1:length(consence_RR_30s{1,l}(2,:));
%                             outlier_idx = abs(consence_RR_30s{1,l}(2,:) - median(consence_RR_30s{1,l}(2,:))) > 3*std(consence_RR_30s{1,l}(2,:)); % Find outlier idx
%                             consence_RR_30s{1,l}(2:outlier_idx) = interp1(all_idx(~outlier_idx), consence_RR_30s{1,l}(2,~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
%                         end
%                     end
%                  end
%  

% create spectrum
[merged_annotation, annotations]=annotations_for_spectrum(consence_RR_30s); %nested, see at the end

%Create spectrum
                %lomb scargel
                     if exist('consence_RR_30s','var') == 1
                        for k=1:length(consence_RR_30s)
                            if isempty(consence_RR_30s{1,k})==0 & isnan(consence_RR_30s{1,k}(2,:))==0
                                [pxx{1,k},f{1,k}] = plomb(consence_RR_30s{1,k}(2,:),consence_RR_30s{1,k}(1,:));
                                [pxx_normalized{1,k},~] = plomb(consence_RR_30s{1,k}(2,:),consence_RR_30s{1,k}(1,:),'normalized');
                                pxx{2,k}=merged_annotation{1,k}; %add the merged annotations
                                pxx{3,k}=annotations;
                                pxx_normalized{2,k}=merged_annotation{1,k};
                            end
                        end
                     end                 

                     %saving
                     if saving==1
                        if exist('pxx','var')==1
                        save([savefolder 'spectrum_' num2str(Neonate) '_win_30'],'pxx', 'pxx_normalized', 'f' )
                        end
                     end
                    
                    %plotting                                                
                     if plotting==1 
                         for k=1:length(consence_RR_30s)
                              if isempty(consence_RR_30s{1,k})==0
                                  figure l
                                  plomb(consence_RR_30s{1,k}(2,:),consence_RR_30s{1,k}(1,:))                         
                                  title (['Lomb-Scargle periodogram patient: ' num2str(Neonate) '_30s' ])
        %                             xlabel('Frequency')
                              end                                
                         end                         
                     end
                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                       
%%%%%%%%%%%%% WINDOWED DATA                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            else
                load([loadfolder 'consence_RR_' num2str(Neonate) '_win_' num2str(win(1,j))],'consence_RR_windowed')
                
%Data preprocessing
                       %remove outlier
%                         for l=1:length(consence_RR_windowed)
%                             if isempty(consence_RR_windowed{1,l})==0
%                                 all_idx = 1:length(consence_RR_windowed{1,l});
%                                 outlier_id('consence_RR_windowed','var') == 1
%                                 outlier_idx = abs(consence_RR_windowed{1,l} - median(consence_RR_windowed{1,l})) > 3*std(consence_RR_windowed{1,l}); % Find outlier idx                     
%                                 consence_RR_windowed{1,l}(outlier_idx) = interp1(all_idx(~outlier_idx), consence_RR_windowed{1,l}(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
%                             end
%                         end                        
                
%%%%%%%% Create merged annotations for Spectrum
    %AS the spectrum is not linked to time, we need one annotation if
    %several 30s epochs are merged
[merged_annotation, annotations]=annotations_for_spectrum(consence_RR_windowed); %nested , see at the end

       
%%%%%%%%Create spectrum

                %lomb scargel
                   if exist('consence_RR_windowed','var') == 1
                        for k=1:length(consence_RR_windowed)
                            if isempty(consence_RR_windowed{1,k})==0 & isnan(consence_RR_windowed{1,k}(2,:))==0                                
                                [pxx{1,k},f{1,k}] = plomb(consence_RR_windowed{1,k}(2,:),consence_RR_windowed{1,k}(1,:));
                                [pxx_normalized{1,k},~] = plomb(consence_RR_windowed{1,k}(2,:),consence_RR_windowed{1,k}(1,:),'normalized');
                                pxx{2,k}=merged_annotation{1,k}; %add the merged annotations
                                pxx{3,k}=annotations;
                                pxx_normalized{2,k}=merged_annotation{1,k};
                            end
                        end
                   end 
                    
                   %saving
                    if saving==1
                        if exist('pxx', 'var')==1
                        save([savefolder 'spectrum_' num2str(Neonate) '_win_' num2str(win(1,j))],'pxx', 'pxx_normalized', 'f' )
                        end
                    end
                    
                    %plotting                                                
                        if plotting  ==1
                            for k=1:length(consence_RR_windowed)
                                if isempty(consence_RR_windowed{1,k})==0
                                    figure l
                                    plomb(consence_RR_windowed{1,k}(2,:),consence_RR_windowed{1,k}(1,:))                         
                                    title (['Lomb-Scargle periodogram patient: ' num2str(Neonate) ' win ' num2str(win) ])
        %                             xlabel('Frequency')
                                end
                            end
                        end

            end % if win ==30
        end % for win 
    
           
        
%% %%%%%% Create annotations for Spectrum 
    function [merged_annotation, annotations]=annotations_for_spectrum(in)
        for i=1:length(in)
            if isempty(in{1,i})==0
                %Counting the incidence of a annotation
                AS=nansum(in{1,i}(3,:)); % counting AS
                ASNan=sum(isnan(in{1,i}(3,:)));% counting NAN in AS
                QS=nansum(in{1,i}(4,:)); % counting AS
                QSNan=sum(isnan(in{1,i}(4,:)));% counting NAN in AS
                Qallertness=nansum(in{1,i}(5,:)); % counting AS
                QallertnessNan=sum(isnan(in{1,i}(5,:)));% counting NAN in AS
                Aallertness=nansum(in{1,i}(6,:)); % counting AS
                AallertnessNan=sum(isnan(in{1,i}(6,:)));% counting NAN in AS
                Notreliable=nansum(in{1,i}(7,:)); % counting AS
                NotreliableNan=sum(isnan(in{1,i}(7,:)));% counting NAN in AS
                Transition=nansum(in{1,i}(8,:)); % counting AS
                TransitionNan=sum(isnan(in{1,i}(8,:)));% counting NAN in AS
                % comparing which incident is dominant. Nan has to be
                % dominant with +1/4 over the others to not loos to much data at the boarders. 
                if AS>QS & AS>Qallertness & AS>Aallertness
                    merged_annotation{1,i}(1,:)=1;%AS
                    if ASNan > (AS+AS/4) % if ther are 1/4 more nans then call it nan
                        merged_annotation{1,i}(1,:)=nan;    
                    end
                elseif QS>AS & QS>Qallertness & QS>Aallertness
                    merged_annotation{1,i}(2,:)=1; %QS
                    if QSNan > (QS+QS/4) % if ther are 1/4 more nans then call it nan
                        merged_annotation{1,i}(2,:)=nan;
                    end
                elseif Qallertness>AS & Qallertness>QS & Qallertness>Aallertness
                    merged_annotation{1,i}(3,:)=1; %Aalertness
                    if QallertnessNan > (Qallertness+Qallertness/4) % if ther are 1/4 more nans then call it nan
                        merged_annotation{1,i}(3,:)=nan;
                    end
                elseif Aallertness>AS & Aallertness>QS & Aallertness>Qallertness
                    merged_annotation{1,i}(4,:)=1; %Aalertness
                    if AallertnessNan > (Aallertness+Aallertness/4) % if ther are 1/4 more nans then call it nan
                        merged_annotation{1,i}(4,:)=nan;
                    end
                elseif sum(~all(isnan(in{1,i}([3,4,5,6],:))))==0 %if all are nan
                    merged_annotation{1,i}([3,4,5,6],:)=nan; %all nan    
                end
          %----------------------
          % Those are separate from the others as they can apear in parallel
          %----------------------
                if Notreliable > NotreliableNan
                    merged_annotation{1,i}(5,:)=1; %Not reliable
                else
                    merged_annotation{1,i}(5,:)=nan; 
                end
                if Transition > TransitionNan
                    merged_annotation{1,i}(6,:)=1; %Transition
                else
                    merged_annotation{1,i}(6,:)=nan; 
                end
          %----------------------
          % Give annotations a name that they are not conused later. 
          % In the RR and ECG files (1,:) and (2,:) are time and data. Here it is
          % AS and QS as the time is not relevant in a spectrum and the datta is provided by pxx. This is indicated by naming them
          %----------------------                
                annotations{1,1}='AS';
                annotations{2,1}='QS';
                annotations{3,1}='Quite allertness';
                annotations{4,1}='Active allertness';
                annotations{5,1}='Not reliable';
                annotations{6,1}='Transition';

            end
        end
    end% end neste function
        
end






