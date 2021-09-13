%{

Standalone script to create mean HG features.

%}

if ~exist('params_struct', 'var')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%    File Path to Data    %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    data_path = '/projectnb/busplab/Experiments/ECoG_fMRI_RS/Experiments/ECoG_Preprocessed_LJ/'; 
    ml_path = fullfile(data_path, 'MLAlgoData'); 
    mRMR_path = fullfile(data_path, 'MLResults/mRMR/');
    compiled_data_path = fullfile(data_path, 'MLCompiledData');
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%    Define Parameters    %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    event_duration = 2000;
    window = 50;
    stride = 25; 

    topN_feat = 150;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   Constructing Parameter Struct   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    times_folder = sprintf('e%s_w%s_s%s', string(event_duration), string(window), string(stride));
     
    params_struct = struct();
    params_struct.data_path = data_path; 
    params_struct.ml_path = ml_path;
    params_struct.compiled_data_path = compiled_data_path;
    params_struct.times_folder = times_folder;
    params_struct.event_duration = event_duration;
    params_struct.window = window;
    params_struct.stride = stride;
end

%%%%% Import Data

load(fullfile(compiled_data_path,'All/','valid_data.mat'));

class_labels = [{'word_name'}, {'consonants_name'}, {'vowel_name'}];
sub_nums = [357, 362, 369, 372, 376];

all_subs_feat_table = table();
for sub_num = sub_nums
    sub_str = strcat('S', num2str(sub_num));
    valid_data_sub = valid_data_all.(sub_str);

    sub_feat_label_table = table(sub_num, 'VariableNames', {'sub_num'});
    
    for class_label_idx = 1:length(class_labels)
        class_label = class_labels{class_label_idx};
        params_struct.class_label = class_label;

        [stim_feat, onset_feat] = create_mean_HG_features_reg_ohe(valid_data_sub, params_struct);
        
        sub_feat_table_temp = table({stim_feat}, {onset_feat}, 'VariableNames', {'stim_feat', 'onset_feat'});
        
        sub_feat_label_table_temp = table(sub_feat_table_temp, 'VariableNames', {class_label});
        
        sub_feat_label_table = [sub_feat_label_table, sub_feat_label_table_temp];

    end
    
    all_subs_feat_table = [all_subs_feat_table; sub_feat_label_table];
    
end

feat_set_folder = fullfile(compiled_data_path, 'FeatureSets', times_folder);
mkdir(feat_set_folder);
save(fullfile(feat_set_folder, 'feature_set_table'), 'all_subs_feat_table', '-v7.3');



