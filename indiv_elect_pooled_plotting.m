function indiv_elect_pooled_plotting(params_struct)
data_path = params_struct.data_path;
mlpath = params_struct.mlpath;
mRMR_path = params_struct.mRMR_path;
times_folder = params_struct.times_folder;

event_duration = params_struct.event_duration;
window = params_struct.window;
stride = params_struct.stride;
class_label = params_struct.class_label;
topN_feat = params_struct.topN_feat;

mRMR_results = params_struct.mRMR_results;
consolidated_mRMR_results = params_struct.consolidated_mRMR_results;
indiv_elect_feat_struct = params_struct.indiv_elect_feat_struct;
indiv_elect_LDA_struct = params_struct.indiv_elect_LDA_struct;
all_subs_indiv_elect_LDA_table = params_struct.all_subs_indiv_elect_LDA_table;
indiv_elect_topN_accuracies = params_struct.indiv_elect_topN_accuracies;
all_labels_table = params_struct.all_labels_table;

ohe_flag = params_struct.ohe_flag;
mRMR_feat_fig_flag = params_struct.mRMR_feat_fig_flag;
cluster_hist_plot_flag = params_struct.clust_hist_plot_flag;
all_elect_conf_mtx_flag = params_struct.all_elect_conf_mtx_flag;

pooled_data = all_subs_indiv_elect_LDA_table;
stim_pooled_data = pooled_data.stim_all_subs{1};
onset_pooled_data = pooled_data.onset_all_subs{1};

stim_unique_clusters = unique(stim_pooled_data.stim_cluster);
onset_unique_clusters = unique(onset_pooled_data.onset_cluster);



















end