function [s,ECG_raw]=loading_ecg(path, Neonate,sheet,lead,FS)
% path is the path of the external HDD. CAn change anytime
% load([path ':\InnerSence\Data files\All files\Baby' num2str(Neonate) '\sfull']); %Full set
load(['C:\Users\310122653\Documents\PhD\Article_2_(EHV)\Raw_Data\Data files\All files\Baby' num2str(Neonate) '\sfull']);

ECG_raw=s.Data{1,lead};
sec=length(s.Data{1,lead})/FS; %duration of ecg in s
disp([' Duration of ECG in sec: '  int2str(sec) ' s' ])
end