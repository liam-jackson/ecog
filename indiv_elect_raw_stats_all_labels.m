function all_labels_table = indiv_elect_raw_stats_all_labels(params_struct)

all_subs_indiv_elect_LDA_table = params_struct.all_subs_indiv_elect_LDA_table;

stim_temp = all_subs_indiv_elect_LDA_table.stim_all_subs{1}(:,{'sub_num', 'stim_e_id','stim_accuracy','stim_cluster', 'stim_roi', 'stim_true_vs_pred', 'stim_conf_mtx'});
onset_temp = all_subs_indiv_elect_LDA_table.onset_all_subs{1}(:,{'sub_num','onset_e_id','onset_accuracy','onset_cluster', 'onset_roi', 'onset_true_vs_pred', 'onset_conf_mtx'}); 
all_labels_temp = table({class_label}, {stim_temp}, {onset_temp}, 'VariableNames', {'class_label', 'stim_all_subs', 'onset_all_subs'});
all_labels_table = [all_labels_table; all_labels_temp];

end