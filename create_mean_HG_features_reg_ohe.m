% Creates features (mean HG trace over window duration) for Feature Selection / ML / Classification Models

%{
Creates features for Feature Selection / ML / Classification Models. 
Pass:
a struct from MLCompiledData, must have form of valid_data_sub.
an event duration (ms), which will orient the event in a timespan to
    be used with the windowing procedure following. 
a window duration (ms) (for calculating mean HG over a window) 
a stride (ms) (amount of window overlap). 
a class_label (string) to specify a classification label for the table
    [one hot encoding option available; splits features/classes into
    separate tables, see format below.]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   Returns a table for each alignment case,   %%%%%
%%%%%   containing mean HG values across windows   %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   Stim/Onset Table:   %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

|          (stim/onset)_features       | | class_labels | |class_labels_ohe
|______________________________________| |______________| |________________
| Electr 1 | Electr 1 | ... | Electr N | |   {'BAAG'}   | | 1 | 0 | 0 |...
| Window 1 | Window 2 | ... | Window n | |    
|   E1W1   |   E1W2   | ... |   ENWn   | |   {'BEEG'}   | | 0 | 1 | 0 |...
___________________________________________________________________________

Dependencies:
extract_cluster_electrodes.m
shorten_multiple_epoch.m
MLData_Consolidation.m (and its associated dependencies)

%}

function [stim_feat_table, onset_feat_table] = create_mean_HG_features_reg_ohe(valid_data_sub, params_struct)

event_duration = params_struct.event_duration;
window = params_struct.window;
stride = params_struct.stride;
class_label = params_struct.class_label;

[stim_extract, onset_extract] = extract_cluster_electrodes(valid_data_sub);

stim_ex_red = shorten_multiple_epoch(stim_extract, 'stim', event_duration);
onset_ex_red = shorten_multiple_epoch(onset_extract, 'onset', event_duration);

sample_freq = size(valid_data_sub.epoched_stim_data.data, 2) / 3;
window_samples = sample_freq * (window / 1000); 
stride_samples = sample_freq * (stride / 1000); 

for trial = 1:size(stim_ex_red,3)
    stim_movmean(:,:,trial) = movmean(stim_ex_red(:,:,trial), window_samples, 2, 'Endpoints', 'discard');
    onset_movmean(:,:,trial) = movmean(onset_ex_red(:,:,trial), window_samples, 2, 'Endpoints', 'discard');
end

stride_num = 1:stride_samples:size(stim_movmean, 2); 
stim_movmean_stride = stim_movmean(:,stride_num,:);
onset_movmean_stride = onset_movmean(:,stride_num,:);

stim_electrode_ids = valid_data_sub.electrodes_stim.electrode;
onset_electrode_ids = valid_data_sub.electrodes_onset.electrode;

if strcmp(class_label, 'consonants_name') || strcmp(class_label, 'vowel_name')
    class_labels_per_trial = valid_data_sub.filelist_row(:,{class_label});
    class_labels_per_trial = cellstr(class_labels_per_trial.(class_label));
    class_labels_per_trial = table(class_labels_per_trial, 'VariableNames', {class_label});
else
    class_labels_per_trial = valid_data_sub.filelist_row(:,{class_label});
end

stim_feat_table = table();
for trial_idx = 1:size(stim_movmean_stride, 3)
    stim_feat_table_temp = table();
    for electrode_idx = 1:size(stim_movmean_stride, 1)
        for window_idx = 1:size(stim_movmean_stride, 2)
            feat_label_temp = sprintf('e%sw%s',string(stim_electrode_ids(electrode_idx)), string(window_idx));
            stim_feat_table_temp.(feat_label_temp) = stim_movmean_stride(electrode_idx, window_idx, trial_idx); 
        end
    end
    stim_feat_table = [stim_feat_table; stim_feat_table_temp];
end

onset_feat_table = table();
for trial_idx = 1:size(onset_movmean_stride, 3)
    onset_feat_table_temp = table();
    for electrode_idx = 1:size(onset_movmean_stride, 1)
        for window_idx = 1:size(onset_movmean_stride, 2)
            feat_label_temp = sprintf('e%sw%s',string(onset_electrode_ids(electrode_idx)), string(window_idx));
            onset_feat_table_temp.(feat_label_temp) = onset_movmean_stride(electrode_idx, window_idx, trial_idx); 
        end
    end
    onset_feat_table = [onset_feat_table; onset_feat_table_temp];
end

class_labels_ohe = class_labels_per_trial;
class_labels_ohe.(class_label) = categorical(class_labels_ohe.(class_label));
class_labels_ohe = onehotencode(class_labels_ohe);

stim_feat_table = table(stim_feat_table, class_labels_per_trial, class_labels_ohe,...
    'VariableNames', {'stim_feat', 'class_labels', 'class_labels_ohe'});
onset_feat_table = table(onset_feat_table, class_labels_per_trial, class_labels_ohe,...
    'VariableNames', {'onset_feat', 'class_labels', 'class_labels_ohe'});
end




