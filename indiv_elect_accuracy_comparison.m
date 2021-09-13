function indiv_elect_topN_accuracies = indiv_elect_accuracy_comparison(params_struct)

% data_path = params_struct.data_path;
% mlpath = params_struct.mlpath;
mRMR_path = params_struct.mRMR_path;
times_folder = params_struct.times_folder;

event_duration = params_struct.event_duration;
window = params_struct.window;
stride = params_struct.stride;
class_label = params_struct.class_label;
% topN_feat = params_struct.topN_feat;
topN_indiv_e = params_struct.topN_indiv_e;

% mRMR_results = params_struct.mRMR_results;
% consolidated_mRMR_results = params_struct.consolidated_mRMR_results;
% indiv_elect_feat_struct = params_struct.indiv_elect_feat_struct;
indiv_elect_LDA_struct = params_struct.indiv_elect_LDA_struct;
% all_subs_indiv_elect_LDA_table = params_struct.all_subs_indiv_elect_LDA_table;

% ohe_flag = params_struct.ohe_flag;
% mRMR_feat_fig_flag = params_struct.mRMR_feat_fig_flag;
% cluster_hist_plot_flag = params_struct.clust_hist_plot_flag;
% all_elect_conf_mtx_flag = params_struct.all_elect_conf_mtx_flag;

subjects_list = fieldnames(indiv_elect_LDA_struct);
indiv_elect_topN_accuracies = struct();
for sub_idx = 1:length(subjects_list)
    sub_str = subjects_list{sub_idx};
    fprintf('Subject: %s\n', sub_str)
    
    stim_topN_accuracies = indiv_elect_LDA_struct.(sub_str).stim_indiv_elect_table;
    stim_topN_accuracies = sortrows(stim_topN_accuracies, 'stim_accuracy', 'descend');
    stim_topN_accuracies = stim_topN_accuracies(1:topN_indiv_e, :)
    
    onset_topN_accuracies = indiv_elect_LDA_struct.(sub_str).onset_indiv_elect_table;
    onset_topN_accuracies = sortrows(onset_topN_accuracies, 'onset_accuracy', 'descend');
    onset_topN_accuracies = onset_topN_accuracies(1:topN_indiv_e, :)
    
    indiv_elect_topN_accuracies.(sub_str).stim_topN_accuracies = stim_topN_accuracies;
    indiv_elect_topN_accuracies.(sub_str).onset_topN_accuracies = onset_topN_accuracies;
    
end

indiv_elect_topN_accuracies_file = sprintf('e%s_w%s_s%s_indiv_elect_topN_accuracies', string(event_duration), string(window), string(stride));
indiv_elect_topN_accuracies_filename_full = fullfile(mRMR_path, times_folder, class_label, indiv_elect_topN_accuracies_file);
save(indiv_elect_topN_accuracies_filename_full, 'indiv_elect_topN_accuracies', '-v7.3');

end