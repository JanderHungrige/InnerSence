function [Distance]=RRdistance(Rpeak,ECGChunk)

% this function calculates the distance in seconds between the calculated
% RR peaks

 %input: Rpeak: calculated r peak position
 %      ECGChunk: Part of cell array with time and ECG data of specific
 %      window size

% output: values for cell structure of RR distance in seconds
   

    L=length(Rpeak);

    for i=2:L-1
        Distance(i-1)=ECGChunk(1,Rpeak(i+1))-ECGChunk(1,Rpeak(i));
    end

    

end