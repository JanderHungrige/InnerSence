% TODO:
% 1 Look at the polarity of the detected peak compared to previous 
%   peaks to determine if the detected peak is the real one.
% 2 When amplitude of the peak detected greatly deviated from that of
%   previous peaks, this might be because it is a ventricular beat.
%   (also a bigger HRV than average and mor LF components)
%
% ? Add search in signal within x samples of peak in wavelet analysis 
%   to find real peak.


function [peakPosition thresholdValue] = rpeakdetection(waveletOutput, prevThresholdValue, ratio, minThresholdValue, RR_MIN)
%RPEAKDETECTION returns an array of detected R-peaks within the given data
%   RPEAKDETECTION returns exactly one peak for location, relative to the
%   start of the given segment, for each electrode lead if the
%   determination of the peak position was succesfull. In this case the
%   boolean 'succes' is set to true. The latest thresholds for each lead
%   are returned by 'thresholdValue'.
%
%   - succes        : bool
%   - peakPosition  : integer
%   - thresholdValue: integer
        
    [thresholdValue] = determinethresholdvalue(waveletOutput, prevThresholdValue, ratio, minThresholdValue);
    [peakPosition] = determinepeakposition(waveletOutput, thresholdValue, RR_MIN);
end
    
    
function [thresholdValue] = determinethresholdvalue(inputData, prevThresholdValue, ratio, minThresholdValue)
%DETERMINETHRESHOLDVALUE Determines an adaptive threshold value.
%   The returned threshold value is determined based on the current maximum
%   value as well as the previous threshold value.
%
%   - thresholdValue: integer

    ALPHA = 1/3; % Mixing weigth (0.33)
    
    thresholdValue = (ratio * max(abs(inputData))) * ALPHA...
                       +  prevThresholdValue * (1 - ALPHA);
    thresholdValue = max(thresholdValue, minThresholdValue);
end  


function [peakPosition] = determinepeakposition(inputData, thresholdValue, RR_MIN)
    maxSearch       = length(inputData) - RR_MIN;
    peakPosition    = nan;
    startOfSearch   = round(RR_MIN / 2);
    
    % Calculate sample dependent threshold
    idx             = 1:length(inputData);
    
    % Determine indices of samples crossing the threshold 
    pastThreshold   = idx(abs(inputData) > ones(size(idx))*thresholdValue);
    searchSpace     = pastThreshold(pastThreshold > startOfSearch);
    
    % Determine peak positions in searchSpace
    diffInputData   = inputData(2:end) - inputData(1:end-1);
    peakSearchSpace = searchSpace( sign(diffInputData(searchSpace)) ~= sign(diffInputData(searchSpace+1)) );
    
    for i = peakSearchSpace
        % local maximum, hence possible peak location
        % Set max distance from first peak for search
        if i > maxSearch
            break;
        else
            if isnan(peakPosition)
                % Only peaks within MAX_DIFF from first peak detection
                % are considdered
                maxSearch = i + RR_MIN;
                peakPosition = i;
            elseif abs(inputData(i)) > abs(inputData(peakPosition) * (9 / 8));
                peakPosition = i;
            end
        end
    end
end
