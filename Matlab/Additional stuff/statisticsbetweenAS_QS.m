function  [medianAS_300,medianQS_300,InterQrang_AS_300,InterQrang_QS_300,AS_60,QS_60,AS_150,QS_150,AS_300,QS_300]=statisticsbetweenAS_QS(Neonate,win,Loadfolder,AS_60,QS_60,AS_150,QS_150,AS_300,QS_300)

%%features_dict={
%                1:"Bpe",
%                2:"NN10",                  
%                3:"NN20",                
%                4:"NN30",                 
%                5:"NN50",                  
%                6:"pNN10",               
%                7:"pNN20",               
%                8:"pNN30",               
%                9:"pNN50",              
%                10:"RMSSD",                 
%                11:"SDNN",                 
%                 12:"HF",                 
%                 13:"HFnorm",
%                 14:"LF",                  
%                 15:"LFnorm",               
%                 16:"ratioLFHF",           
%                 17:"sHF",
%                 18:"totpower",
%                 19:"uHF",
%                 20:"VLF",
%               }     
%%
% [1 2 3 4 5 6 10 11 13 17 18 19 20]
disp('Calculating inter quartile range')

    for j=1:length(win)
        Neonate;
        disp(['working on window: ' num2str(win(1,j))]);

%         folderF=dir([Loadfolder 'Feature_Matrix_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']);
    Features=cell2mat(struct2cell(load([Loadfolder 'Feature_Matrix_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']))) ;
    load([Loadfolder 'Annotation_Matrix_ASQS_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']) 

  %  Separating AS and QS 
    if win(1,j)==60
      AS_60=[AS_60 Features(:,Matrix==1)];
      QS_60=[QS_60 Features(:,Matrix==2)];
    elseif win(1,j)==150
      AS_150=[AS_150 Features(:,Matrix==1)];
      QS_150=[QS_150 Features(:,Matrix==2)];
    elseif win(1,j)==300
      AS_300=[AS_300 Features(:,Matrix==1)];
      QS_300=[QS_300 Features(:,Matrix==2)];
    end
    
%       meanAS_60=mean(AS_60,2);  
%       meanQS_60=mean(QS_60,2);
%       meanAS_150=mean(AS_60,2);  
%       meanQS_150=mean(QS_60,2);
      meanAS_300=mean(AS_60,2);  
      meanQS_300=mean(QS_60,2);  
      
      sortiertesAS=sort(AS_300,2);
      sortiertesQS=sort(QS_300,2); 
      medianAS_300=median(AS_300,2);  
      medianQS_300=median(QS_300,2); 
      
%       InterQrang_AS_60=iqr(AS_60,2);
%       InterQrang_QS_60=iqr(QS_60,2);
%       InterQrang_AS_150=iqr(AS_150,2);
%       InterQrang_QS_150=iqr(QS_150,2);
      InterQrang_AS_300=iqr(AS_300,2);
      InterQrang_QS_300=iqr(QS_300,2);

      
      percentile25_AS_60= prctile(AS_60,25,2);
      percentile25_QS_60= prctile(QS_60,25,2);
      percentile25_AS_150= prctile(AS_150,25,2);
      percentile25_QS_150= prctile(QS_150,25,2);
      percentile25_AS_300= prctile(AS_300,25,2);
      percentile25_QS_300= prctile(QS_300,25,2);
      
      percentile75_AS_60= prctile(AS_60,75,2);
      percentile75_QS_60= prctile(QS_60,75,2);
      percentile75_AS_150= prctile(AS_150,75,2);
      percentile75_QS_150= prctile(QS_150,75,2);
      percentile75_AS_300= prctile(AS_300,75,2);
      percentile75_QS_300= prctile(QS_300,75,2)   ;
      
      sortiertesAS=sort(AS_300,2);
      sortiertesQS=sort(QS_300,2); 
      medianAS_300=median(AS_300,2);  
      medianQS_300=median(QS_300,2); 
      
      
    sortiertesAS=sort(AS_300,2);
    sortiertesQS=sort(QS_300,2); 
    quanrttileAS=quantile(sortiertesAS,[0.25 0.75],2)
    quanrttileQS=quantile(sortiertesQS,[0.25 0.75],2)

    quanrttileAS = quantile(sortiertesAS,0.25,2);
    quanrttileQS = quantile(sortiertesQS,0.25,2)  ;
if Neonate==15
    a
end

    end

end
