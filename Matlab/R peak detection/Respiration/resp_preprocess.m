function ret = resp_preprocess(resp, sample_rate, settings)
 
%%% Subsampling settings  
% settings.RESP_RESAMPLE = 1;            % enable subsampling, needed to for the Ehv data set
% settings.RESP_TARGET_SAMPLE_RATE = 10; % same sampling rate as for the Boston data set


%%% Parameters respiratory features
%%%
% settings.RESP_BASELINE_WINLEN = 4;   % Preprocessing parameters (given in seconds)
% settings.RESP_BASELINE_MOVAVR_LEN = 120;

% settings.THR_SEGM = Inf;         % Pedro: data_array_all_resp_aw.mat used Inf..., code received from Sandrine had 3.8. Used Inf to replicate results
% settings.THR_SEGM_RESP = 0;      % if set to zero, only use criterion based on arc length applied to filtered-out resp signal
% settings.MIN_LENGTH_CLEAN = 20;  % in seconds, minimal length of clean intervals allowed
% settings.MARGIN_NOISE = 4;
% settings.RESP_RESEGMENT = 0;     % Resegment respiratory effort signal according to the amount of abnormal peaks?
% 
% settings.WINDOW_MEDIAN_AMP = 30; % nr of peak-to-trough and trough-to-peak amplitudes taken into account to estimate local median amplitude
% 
% settings.THR_AMPLITUDE = 0.07;
% 
% settings.THR_AMP_PEAKS = 0.05;
% settings.THR_AMP_TROUGHS = 0.05;
% settings.THR_AMPLITUDE_2 = 0.15;
% settings.QUANTILE_THR = 0.5;
 
%% Baseline subtraction
resp = resp - nanmean(resp);

%% Preprocess respiratory effort signal (see Redmond et al. 2007)

% Low-pass filtered with 10th order Butterworth filter with cut-off 0.6Hz

% REMOVED BY JAN
% [b_LP, a_LP] = butter(10,0.1 ./(sample_rate/2));   % instead of 0.8
%   
% resp = filtfilt(b_LP, a_LP, resp);
% 
% [b_HP, a_HP] = butter(3, 0.001 ./(sample_rate/2),'high');  
% resp = filtfilt(b_HP, a_HP, resp);
% REMOVED BY JAN 

%% Estimate and subtract baseline from the prefiltered respiratory effort signal

baseline = medfilt1(resp,settings.RESP_BASELINE_WINLEN*sample_rate); %% Redmond et al 2006
baseline = medfilt1(baseline,settings.RESP_BASELINE_WINLEN*sample_rate);

% Apply additional moving average in order to make baseline robust against
% motion-artifacts and to remove remaining short time oscillations
baseline = filtfilt(ones(1,settings.RESP_BASELINE_MOVAVR_LEN*sample_rate)/(settings.RESP_BASELINE_MOVAVR_LEN*sample_rate),1, baseline);

resp = resp - baseline;
resp_original = resp - mean(resp);
resp = 1000*(resp - mean(resp))/std(resp);

% log_fine(['Mean value of respiratory signal after baseline removal : ' num2str(mean(resp))]);

%% Find artifacts (i.e. segment signal in clean and noisy chunks) 

% Scale amplitude of resp signal
%resp_artifacts = resp_effort.raw_signal - mean(resp_effort.raw_signal);
resp_artifacts = resp - mean(resp);
resp_artifacts = round((resp_artifacts - min(resp_artifacts)) * 1000 / (max(resp_artifacts) - min(resp_artifacts)));

% Filter the respiratory information out (i.e. enhance artifacts)
[b_BP, a_BP] = butter(20,[2 4.6]./(sample_rate/2));
resp_artifacts = filtfilt(b_BP, a_BP, resp_artifacts);

% Detect artifacts by means of arc length
w = 2*sample_rate;  % half length (in samples) of the interval where the arc length is computed
segmentation_tag = ones(1,length(resp_artifacts));
f = sqrt(1+diff(resp_artifacts).^2);  
arc_length = zeros(1,length(resp_artifacts));
sm_arc_length = zeros(1,length(resp_artifacts));
for i = w+1:length(resp_artifacts)-w-1
    arc_length(i) = sum(f(i-w:i+w));
end
% Enhance artifacts 
sm_arc_length(w+1:length(resp)-w) = medfilt1(arc_length(w+1:length(resp)-w),2*sample_rate);

% Apply the same criterion to the resp signal directly
f_resp = sqrt(1+diff(resp).^2);
arc_length_resp = zeros(1,length(resp));
sm_arc_length_resp = zeros(1,length(resp));
for i = w+1:length(resp)-w-1
    arc_length_resp(i) = sum(f_resp(i-w:i+w));
end
% Enhance artifacts 
sm_arc_length_resp(w+1:length(resp)-w) = medfilt1(arc_length_resp(w+1:length(resp)-w),2*sample_rate);

% Apply thresholding on auxiliary signals
idx_artifacts = find(sm_arc_length > settings.THR_SEGM * median(sm_arc_length));
idx_artifacts_resp = find(sm_arc_length_resp > settings.THR_SEGM_RESP * median(sm_arc_length_resp));
for ii = 1:length(idx_artifacts)
    if ~isempty(find(idx_artifacts_resp == idx_artifacts(ii),1))
        segmentation_tag(idx_artifacts(ii)) = 0;
    end
end
% Why these two steps? resp_artifacts allows to filter out in the arc
% length curve the baseline component, that may vary a lot and impairs the
% thresholding. However, when a small artifact occurs (with the frequency
% but not with the amplitude), it will create a peak in the arc length,
% which should not be necessarily eliminated. Hence, the test with the arc
% length derived from the resp signal
segmentation_tag(1:w) = 0;                % eliminate first ...
segmentation_tag(length(resp)-w:end) = 0; % ... and last 2s intervals

% Smooth segmentation tag
diff_segmentation_tag = diff(segmentation_tag);
for i = 1:length(diff_segmentation_tag)
    if diff_segmentation_tag(i) == -1       % transition from clean to noisy
        segmentation_tag(max(1,i-settings.MARGIN_NOISE*sample_rate):i) = 0;
    elseif diff_segmentation_tag(i) == 1    % transition from noisy to clean
        idx = find(diff_segmentation_tag(i:min(length(resp_artifacts)-1,i+(settings.MIN_LENGTH_CLEAN+2*settings.MARGIN_NOISE)*sample_rate)) == -1,1);
        if ~isempty(idx)   % clean interval smaller than settings.MIN_LENGTH_CLEAN seconds is set to noise
            segmentation_tag(i:idx+i-1) = 0;
        else
            segmentation_tag(i:min(length(resp_artifacts),i+settings.MARGIN_NOISE*sample_rate)) = 0;
        end
    end
end


%% Normalize respiratory effort signal for each subject to consider only relative differences

% First detect turning points and build pairs (peaks-to-troughs)
% --------------------------------------------------------------
search_for_a_peak = 1;
turning_point.index = [];
turning_point.extremum = [];
for k = 2:length(resp)-1
    if find(segmentation_tag(k-1:k+1) == 0)  % if there is at least one element disregarded, continue
        search_for_a_peak = 1;  % start from the beginning (start with a peak)
        if ~isempty(turning_point.extremum) && turning_point.extremum(end) == 1  % found one more peak
            turning_point.extremum = turning_point.extremum(1:end-1);  % suppress it, because not associated with a trough
            turning_point.index = turning_point.index(1:end-1);  
        end
        continue
    end
    if resp(k+1)-resp(k) < 0 && resp(k)-resp(k-1) > 0 % there is a local maximum
        turning_point.index(end+1) = k;
        if ~isempty(turning_point.extremum)
            if turning_point.extremum(end) == 1
                log_warning('Two consecutive maxima');
            else
                turning_point.extremum(end+1) = 1;  % max
            end
        else
            turning_point.extremum(end+1) = 1;  % Add first max
        end      
        search_for_a_peak = 0;
    elseif resp(k+1)-resp(k) > 0 && resp(k)-resp(k-1) < 0 % there is a local minimum
        if search_for_a_peak == 1 
            continue;  % search first for a maximum
        else
            turning_point.index(end+1) = k;
            if ~isempty(turning_point.extremum)
                if turning_point.extremum(end) == -1
                    log_warning('Two consecutive minima');
                else
                    turning_point.extremum(end+1) = -1;  % min
                end
            else
                turning_point.extremum(end+1) = -1;  % Add first min
            end
        end
    end
end


% Detect artifacts in peak-to-trough amplitudes
% ---------------------------------------------

% Store the original detected peaks and troughs
original_turning_point = turning_point;

% 1. Detect pairs with clearly too small amplitude
 
amp = abs(diff(resp(original_turning_point.index)));
% Take peak_to_trough amplitude as we are sure there is no gap in
% between (because of the design of the series turning_point)
median_amp = median(amp(find(diff(original_turning_point.extremum) == -2)));
% log_fine(['Median amplitude before artifact removal : ' num2str(median_amp)]); 

k = 1;
eliminated_indexes = [];  % store the indexes of the elements in the original_turning_point vector that are eliminated 

plot_local_threshold_amp.value = [];
plot_local_threshold_amp.sample = []; 

while k < length(turning_point.index)-2
    
    idx_amp_1 = max(1,k-settings.WINDOW_MEDIAN_AMP);
    idx_amp_2 = min(length(turning_point.index)-1,k+settings.WINDOW_MEDIAN_AMP);
    local_median_amp = median(abs(diff(resp(turning_point.index(idx_amp_1:idx_amp_2)))));
    plot_local_threshold_amp.value(end+1) = max(settings.THR_AMPLITUDE * local_median_amp , 25);
    plot_local_threshold_amp.sample(end+1) = turning_point.index(k);
    
    % Look at consecutive triplets of peak-to-trough or trough-to-peak amplitudes 
    if segmentation_tag(turning_point.index(k):turning_point.index(k+3)) == 1  % without gap due to segmentation
        amp_aux = abs(diff(resp(turning_point.index(k:k+3))));
        amp_aux_after_thr = amp_aux > max(settings.THR_AMPLITUDE * local_median_amp , 25);   % 1 for valid, 0 for not valid amplitudes
        if amp_aux_after_thr == [1; 0; 1]  % suppress intermediate peak and trough
            eliminated_indexes = [eliminated_indexes ...
                                  find(original_turning_point.index == turning_point.index(k+1)) ...
                                  find(original_turning_point.index == turning_point.index(k+2))];
            turning_point.index(k+2) = [];
            turning_point.index(k+1) = [];
            turning_point.extremum(k+2) = [];
            turning_point.extremum(k+1) = [];
        elseif amp_aux_after_thr == [0; 0; 1]
            if turning_point.extremum(k) == -1   % min
                condition = resp(turning_point.index(k)) > resp(turning_point.index(k+2));
            else  % max
                condition = resp(turning_point.index(k)) < resp(turning_point.index(k+2));
            end
            if condition 
                eliminated_indexes = [eliminated_indexes ...
                                      find(original_turning_point.index == turning_point.index(k)) ...
                                      find(original_turning_point.index == turning_point.index(k+1))];
                turning_point.index(k+1) = [];
                turning_point.index(k) = [];
                turning_point.extremum(k+1) = [];
                turning_point.extremum(k) = []; 
            else
                eliminated_indexes = [eliminated_indexes ...
                                      find(original_turning_point.index == turning_point.index(k+1)) ...
                                      find(original_turning_point.index == turning_point.index(k+2))];
                turning_point.index(k+2) = [];
                turning_point.index(k+1) = [];
                turning_point.extremum(k+2) = [];
                turning_point.extremum(k+1) = [];
            end
        elseif amp_aux_after_thr == [1; 0; 0]
            if turning_point.extremum(k) == -1   % min
                condition = resp(turning_point.index(k+1)) < resp(turning_point.index(k+3)); 
            else  % max
                condition = resp(turning_point.index(k+1)) > resp(turning_point.index(k+3)); 
            end
            if condition 
                eliminated_indexes = [eliminated_indexes ...
                                      find(original_turning_point.index == turning_point.index(k+1)) ...
                                      find(original_turning_point.index == turning_point.index(k+2))];
                turning_point.index(k+2) = [];
                turning_point.index(k+1) = []; 
                turning_point.extremum(k+2) = [];
                turning_point.extremum(k+1) = [];
            else
                eliminated_indexes = [eliminated_indexes ...
                                      find(original_turning_point.index == turning_point.index(k+2)) ...
                                      find(original_turning_point.index == turning_point.index(k+3))];
                if length(turning_point.index) >= k+3
                    turning_point.index(k+3) = [];
                end
                if length(turning_point.index) >= k+2
                    turning_point.index(k+2) = [];
                end
                if length(turning_point.extremum) >= k+3
                    turning_point.extremum(k+3) = [];
                end
                if length(turning_point.extremum) >= k+2
                    turning_point.extremum(k+2) = [];
                end
            end
        else
            k = k+1;
        end
    else
        k = k+1;
    end       
end

old_segmentation_tag = segmentation_tag;


% Adapt segmentation tag if too many consecutive artifacts were detected (e.g.
% that could be an indication of a break in respiratory signal)
if settings.RESP_RESEGMENT

    v = diff(eliminated_indexes);
    idx = find(v == 1);  % finds consecutive turning points that were eliminated
    ll = 1;
    while ll < length(idx)-3
        if v(idx(ll):idx(ll)+4) == [1 1 1 1 1]  % sequence of three consecutive corrections or more detected  
            % for 2 corrections, [1 1 1] compute left and right boundaries for disregarding signal
            k_left_segm = eliminated_indexes(idx(ll)) - 1;   % find the last index before the sequence starts
            k_right_segm = eliminated_indexes(find(v(idx(ll):end) ~= 1,1)+idx(ll)-1) + 1;  % find the first index after the sequence ends
            log_info(['At least 3 consecutive corrections --> adapt segmentation tag at sample: ' num2str(original_turning_point.index(k_left_segm))]);
            if original_turning_point.extremum(k_left_segm) == -1 % min
                segmentation_tag(original_turning_point.index(k_left_segm)+1:original_turning_point.index(k_right_segm)-1) = 0;
                if original_turning_point.extremum(k_right_segm) ~= 1
                    log_error(['After segmentation, start with a min as turning point at sample ' num2str(original_turning_point.extremum(k_right_segm))]);
                end
                % Smooth segmentation tag
                if segmentation_tag(original_turning_point.index(k_left_segm)) == 1
                    last_idx_disregarded = find(segmentation_tag(original_turning_point.index(k_left_segm)-settings.MIN_LENGTH_CLEAN*sample_rate:original_turning_point.index(k_left_segm)) == 0, 1, 'last');
                    if ~isempty(last_idx_disregarded)
                        segmentation_tag(last_idx_disregarded+original_turning_point.index(k_left_segm)-settings.MIN_LENGTH_CLEAN*sample_rate-1:original_turning_point.index(k_left_segm)) = 0;
                    end
                end
                if segmentation_tag(original_turning_point.index(k_right_segm)) == 1
                    first_idx_disregarded = find(segmentation_tag(original_turning_point.index(k_right_segm):original_turning_point.index(k_right_segm)+settings.MIN_LENGTH_CLEAN*sample_rate) == 0, 1, 'first');
                    if ~isempty(first_idx_disregarded)
                        segmentation_tag(original_turning_point.index(k_right_segm):original_turning_point.index(k_right_segm)+first_idx_disregarded-1) = 0;
                    end
                end
            elseif original_turning_point.extremum(k_left_segm) == +1 % max
                segmentation_tag(original_turning_point.index(k_left_segm)-1:original_turning_point.index(k_right_segm)+1) = 0;   % to keep design: every max is followed by a valid min without gap
                if original_turning_point.extremum(k_right_segm+1) ~= 1
                    log_error(['After segmentation, start with a min as turning point at sample ' num2str(original_turning_point.extremum(k_right_segm+1))]);
                end
                % Smooth segmentation tag
                if segmentation_tag(original_turning_point.index(k_left_segm)-2) == 1
                    last_idx_disregarded = find(segmentation_tag(original_turning_point.index(k_left_segm)-2-settings.MIN_LENGTH_CLEAN*sample_rate:original_turning_point.index(k_left_segm)-2) == 0, 1, 'last');
                    if ~isempty(last_idx_disregarded)
                        segmentation_tag(last_idx_disregarded+original_turning_point.index(k_left_segm)-2-settings.MIN_LENGTH_CLEAN*sample_rate-1:original_turning_point.index(k_left_segm)-2) = 0;
                    end
                end
                if segmentation_tag(original_turning_point.index(k_right_segm)+2) == 1
                    first_idx_disregarded = find(segmentation_tag(original_turning_point.index(k_right_segm)+2:original_turning_point.index(k_right_segm)+2+settings.MIN_LENGTH_CLEAN*sample_rate) == 0, 1, 'first');
                    if ~isempty(first_idx_disregarded)
                        segmentation_tag(original_turning_point.index(k_right_segm)+2:original_turning_point.index(k_right_segm)+2+first_idx_disregarded-1) = 0;
                    end
                end
            end
            ll = ll+4;  % could be optimized by a precise jump (can be computed)
        else % add case with nr corrections = 2 and a distance between > 5 seconds
            ll = ll+1;
        end
    end

    % Update the turning point series to the newly adjusted segmentation_tag
    for jj = 1:length(turning_point.index)
        if segmentation_tag(turning_point.index(jj)) == 0
            turning_point.index(jj) = -1;
        end
    end
    idx_valid = find(turning_point.index > 0);
    idx_valid(idx_valid>numel(turning_point.extremum))=[];
    turning_point.index = turning_point.index(idx_valid);
    turning_point.extremum = turning_point.extremum(idx_valid);
end


% 3. Apply the median criterion for troughs (i.e. breath length) that are dubious 

% Compute breath length series and median 
breath_length.int = [];
breath_length.time = [];
breath_length.idx_in_turning_point_series = [];
for l = 2:2:length(turning_point.index)-2  % from troughs to troughs
    if segmentation_tag(turning_point.index(l):turning_point.index(l+2)) == 1
        breath_length.int(end+1) = (turning_point.index(l+2)-turning_point.index(l)) / sample_rate;
        breath_length.time(end+1) = (turning_point.index(l)-1) / sample_rate;
        breath_length.idx_in_turning_point_series(end+1) = l;
    end
end
median_breath_length = median(breath_length.int);
q_breath_length = quantile(breath_length.int,settings.QUANTILE_THR);
% log_fine(['Median breath length interval : ' num2str(median_breath_length)]);
% log_fine(['Quantile breath length interval : ' num2str(q_breath_length)]);

% Look at spurious breath cycles (compared to median), mark spurious cycles
% by negating their respective index
final_turning_point = turning_point;

last_breath_length = median_breath_length;
for n = 2:length(breath_length.int)
    current_breath_length = breath_length.int(n);
    if (abs((last_breath_length + current_breath_length) - q_breath_length) < abs(current_breath_length - q_breath_length)) || ...
       (abs((last_breath_length + current_breath_length) - q_breath_length) < abs(last_breath_length - q_breath_length))
        if abs(resp(turning_point.index(breath_length.idx_in_turning_point_series(n)))-resp(turning_point.index(breath_length.idx_in_turning_point_series(n)-1))) < settings.THR_AMPLITUDE_2 * median_amp  
            % Remove one trough
            final_turning_point.index(breath_length.idx_in_turning_point_series(n)) = ...
                -final_turning_point.index(breath_length.idx_in_turning_point_series(n));
            % Remove the lowest peak
            if resp(turning_point.index(breath_length.idx_in_turning_point_series(n)-1)) > resp(turning_point.index(breath_length.idx_in_turning_point_series(n)+1));
                final_turning_point.index(breath_length.idx_in_turning_point_series(n)+1) = ...
                    -final_turning_point.index(breath_length.idx_in_turning_point_series(n)+1);
            else
                final_turning_point.index(breath_length.idx_in_turning_point_series(n)-1) = ...
                    -final_turning_point.index(breath_length.idx_in_turning_point_series(n)-1);
            end
            last_breath_length = last_breath_length + current_breath_length;
        elseif abs(resp(turning_point.index(breath_length.idx_in_turning_point_series(n)))-resp(turning_point.index(breath_length.idx_in_turning_point_series(n)+1))) < settings.THR_AMPLITUDE_2 * median_amp  
            % Remove one trough
            final_turning_point.index(breath_length.idx_in_turning_point_series(n)) = ...
                -final_turning_point.index(breath_length.idx_in_turning_point_series(n));
            % Remove the lowest peak
            if resp(turning_point.index(breath_length.idx_in_turning_point_series(n)-1)) > resp(turning_point.index(breath_length.idx_in_turning_point_series(n)+1));
                final_turning_point.index(breath_length.idx_in_turning_point_series(n)+1) = ...
                    -final_turning_point.index(breath_length.idx_in_turning_point_series(n)+1);
            else
                final_turning_point.index(breath_length.idx_in_turning_point_series(n)-1) = ...
                    -final_turning_point.index(breath_length.idx_in_turning_point_series(n)-1);
            end
            last_breath_length = last_breath_length + current_breath_length;
        else
            last_breath_length = current_breath_length;
        end
    else
        last_breath_length = current_breath_length;
    end
end

valid_idx = find(final_turning_point.index > 0);
valid_idx(valid_idx>numel(final_turning_point.extremum))=[];

% turning_point.index = final_turning_point.index(valid_idx);
% turning_point.extremum = final_turning_point.extremum(valid_idx);

% NOTE: Changed the final turning point series to still contain abnormal
% points in order to still be able to detect the amount of abnormal cycles
% outside of this function
turning_point = final_turning_point;

valid_turning_point.index = final_turning_point.index(valid_idx);
valid_turning_point.extremum = final_turning_point.extremum(valid_idx);


% Normalize signal with median peak-to-trough amplitude
% -----------------------------------------------------

amp = abs(diff(resp_original(turning_point.index(valid_idx))));
normalization_factor = median(amp(find(diff(turning_point.extremum(valid_idx)) == -2))); 

% log_fine(['Median amplitude after artifact removal : ' num2str(normalization_factor)]); 

% Divide by median peak-to-trough amplitude
resp_original = resp_original ./ normalization_factor;


%%


ret.resp = resp_original;
ret.sample_rate = sample_rate;
ret.segmentation_tag = segmentation_tag;
ret.turning_point = turning_point;
ret.valid_turning_point = valid_turning_point;
