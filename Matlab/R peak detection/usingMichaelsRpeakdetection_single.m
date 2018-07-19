function [timebetweenRQS,timebetweenRAS,RpeakQS,RpeakAS]= usingMichaelsRpeakdetection_single(AS,QS,saving,plotting,FS,Neonate,overlaping)
cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\R peak detection and HRV')

%deleting nan
empt=isnan(AS);
empt=sum(empt);
AS=AS(:,(empt<1));

empt2=isnan(QS);
empt2=sum(empt2);
QS=QS(:,(empt2<1));

%get R peaks
[RpeakAS] = streamingpeakdetection(AS(2,:), FS, [100 256], plotting, 18.5, 1024);%Rpeak detection
%[RpeakQS] = streamingpeakdetection(QS(2,:), FS, [100 256], plotting, 18.5, 1024);

exist overlaping
if ans==1
else overlapig=1;
end

%calc RR intervals
cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab')
%[timebetweenRQS]=RRpeaksinms(RpeakAS,AS,QS,'AS',saving,Neonate,overlaping);
%[timebetweenRAS]=RRpeaksinms(RpeakQS,AS,QS,'QS',saving,Neonate,overlaping); %calculate and save RR difference


% RRdistanceAS=diff(RpeakAS.peakPositionArray)./Fs; % Calculating the time between the R peaks in seconds
% RRdistanceAS=diff(RpeakQS.peakPositionArray)./Fs; % Calculating the time between the R peaks in seconds
% 

    if saving
        folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\RR distance\';
        %saving R peaks positions in mat file
        save([folder 'Rpeaks' num2str(Neonate) '.mat'],'RpeakQS','RpeakAS');
        %saving R to R distance in mat file
        save([folder 'RRdistance' num2str(Neonate) '.mat'],'timebetweenRQS','timebetweenRAS');
    end
end