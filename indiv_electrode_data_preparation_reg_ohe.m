%{

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   Restructuring Data   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

indiv_elect_feat_set_folder = fullfile(compiled_data_path, 'FeatureSets', times_folder);
load(fullfile(indiv_elect_feat_set_folder, 'feature_set_table'), 'all_subs_feat_table');

sub_nums = all_subs_feat_table.sub_num;
class_label_cell = {'word_name', 'consonants_name', 'vowel_name'};

all_subs_indiv_elect_feat_table = table();

for sub_idx = 1:length(sub_nums)
    sub_num = sub_nums(sub_idx);
    sub_str = strcat('S', string(sub_num));
    
    sub_feat_class_table = table(sub_num, 'VariableNames', {'sub_num'});
    
    for class_label_idx = 1:length(class_label_cell)
        class_label = class_label_cell{class_label_idx};

        stim_feat_class = all_subs_feat_table.(class_label).stim_feat{sub_idx};
        stim_feat = stim_feat_class.stim_feat;
        stim_e_w_ids = stim_feat.Properties.VariableNames;

        class_labels = stim_feat_class.class_labels;
        class_labels_ohe = stim_feat_class.class_labels_ohe;

        stim_e_ids = zeros([1,length(stim_e_w_ids)]);
        for stim_e_w_idx = 1:length(stim_e_w_ids)
            [stim_e, ~] = electrode_window_parser(stim_e_w_ids{stim_e_w_idx});
            stim_e_ids(stim_e_w_idx) = stim_e;
        end

        stim_e_ids_unique = unique(stim_e_ids);
        stim_indiv_elect_table = table();
        for stim_e_id = stim_e_ids_unique
            stim_e_feat = stim_feat(:,stim_e_ids == stim_e_id);
            stim_e_feat = table(stim_e_feat, class_labels, class_labels_ohe,...
                'VariableNames', {'stim_feat', 'class_labels', 'class_labels_ohe'}); 

            stim_ind_e_table_temp = table(stim_e_id, {stim_e_feat}, 'VariableNames', {'stim_e_id','stim_feat_class'});
            stim_indiv_elect_table = [stim_indiv_elect_table; stim_ind_e_table_temp];
        end

        onset_feat_class = all_subs_feat_table.(class_label).onset_feat{sub_idx};
        onset_feat = onset_feat_class.onset_feat;
        onset_e_w_ids = onset_feat.Properties.VariableNames;

        class_labels = onset_feat_class.class_labels;
        class_labels_ohe = onset_feat_class.class_labels_ohe;

        onset_e_ids = zeros([1,length(onset_e_w_ids)]);
        for onset_e_w_idx = 1:length(onset_e_w_ids)
            [onset_e, ~] = electrode_window_parser(onset_e_w_ids{onset_e_w_idx});
            onset_e_ids(onset_e_w_idx) = onset_e;
        end

        onset_e_ids_unique = unique(onset_e_ids);
        onset_indiv_elect_table = table();
        for onset_e_id = onset_e_ids_unique
            onset_e_feat = onset_feat(:,onset_e_ids == onset_e_id);
            onset_e_feat = table(onset_e_feat, class_labels, class_labels_ohe,...
                'VariableNames', {'onset_feat', 'class_labels', 'class_labels_ohe'}); 

            onset_ind_e_table_temp = table(onset_e_id, {onset_e_feat}, 'VariableNames', {'onset_e_id','onset_feat_class'});
            onset_indiv_elect_table = [onset_indiv_elect_table; onset_ind_e_table_temp];
        end

        sub_feat_table_temp = table({stim_indiv_elect_table}, {onset_indiv_elect_table},...
            'VariableNames', {'stim_feat', 'onset_feat'});
        sub_feat_class_table_temp = table(sub_feat_table_temp, 'VariableNames', {class_label});
        sub_feat_class_table = [sub_feat_class_table, sub_feat_class_table_temp];
        
    end
    
    all_subs_indiv_elect_feat_table = [all_subs_indiv_elect_feat_table; sub_feat_class_table];
end

indiv_elect_feat_set_folder = fullfile(compiled_data_path, 'FeatureSets', times_folder);
mkdir(indiv_elect_feat_set_folder);
save(fullfile(indiv_elect_feat_set_folder, 'indiv_elect_feature_set_table'), 'all_subs_indiv_elect_feat_table', '-v7.3');
