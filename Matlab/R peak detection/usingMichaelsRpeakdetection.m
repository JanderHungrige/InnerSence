function [RRdistanceQS,RRdistanceAS,RpeakindxQS,RpeakAS]= usingMichaelsRpeakdetection(win,saving,FS,Neonate,overlap)
%this function loads the devided AS and QS parts and determines the R peaks
%and the distance between the R peaks.
% the Chunks are created by the function "ECGwithAnnotations_5min" 
%if saving is 1, this function will save the Rpeak index and the distances
%plus the ECGchunks into mat files

        folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\ECG_chunks\';

   
                
        if exist  (([folder 'ChunkAS' num2str(Neonate) '_win' num2str(win) '_overlap' num2str(overlap) '.mat']))
         load ([folder 'ChunkAS' num2str(Neonate) '_win' num2str(win) '_overlap' num2str(overlap) '.mat']);
        end
        if exist([folder 'ChunkQS' num2str(Neonate) '_win' num2str(win) '_overlap' num2str(overlap) '.mat'])
         load ([folder 'ChunkQS' num2str(Neonate) '_win' num2str(win) '_overlap' num2str(overlap) '.mat']);
        end


for J=1:length(ChunkAS)
    if isempty(ChunkAS{1,J})==0 % Chunks are continuously. If No annotation Chunk=[]
       if (nansum(ChunkAS{1,J}(2,:))~=0) ==1 % due to the elimination of caregiving there can be nan`s instead of values           
           ecgAS=ChunkAS{1,J}; % streamingpeakdetection needs one ECG array, not a cell
           ploting=0;
           [RpeakindxAS] = streamingpeakdetection(ecgAS(2,:), FS, [60 256], ploting, 18.5, 1024);
%            HRVChunkAS{1,J}=RpeakAS; % combining the R peak results again into a cell

           Distance_AS=diff(RpeakindxAS.peakPositionArray)./FS; % Calculating the time between the R peaks in seconds
           RRdistanceAS{1,J}=Distance_AS; % combining the time in cell structur
           RpeakAS{1,J}=RpeakindxAS;      % combining the R peak indx in cell structur
       end
    end
end

for k=1:length(ChunkQS)
    if isempty(ChunkQS{1,k})==0 % Chunks are continuously. If No annotation Chunk=[]
       if (nansum(ChunkQS{1,k}(2,:))~=0) ==1 % due to the elimination of caregiving ther can be nan`s instead of values          
          ecgQS=ChunkQS{1,k};% streamingpeakdetection needs one ECG array, not a cell
          ploting=0;
          [RpeakindxQS] = streamingpeakdetection(ecgQS(2,:), FS, [60 256], ploting, 18.5, 1024);
%           HRVChunkQS{1,k}=RpeakQS;% combining the R peak results again into a cell

          Distance_QS=diff(RpeakindxQS.peakPositionArray)./FS; % Calculating the time between the R peaks in seconds
          RRdistanceQS{1,k}=Distance_QS;% combining the time in cell structur
          RpeakQS{1,k}=RpeakindxQS;
       end
    end
 end

cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab');


if saving
    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks\Rojackers\';
    %saving R peaks positions in mat file
    save([folder 'Rpeaks' num2str(Neonate) ' _ ' num2str(win) 's_win_overlap_' num2str(overlap) '.mat'],'RpeakQS','RpeakAS');
    %saving R to R distance in mat file
    save([folder 'RRdistance' num2str(Neonate) ' _ ' num2str(win) 's_win_overlap_' num2str(overlap) '.mat'],'RRdistanceQS','RRdistanceAS');
end


end