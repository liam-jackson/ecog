function cv_mRMR_LDA_SCC_node(node_number)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%    File Path to Data    %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_path = '/projectnb/busplab/Experiments/ECoG_fMRI_RS/Experiments/ECoG_Preprocessed_LJ/'; 
mlpath = fullfile(data_path, 'MLAlgoData'); 
mRMR_path = fullfile(data_path, 'MLResults/mRMR/');
compiled_data_path = fullfile(data_path, 'MLCompiledData');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%    Define Parameters    %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
class_labels = [{'word_name'}, {'consonants_name'}, {'vowel_name'}];

event_duration = 700;
window = 50;
stride = 25; 

topN_feat = 50;
indiv_topN_feat = 10;
topN_indiv_e = 10;

times_folder = sprintf('e%s_w%s_s%s', string(event_duration), string(window), string(stride));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%  Create/Load Feature Set  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Now loading Feature sets for individual electrodes...\n');

indiv_elect_feat_set_folder = fullfile(compiled_data_path, 'FeatureSets', times_folder);
load(fullfile(indiv_elect_feat_set_folder, 'indiv_elect_feature_set_table'), 'all_subs_indiv_elect_feat_table');
fprintf('Done.\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   Constructing Parameter Struct   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params_struct = struct();
%%%% Pathes
params_struct.data_path = data_path; 
params_struct.mlpath = mlpath;
params_struct.mRMR_path = mRMR_path;
params_struct.times_folder = times_folder;

%%%% Times
params_struct.event_duration = event_duration;
params_struct.window = window;
params_struct.stride = stride;
params_struct.topN_feat = topN_feat;
params_struct.topN_indiv_e = topN_indiv_e;

%%%% Data
params_struct.all_subs_indiv_elect_feat_table = all_subs_indiv_elect_feat_table;

for nrepeat = 1:12   % iterate 12 times on each computer/node
  
rng(100 * node_number + nrepeat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   Begin the Training/Analysis   %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

all_class_sub_cv_mRMR_LDA_OvR_data = struct();

for class_label_idx = 1:length(class_labels)
    class_label = class_labels{class_label_idx};
    params_struct.class_label = class_label;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% indiv_elect_cv_mRMR_LDA_OvR.m
    fprintf('Data from individual electrodes, all subjects. One vs Rest\n\n');
    
    sub_indiv_elect_cv_mRMR_LDA_OvR_data_rand = indiv_electrode_cv_mRMR_LDA_OvR_rand(params_struct);
    
    all_class_sub_indiv_elect_cv_mRMR_LDA_OvR_data.(class_label) = sub_indiv_elect_cv_mRMR_LDA_OvR_data_rand;

end

ind_ovr_auc_compiled_rand.m

end

end