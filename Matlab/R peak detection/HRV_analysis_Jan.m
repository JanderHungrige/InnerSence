%function HRV_analysis(rpeakintervals)

%% geometrical analysis
% histogram
% sample density distribution of NN interval durations 

clear
clc
pat=[3,4,5,6,7,9,13];
pat=3;
for i=1:length(pat)
    Neonate=pat(i);
    
%AS
    load(['C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\RR distance2\RtimeAS' num2str(Neonate)]);
    if timebetweenR
        %remove outlier
        all_idx = 1:length(timebetweenR);
        outlier_idx = abs(timebetweenR - median(timebetweenR)) > 10*std(timebetweenR); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
        timebetweenR(outlier_idx) = interp1(all_idx(~outlier_idx), timebetweenR(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x

         bin=floor((max(timebetweenR)-min(timebetweenR))/(8/1000));   %bins for geometrical histogram analysis should be optimal 8ms (7,8125ms) broad (adult value)
         [histo,bin]=hist(timebetweenR,bin);  %creating histogram with 100 bins
         
        %calculting HRV triangular index
        Y_AS=max(histo);
        Triangularidx_AS(i,1)=(length(timebetweenR)/Y_AS);
           
        %calculating TINN
        Y=normpdf(histo);
        YY=mvnpdf(histo);
   histfit(timebetweenR,134)
         figure
        bar(bin,histo)
      %   histo=(histo./sum(histo)).*100; % normalizing the histogram in %
    end
%     pd=fitdist(histo','Normal');
%     yval=pdf(pd,bin);
    

    
    
 

    %calulating NNtri

%QS
    load(['C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\RR distance2\RtimeQS' num2str(Neonate)]);
    if timebetweenR

        %remove outlier
        all_idx = 1:length(timebetweenR);
        outlier_idx = abs(timebetweenR - median(timebetweenR)) > 10*std(timebetweenR); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
        timebetweenR(outlier_idx) = interp1(all_idx(~outlier_idx), timebetweenR(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x

       % bin2=floor((max(timebetweenR)-min(timebetweenR))/(8/1000));   %bins for geometrical histogram analysis should be optimal 8ms (7,8125ms) broad (adult value)
        [histo2]=hist(timebetweenR,bin);
        histo2=(histo2./sum(histo2)).*100;

        %statistical comparison between AS&QS histogram with p value
        [h,p(i)] = kstest2(histo,histo2);
    end
    
    %calculting HRV triangular index
    Y_QS=max(histo2);
    Triangularidx_QS(i,1)=(length(timebetweenR)/Y_QS);


    plot=0; % for figure plot=1
 if plot  
figure
hold on
bar(bin,[histo',histo2'])
% bar(bin,histo,'b')
% bar(bin2,histo2,'y')
text(10,37,4,['pvalue:' num2str(p)])
xlabel('RR distance in S');
ylabel('Appearance in percent');
legend('AS', 'QS')
title(['Patient' num2str(Neonate)])
% xlim([0.3 0.5])
hold off
 end
end

%% geometrical analysis 2
% histogram
% sample density distribution of adjacent NN interval durations

clear
clc
% pat=[3,4,5,6,7,9,10,13,15];
pat=13;
for i=1:length(pat)
    Neonate=pat(i);
    
%AS
    load(['C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\RR distance2\RtimeAS' num2str(Neonate)]);
    if timebetweenR
        %remove outlier
        all_idx = 1:length(timebetweenR);
        outlier_idx = abs(timebetweenR - median(timebetweenR)) > 10*std(timebetweenR); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
        timebetweenR(outlier_idx) = interp1(all_idx(~outlier_idx), timebetweenR(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
        
        %calcuate difference of adjacent NN intervals
        NNadjcacent= diff(timebetweenR);
        
         bin=floor((max(NNadjcacent)-min(NNadjcacent))/(8/1000));   %bins for geometrical histogram analysis should be optimal 8ms (7,8125ms) broad (adult value)
         [histo,bin]=hist(NNadjcacent,bin);  %creating histogram with n bins
         histo=(histo./sum(histo)).*100; % normalizing the histogram in %
    end
%QS
    load(['C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\RR distance2\RtimeQS' num2str(Neonate)]);
    if timebetweenR

        %remove outlier
        all_idx = 1:length(timebetweenR);
        outlier_idx = abs(timebetweenR - median(timebetweenR)) > 10*std(timebetweenR); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
        timebetweenR(outlier_idx) = interp1(all_idx(~outlier_idx), timebetweenR(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
  
        %calcuate difference of adjacent NN intervals
        NNadjcacent= diff(timebetweenR);
        
       %  bin2=floor((max(NNadjcacent)-min(NNadjcacent))/(8/1000));   %bins for geometrical histogram analysis should be optimal 8ms (7,8125ms) broad (adult value)
        [histo2]=hist(NNadjcacent,bin);
        histo2=(histo2./sum(histo2)).*100;

        %statistical comparison between AS&QS histogram with p value
        [h,p(i)] = kstest2(histo,histo2);
    end
    
figure
hold on
bar(bin,[histo', histo2'])
% bar(bin,histo,'b')
% bar(bin2,histo2,'y')
text(10,37,4,['pvalue:' num2str(p)])
xlabel('RR distance in S');
ylabel('Appearance in percent');
legend('AS', 'QS')
title(['Patient' num2str(Neonate)])
xlim([-0.1 0.1])
hold off
end
%end

%% SDNN
cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab')
pat=[3,4,5,6,7,9,10,13,15];
saving=1;
win=[30,60,120,180,240,300]; %window in seconds
for j=1:length(win)
    for k=1:length(pat)
        Neonate=pat(k);


    %checking if file exist
        cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks')
        if exist(fullfile(cd, ['RRdistance' num2str(Neonate) ' _ ' num2str(win(1,j)) 's_win.mat']), 'file') == 2 % ==> 0 or 2
          load(['C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks\RRdistance' num2str(Neonate) ' _ ' num2str(win(1,j)) 's_win.mat'])
              %remove outlier
              for i=1:length(RRdistanceAS)
                  if RRdistanceAS{1,i}

                  all_idx = 1:length(RRdistanceAS{1,i});
                  outlier_idx = abs(RRdistanceAS{1,i} - median(RRdistanceAS{1,i})) > 5*std(RRdistanceAS{1,i}); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
                  RRdistanceAS{1,i}(outlier_idx) = interp1(all_idx(~outlier_idx), RRdistanceAS{1,i}(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
                  end
              end
               for i=1:length(RRdistanceQS)
                  if RRdistanceQS{1,i}

                  all_idx = 1:length(RRdistanceQS{1,i});
                  outlier_idx = abs(RRdistanceQS{1,i} - median(RRdistanceQS{1,i})) > 5*std(RRdistanceQS{1,i}); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
                  RRdistanceQS{1,i}(outlier_idx) = interp1(all_idx(~outlier_idx), RRdistanceQS{1,i}(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
                  end
               end


              %calculate STD
               for i=1:length(RRdistanceAS)
                     SDNNAS{Neonate,i}=nanstd(RRdistanceAS{1,i});
                  end

               for i=1:length(RRdistanceQS)
                     SDNNQS{Neonate,i}=nanstd(RRdistanceQS{1,i});
               end
        end

        if saving
            folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks\';
            %saving R peaks positions in mat file
            save([folder 'SDNN_' num2str(win(1,j)) 's_win.mat'],'SDNNAS','SDNNQS');
        end

    end
end
%% SDANN
cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab')
pat=[3,4,5,6,7,9,10,13,15];
pat=3
saving=1;
win=[30,60,120,180,240,300]; %window in seconds
for j=1:length(win)
    for k=1:length(pat)
        Neonate=pat(k);


    %checking if file exist
        cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks')
        if exist(fullfile(cd, ['RRdistance' num2str(Neonate) ' _ ' num2str(win(1,j)) 's_win.mat']), 'file') == 2 % ==> 0 or 2
          load(['C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks\RRdistance' num2str(Neonate) ' _ ' num2str(win(1,j)) 's_win.mat'])
              %remove outlier
              for i=1:length(RRdistanceAS)
                  if RRdistanceAS{1,i}
                  all_idx = 1:length(RRdistanceAS{1,i});
                  outlier_idx = abs(RRdistanceAS{1,i} - median(RRdistanceAS{1,i})) > 5*std(RRdistanceAS{1,i}); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
                  RRdistanceAS{1,i}(outlier_idx) = interp1(all_idx(~outlier_idx), RRdistanceAS{1,i}(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
                  meanRRdistanceAS(1,i)=mean(RRdistanceAS{1,i});
                  end
              end
               for i=1:length(RRdistanceQS)
                  if RRdistanceQS{1,i}
                  all_idx = 1:length(RRdistanceQS{1,i});
                  outlier_idx = abs(RRdistanceQS{1,i} - median(RRdistanceQS{1,i})) > 5*std(RRdistanceQS{1,i}); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
                  RRdistanceQS{1,i}(outlier_idx) = interp1(all_idx(~outlier_idx), RRdistanceQS{1,i}(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
                  meanRRdistanceQS(1,i)=mean(RRdistanceQS{1,i});
                  end
               end


              %calculate STD
               for i=1:length(RRdistanceAS)
                     SDANNAS(Neonate)=nanstd(meanRRdistanceAS);
                  end

               for i=1:length(RRdistanceQS)
                     SDANNQS(Neonate)=nanstd(meanRRdistanceQS);
               end
        end

        if saving
            folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks\';
            %saving R peaks positions in mat file
            save([folder 'SDANN_' num2str(win(1,j)) 's_win.mat'],'SDANNAS','SDANNQS');
        end

    end
end
%% RMSSD
% ouput is the RMSSD, which is the sqrt(MSE) of the 5 minute epochs of the NN
% intervales. 
cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab')
pat=[3,4,5,6,7,9,10,13,15];
%pat=3
saving=1;
win=[30,60,120,180,240,300]; %window in seconds
for j=1:length(win)
    for k=1:length(pat)
        Neonate=pat(k);


    %checking if file exist
        cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks')
        if exist(fullfile(cd, ['RRdistance' num2str(Neonate) ' _ ' num2str(win(1,j)) 's_win.mat']), 'file') == 2 % ==> 0 or 2
          load(['C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks\RRdistance' num2str(Neonate) ' _ ' num2str(win(1,j)) 's_win.mat'])
              %remove outlier
              for i=1:length(RRdistanceAS)
                  if RRdistanceAS{1,i}
                  all_idx = 1:length(RRdistanceAS{1,i});
                  outlier_idx = abs(RRdistanceAS{1,i} - median(RRdistanceAS{1,i})) > 5*std(RRdistanceAS{1,i}); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
                  RRdistanceAS{1,i}(outlier_idx) = interp1(all_idx(~outlier_idx), RRdistanceAS{1,i}(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
                  RRdistanceAS{1,i}(2,:)=circshift(RRdistanceAS{1,i}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                  [PSNR,MSEAS{Neonate,i},MAXERR,L2RAT] = measerr(RRdistanceAS{1,i}(1),RRdistanceAS{1,i}(2)); %Calculating MSE
                  RMSSD_AS=cellfun(@sqrt,MSEAS, 'Un', false); %sqare root over the MSE of the adjacent NN intervals creates the RMSSD

                  end
              end
               for i=1:length(RRdistanceQS)
                  if RRdistanceQS{1,i}
                  all_idx = 1:length(RRdistanceQS{1,i});
                  outlier_idx = abs(RRdistanceQS{1,i} - median(RRdistanceQS{1,i})) > 5*std(RRdistanceQS{1,i}); %| abs(y - median(y)) > 3*std(y) % Find outlier idx
                  RRdistanceQS{1,i}(outlier_idx) = interp1(all_idx(~outlier_idx), RRdistanceQS{1,i}(~outlier_idx), all_idx(outlier_idx)); % Linearly interpolate over outlier idx for x
                  RRdistanceQS{1,i}(2,:)=circshift(RRdistanceQS{1,i}',[1 0]);   %shifting the array to gain a Y and a Y+1(estimated) with wich we can determine the MSE
                  [PSNR,MSEQS{Neonate,i},MAXERR,L2RAT] = measerr(RRdistanceQS{1,i}(1),RRdistanceQS{1,i}(2)); %Calculating MSE
                  RMSSD_QS=cellfun(@sqrt,MSEQS, 'Un', false);


                  end
               end
               
               if saving
            folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\windowed_ECG_chunks\';
            %saving R peaks positions in mat file
            save([folder 'RMSSD' num2str(win(1,j)) 's_win.mat'],'RMSSD_AS','RMSSD_QS');
        end               
               
        end
    end
end
