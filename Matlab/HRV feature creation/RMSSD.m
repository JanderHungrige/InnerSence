% RMSSD % ouput is the RMSSD, which is the sqrt(MSE) of the 5 minute epochs of the NN intervales. 
function RMSSD(pat,saving,win,loadfolder,savefolder)
Neonate=pat;
 
 for j=1:length(win)
         
%%%%%%%%%%%%%%%checking if file exist / loading

    if win(1,j)==30
        load([loadfolder 'consence_RR_' num2str(Neonate) '_win_' num2str(win(1,j))],'consence_RR_30s');
        consence_RR_windowed=consence_RR_30s;        
    else
        load([loadfolder 'consence_RR_' num2str(Neonate) '_win_' num2str(win(1,j))],'consence_RR_windowed');
    end

    [merged_annotation, annotations]=annotations_for_spectrum(consence_RR_windowed); %nested , see at the end
     
%%%%%%%%%%%%% Calc RMSSD           
     if exist ('consence_RR_windowed','var')==1
         for k=1:length(consence_RR_windowed)
            if isempty(consence_RR_windowed{1,k})==0 & sum(isnan(consence_RR_windowed{1,k}(2,:)))==0
                data_for_MSE{1,k}=consence_RR_windowed{1,k}(2,:);% original datastream to copare with the shifted for MSE. original file is to messy with all the annotations                
                data_for_MSE{1,k}(2,:)=circshift(data_for_MSE{1,k}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                if isempty(data_for_MSE{1,k})==0
                    [PSNR,MSE{1,k},MAXERR,L2RAT] = measerr(data_for_MSE{1,k}(1),data_for_MSE{1,k}(2)); %Calculating MSE
                    
%                     [PSNR,MSE{1,k},MAXERR,L2RAT] = measerr(data_for_MSE{1,k}(1),consence_RR_windowed{1,k}(2)); %Calculating MSE
                    RMSSD=cellfun(@sqrt,MSE, 'Un', false); %sqare root over the MSE of the adjacent NN intervals creates the RMSSD

                else
                    RMSSD{[1 2 3],k}=[];
                end
            
            end
         end
     end  
     RMSSD(2,:)=merged_annotation(1); % Merge with annotations
          
%%%%%%%%%%%%replace [] with nan
    %             if exist ('RMSSD','var')
    %                 ix=cellfun(@isempty,RMSSD);
    %                 RMSSD(ix)={nan};  
    %             end
    %           

%%%%%%%%%%%% SAVING            
    if saving                     %saving R peaks positions in mat file                 
       Saving(RMSSD,savefolder,Neonate,win(1,j)) 
    end% end if saving    
    
  end %window         
  
  
%% Nested function
  
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

%% Nested saving        
    function Saving(Feature,savefolder, Neonate, win)
        if exist('Feature','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_' num2str(Neonate) '_win_' num2str(win)],'Feature')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end


end