function MLData_Consolidation_final(params_struct)

% consolidates LocalProcessed data into easily navigable structures
%{
This consolidates data from LocalProcessed into easily navigable data
structures and saves them in a directory hierarchy similar to the other
data folders within ECoG_Preprocessed. 

Modify script_path to your preferred directory, which must contain:
AnalysisClass
match_trial_to_behavior.m

data_path must point to a filepath that contains the directories expected
to be in ECoG_Preprocessed/LocalProcessed. 

It must also contain: 
filelist_for_classification.xlsx
electrodes.mat
Target_Words.mat
stim_index_key.xlsx
%}

% Path to Scripts and Data
data_path = params_struct.data_path; 
ml_path = params_struct.ml_path; 

filelist = match_trial_to_behavior(params_struct);

load(fullfile(ml_path, 'electrodes.mat'));

raw_data_topdir = dir(fullfile(data_path, 'LocalProcessed'));
raw_data_topdir(~[raw_data_topdir.isdir]) = [];
raw_data_topdir(1:3) = [];      % removes '.','..', and S352

epoch_data_topdir = dir(fullfile(data_path, 'LocalEpoched'));
epoch_data_topdir(~[epoch_data_topdir.isdir]) = [];
epoch_data_topdir(1:3) = [];

valid_data_all = struct();

for sub_idx = 1:length(filelist.subject)
    valid_data_sub = struct();
    
    sub_num = filelist.subject(sub_idx);    % eg. 357 (integer)
    sub_str = strcat('S', string(sub_num)); % eg. "S357" (string)

    % Determine Relevant Electrodes & Associated Cluster 
    electrodes_sub_all = electrodes(electrodes.subject == sub_num, :);
    electrodes_sub_onset = electrodes_sub_all(electrodes_sub_all.type == 1, :);
    electrodes_sub_stim = electrodes_sub_all(electrodes_sub_all.type == 2, :);
        
    % Pull subject row from Andrew's table 
    filelist_table_row = filelist(filelist.subject == sub_num, :);
        
    % Gather raw data for subject
%     raw_data_subdir = dir(fullfile(raw_data_topdir(sub_idx).folder, raw_data_topdir(sub_idx).name, '*.mat'));
%     ecogall_sub = load(fullfile(raw_data_subdir(1).folder, 'ECoGALL.mat'));
%     ecogall_sub = ecogall_sub.ECoGALL;
%     ecogall_sub = ecogall_sub{1};
    
    % Gather epoched data for subject
    epoch_data_subdir = dir(fullfile(epoch_data_topdir(sub_idx).folder, epoch_data_topdir(sub_idx).name, '*.mat'));
    epoched_sub_onset = load(fullfile(epoch_data_subdir(1).folder, epoch_data_subdir(1).name));
    epoched_sub_stim = load(fullfile(epoch_data_subdir(2).folder, epoch_data_subdir(2).name));
    
    % Put subject data in a subject-specific struct
    valid_data_sub.subject_str = sub_str;
    valid_data_sub.subject_num = sub_num;
    valid_data_sub.filelist_row = filelist_table_row.trials{1};    
    valid_data_sub.electrodes_all = electrodes_sub_all;
    valid_data_sub.electrodes_onset = electrodes_sub_onset;
    valid_data_sub.electrodes_stim = electrodes_sub_stim;    
%     valid_data_sub.raw_data = ecogall_sub;
    valid_data_sub.epoched_onset_data = epoched_sub_onset.preprocessed_data;
    valid_data_sub.epoched_stim_data = epoched_sub_stim.preprocessed_data;    
       
    % Put subject struct into larger struct for storing all data
    valid_data_all.(sub_str) = valid_data_sub;
    
    % Filename for Saving Variables
    mkdir(fullfile(data_path, 'MLCompiledData', sub_str));
    filename = fullfile(data_path, 'MLCompiledData', sub_str, 'valid_data.mat');
    save(filename, 'valid_data_sub', '-v7.3');
    
end

mkdir(fullfile(data_path, 'MLCompiledData', 'All'));
filename_full = fullfile(data_path, 'MLCompiledData', 'All', 'valid_data.mat');
save(filename_full, 'valid_data_all', '-v7.3');

clearvars -except valid_data_all

end

