function plotSignals(inputData,peakPositionArray,waveletOutputArray,thresHoldValueArray,ratioArray,startOfSegmentArray,endOfSegmentArray,Fs,waveletArray)
    h(1) = subplot(4,1,1);
            plot((1:length(inputData'))/Fs,inputData(:,:)');
            title('ECG signal');
            ylabel('Amplitude');
            xlabel('Time [s]');
            limits = [min(inputData) max(inputData)];
            hold on;
            stem((peakPositionArray')/Fs, 2*limits(2)*(ones(size(peakPositionArray))'),'r');
            if limits(1) < 0
                stem((peakPositionArray')/Fs, 2*limits(1)*(ones(size(peakPositionArray))'),'r');
            end
            ylim(limits);
            xlim([0 size(inputData,2)/Fs]);
            hold off;
             
        h(2) = subplot(4,1,2);
            plot((1:length(waveletOutputArray'))/Fs,waveletOutputArray');
            title('Wavelet Analysis output + Threshold');
            ylabel('Amplitude');
            xlabel('Time [s]');
            hold on
            YposArray = NaN(1,length(thresHoldValueArray)*3);
            YposArray(2:3:end-1) = thresHoldValueArray;
            YposArray(3:3:end) = thresHoldValueArray;
            XposArray = NaN(1,length(YposArray));
            XposArray(2:3:end-1) = startOfSegmentArray(1:1:end);
            XposArray(3:3:end) = endOfSegmentArray(1:1:end);
            plot(XposArray/Fs,YposArray,'r');

            xlim([0 size(inputData,2)/Fs]);
            hold off
        
         h(3) = subplot(4,1,3);
            scaling = 4/max(waveletOutputArray(1,:));
            plot((1:length(waveletOutputArray'))/Fs, 2+scaling*waveletOutputArray');
            title('Wavelet Analysis output + SNR indicator');
            ylabel('Amplitude');
            xlabel('Time [s]');
            hold on
            if ~isnan(ratioArray)
                YposArray = NaN(1,length(ratioArray)*3);
                YposArray(2:3:end-1) = ratioArray;
                YposArray(3:3:end) = ratioArray;
                XposArray = NaN(1,length(YposArray));
                XposArray(2:3:end-1) = startOfSegmentArray(1:end);
                XposArray(3:3:end) = endOfSegmentArray(1:end);
                plot(XposArray/Fs,YposArray,'r');
            end
            ylim([2 6]);
            xlim([0 size(inputData,2)/Fs]);
        h(4) = subplot(4,1,4);
            scaling = 2*(limits(2)-limits(1));
            offset  = -(limits(1) + scaling/4);
            plot((1:length(inputData'))/Fs,(inputData(:,:)' + offset) * (1/scaling));
            title('ECG signal');
            ylabel('Amplitude');
            xlabel('Time [s]');
            if ~isnan(waveletArray)
                hold on
                for i = 1:size(waveletArray,2)
                    plot((startOfSegmentArray(i) + ((endOfSegmentArray(i)-startOfSegmentArray(i))/2) + (1:size(waveletArray,1)))/Fs,waveletArray(end:-1:1,i),'r');
                end
                hold off
            end
        linkaxes(h,'x');
end