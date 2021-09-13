function indiv_electrode_LDA(params_struct)

% data_path = params_struct.data_path;
% mlpath = params_struct.mlpath;
mRMR_path = params_struct.mRMR_path;
times_folder = params_struct.times_folder;
% mRMR_results = params_struct.mRMR_results;
% consolidated_mRMR_results = params_struct.consolidated_mRMR_results;
event_duration = params_struct.event_duration;
window = params_struct.window;
stride = params_struct.stride;
class_label = params_struct.class_label;
topN_feat = params_struct.topN_feat;
indiv_elect_feat_struct = params_struct.indiv_elect_feat_struct;
% ohe_flag = params_struct.ohe_flag;
% mRMR_feat_fig_flag = params_struct.mRMR_feat_fig_flag;
% cluster_hist_plot_flag = params_struct.clust_hist_plot_flag;

subjects_list = fieldnames(indiv_elect_feat_struct);
indiv_elect_LDA_struct = struct();

for sub_idx = 1:length(subjects_list)
    sub_str = subjects_list{sub_idx};
    
    %%%% Stim
    stim_indiv_data = indiv_elect_feat_struct.(sub_str).stim_indiv_elect_table;
    
    stim_model_cell = cell([height(stim_indiv_data), 1]);
    stim_accuracy_cell = zeros([height(stim_indiv_data), 1]);
    stim_cluster_cell = cell([height(stim_indiv_data), 1]);
    stim_roi_cell = cell([height(stim_indiv_data), 1]);
    stim_true_vs_pred_cell = cell([height(stim_indiv_data), 1]);
    stim_conf_mtx_cell = cell([height(stim_indiv_data), 1]);
    
    for e_idx = 1:height(stim_indiv_data)
        e_id = stim_indiv_data.stim_e_id(e_idx);
        
        stim_topN_feat_idx = stim_indiv_data.stim_feat_idx{e_idx};
        stim_topN_feat_idx = stim_topN_feat_idx(1:topN_feat);
        stim_feat = stim_indiv_data.feat_class{e_idx};
        
        X_stim = stim_feat(:,stim_topN_feat_idx);
        y_stim = stim_feat.(class_label);
        
        rng(1);
        cvp_stim = cvpartition(height(X_stim), 'KFold', 5);
        cv_mdl_stim = fitcdiscr(X_stim, y_stim, 'DiscrimType', 'linear', 'ScoreTransform', 'logit', 'CVPartition', cvp_stim);

        y_pred_stim = kfoldPredict(cv_mdl_stim);
        
        acc_stim = mean(strcmp(y_stim, y_pred_stim));
        acc_stim_perc = 100 * acc_stim; 
        
        stim_model_cell{e_idx} = cv_mdl_stim;
        stim_accuracy_cell(e_idx) = acc_stim_perc;
        stim_cluster_cell{e_idx} = get_cluster_name(sub_str, e_id, 'stim');
        stim_roi_cell{e_idx} = get_ROI_name(sub_str, e_id, 'stim');
        stim_true_vs_pred_cell{e_idx} = [y_stim, y_pred_stim];
        stim_conf_mtx_cell{e_idx} = confusionmat(y_stim, y_pred_stim);
    end
    stim_cluster_cell(cellfun(@(cell) any(isempty(cell(:))),stim_cluster_cell))={'NaN'};    
    stim_table_temp = table(stim_model_cell, stim_accuracy_cell, stim_cluster_cell, stim_roi_cell, stim_true_vs_pred_cell, stim_conf_mtx_cell,...
        'VariableNames', {'stim_model','stim_accuracy','stim_cluster', 'stim_roi', 'stim_true_vs_pred', 'stim_conf_mtx'});
    stim_indiv_data = [stim_indiv_data, stim_table_temp];
    
    %%%% Onset    
        onset_indiv_data = indiv_elect_feat_struct.(sub_str).onset_indiv_elect_table;
    
    onset_model_cell = cell([height(onset_indiv_data), 1]);
    onset_accuracy_cell = zeros([height(onset_indiv_data), 1]);
    onset_cluster_cell = cell([height(onset_indiv_data), 1]);
    onset_roi_cell = cell([height(onset_indiv_data), 1]);
    onset_true_vs_pred_cell = cell([height(onset_indiv_data), 1]);
    onset_conf_mtx_cell = cell([height(onset_indiv_data), 1]);
    
    for e_idx = 1:height(onset_indiv_data)
        e_id = onset_indiv_data.onset_e_id(e_idx);
        
        onset_topN_feat_idx = onset_indiv_data.onset_feat_idx{e_idx};
        onset_topN_feat_idx = onset_topN_feat_idx(1:topN_feat);
        onset_feat = onset_indiv_data.feat_class{e_idx};
        
        X_onset = onset_feat(:,onset_topN_feat_idx);
        y_onset = onset_feat.(class_label);
        
        rng(1);
        cvp_onset = cvpartition(height(X_onset), 'KFold', 5);
        cv_mdl_onset = fitcdiscr(X_onset, y_onset, 'DiscrimType', 'linear', 'ScoreTransform', 'logit', 'CVPartition', cvp_onset);

        y_pred_onset = kfoldPredict(cv_mdl_onset);
        
        acc_onset = mean(strcmp(y_onset, y_pred_onset));
        acc_onset_perc = 100 * acc_onset; 
        
        onset_model_cell{e_idx} = cv_mdl_onset;
        onset_accuracy_cell(e_idx) = acc_onset_perc;
        onset_cluster_cell{e_idx} = get_cluster_name(sub_str, e_id, 'onset');
        onset_roi_cell{e_idx} = get_ROI_name(sub_str, e_id, 'onset');
        onset_true_vs_pred_cell{e_idx} = [y_onset, y_pred_onset];
        onset_conf_mtx_cell{e_idx} = confusionmat(y_onset, y_pred_onset);
    end
    onset_cluster_cell(cellfun(@(cell) any(isempty(cell(:))),onset_cluster_cell))={'NaN'};    
    onset_table_temp = table(onset_model_cell, onset_accuracy_cell, onset_cluster_cell, onset_roi_cell, onset_true_vs_pred_cell, onset_conf_mtx_cell,...
        'VariableNames', {'onset_model','onset_accuracy','onset_cluster', 'onset_roi', 'onset_true_vs_pred', 'onset_conf_mtx'});
    onset_indiv_data = [onset_indiv_data, onset_table_temp];  
    
    indiv_elect_LDA_struct.(sub_str).stim_indiv_elect_table = stim_indiv_data;
    indiv_elect_LDA_struct.(sub_str).onset_indiv_elect_table = onset_indiv_data;    
end

stim_temp_table = table();
onset_temp_table = table();
for sub_idx = 1:length(subjects_list)
    sub_str = subjects_list{sub_idx};
    sub_num = strsplit(sub_str, 'S');
    sub_num = str2double(sub_num{2});
    
    stim_sub_temp_table = indiv_elect_LDA_struct.(sub_str).stim_indiv_elect_table;
    stim_sub_num_col = table(repmat(sub_num, height(stim_sub_temp_table), 1), 'VariableNames', {'sub_num'});
    stim_sub_temp_table = [stim_sub_num_col, stim_sub_temp_table];
    stim_temp_table = [stim_temp_table; stim_sub_temp_table];
    
    onset_sub_temp_table = indiv_elect_LDA_struct.(sub_str).onset_indiv_elect_table;
    onset_sub_num_col = table(repmat(sub_num, height(onset_sub_temp_table), 1), 'VariableNames', {'sub_num'});
    onset_sub_temp_table = [onset_sub_num_col, onset_sub_temp_table];
    onset_temp_table = [onset_temp_table; onset_sub_temp_table];
end

all_subs_indiv_elect_LDA_table = table({stim_temp_table}, {onset_temp_table}, 'VariableNames', {'stim_all_subs', 'onset_all_subs'});

mkdir(fullfile(mRMR_path, times_folder, class_label));

indiv_elect_LDA_res_file = sprintf('e%s_w%s_s%s_indiv_elect_LDA', string(event_duration), string(window), string(stride));
indiv_elect_LDA_res_filename_full = fullfile(mRMR_path, times_folder, class_label, indiv_elect_LDA_res_file);
save(indiv_elect_LDA_res_filename_full, 'indiv_elect_LDA_struct', 'all_subs_indiv_elect_LDA_table', '-v7.3');

end









