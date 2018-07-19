function SDaLL(ECG,t_ECG,Neonate,saving,savefolder,win,faktor,Session,S)  
%Input
% RR: 5min RR distance data
% Neonate: Which patient
% saving: If saving is whished
% savefolder: Where to save
% win: Duration of the HRV window. Comon is 5min/300s
% factor: How much the SIgnal is shifted each itteration. 30s is common. 

% This fuction calculate the std of 30s epoch and means them. Then they are
% merged into 5 min windows

% #1 first calculate LL for each 30s Epoch.
% #2 merge those 30s Epoch to 5min
% #3 mean them 

% #1
[b,a] = butter(3,[0.09 0.29],'stop'); %bandstop with [] in Normalized Frequency x Pi rad/sample
for L=1:length(ECG)
    ECG{1,L} = filtfilt(b,a,ECG{1,L}); %zero phase filter to get rid of QRS complex
    [lineLength{1,L}] = arclength(t_ECG{1,L},(ECG{1,L}),'linear');
end


% #2 
win_jumps=faktor/faktor; % as it is already on 30s epoch we need a shift by 1
Fenster=win/30; % 300/30= 10 parts a 30s => 5min 
m=1;
uebrig=length(lineLength);  % how many minutes are left           

for k=1:win_jumps:length(lineLength)
   if k+Fenster<length(lineLength) 
       SDaLL{1,m}=lineLength(1,k:k+Fenster-1); 
   elseif k+Fenster>=length(lineLength) && win_jumps<=uebrig && k>win_jumps*(Fenster-(uebrig/win_jumps)*win_jumps)/win_jumps
       rechts=uebrig/win_jumps;% How many epochs are still left 
       links=(Fenster-rechts*win_jumps)/win_jumps; % how many epochs do we have to atahe from the left to get a full 300s window
       SDaLL{1,m}=lineLength(1,k-win_jumps*links:k+win_jumps*rechts-1);
   elseif k+Fenster>=length(lineLength) &&  win_jumps>uebrig && k>win_jumps*(Fenster-(uebrig/win_jumps)*win_jumps)/win_jumps     
       rechts=uebrig/win_jumps;% How many epochs are still left 
       links=(Fenster-rechts*win_jumps)/win_jumps; % how many epochs do we have to atahe from the left to get a full 300s window
       SDaLL{1,m}=lineLength(1,k-win_jumps*links:end);       
   else
       SDaLL{1,m}=lineLength(1,k:end);
%            break       % if you want to end with the same length for the clast cell elementas the others use break. But than the ECG_win_300 is one element shorter thatn ECG_win_30    
   end
   uebrig=length(lineLength)-(k+win_jumps);  % how many minutes are left              
   m=m+1;
end
% Original &&&&&&&&&&&&&&&&&&&&&&&&& Working
% for K=1:win_jumps:length(lineLength)
%    if K+Fenster<length(lineLength) 
%      SDaLL{1,m}=lineLength(1,K:K+Fenster-1);      
%    elseif K+Fenster>=length(lineLength) 
%        SDaLL{1,m}=lineLength(1,K:end);
%        break
%    end
%    m=m+1;
% end
% Original &&&&&&&&&&&&&&&&&&&&&&&&& Working



% #3   
for N=1:length(SDaLL)
   SDaLL{1,N}=nanmean(cell2mat(SDaLL{1,N}));
end      

%%%%%%%%%%%% SAVING            
    if saving                     %saving R peaks positions in mat file                 
       Saving(SDaLL,savefolder,Neonate,win,Session,S) 
    end% end if saving    
    
end
%% Nested saving
    function Saving(Feature,savefolder, Neonate, win,Session,S)
        if exist('Feature','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_Session_' num2str(S) '_win_' num2str(win) '_' Session],'Feature')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end
