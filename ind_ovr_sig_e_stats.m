function t = ind_ovr_sig_e_stats(stim_data, onset_data)

p_val = 0.05;

z_thresh = icdf('normal', 1-p_val, 0, 1); 

%%%% IND STIM

ovr_labels = stim_data.Properties.VariableNames; 
ovr_labels(cellfun(@(x) strcmp(x, 'sub_num') || strcmp(x, 'stim_e_id') || strcmp(x, 'stim_cluster') || strcmp(x, 'stim_roi') , ovr_labels)) = [];

stim_pop_norm_min_auc_thresh = table();

figure();
sgtitle('STIM INDIVIDUAL, p=0.05 Significance');
for ovr_label_idx = 1:length(ovr_labels)
    ovr_label = ovr_labels{ovr_label_idx};
    sub_stim_sorted_mean_auc = sortrows(stim_data, ovr_label, 'ascend');
    sub_stim_ovr_label_mean_auc = sub_stim_sorted_mean_auc(:,{'sub_num', 'stim_e_id', 'stim_cluster', 'stim_roi', ovr_label});

    probs = sub_stim_ovr_label_mean_auc.(ovr_label); 
    z_scores = zscore(probs);
    
%     fprintf('Statistically significant (p value = %0.2f) electrodes \nfor classifying %s phoneme from Stimulus Data:\n\n', p_val, ovr_label);
    sig_e_data = sub_stim_ovr_label_mean_auc(z_scores >= z_thresh, :);
    stim_pop_norm_min_auc_thresh_temp = table(min(sig_e_data.(ovr_label)), 'VariableNames', {ovr_label});
    stim_pop_norm_min_auc_thresh = [stim_pop_norm_min_auc_thresh, stim_pop_norm_min_auc_thresh_temp];
    
    subplot(4, 5, ovr_label_idx); 
    histogram(sig_e_data.(ovr_label), 'EdgeAlpha', 0)
    xlim([0 1]);
    ylim([0 6500]);
    title(sprintf('%s Distribution of mean AUCs', ovr_label));
    
end

%%%% IND ONSET

ovr_labels = onset_data.Properties.VariableNames; 
ovr_labels(cellfun(@(x) strcmp(x, 'sub_num') || strcmp(x, 'onset_e_id') || strcmp(x, 'onset_cluster') || strcmp(x, 'onset_roi') , ovr_labels)) = [];

onset_pop_norm_min_auc_thresh = table();

figure();
sgtitle('ONSET INDIVIDUAL, p=0.05 Significance');
for ovr_label_idx = 1:length(ovr_labels)
    ovr_label = ovr_labels{ovr_label_idx};
    sub_onset_sorted_mean_auc = sortrows(onset_data, ovr_label, 'descend');
    sub_onset_ovr_label_mean_auc = sub_onset_sorted_mean_auc(:,{'sub_num', 'onset_e_id', 'onset_cluster', 'onset_roi', ovr_label});

    probs = sub_onset_ovr_label_mean_auc.(ovr_label); 
    z_scores = zscore(probs);
%     sig_inds = find(z_scores >= z_thresh);

%     fprintf('Statistically significant (p value = %0.2f) electrodes \nfor classifying %s phoneme from Onset Data:\n\n', p_val, ovr_label);    
    sig_e_data = sub_onset_ovr_label_mean_auc(z_scores >= z_thresh, :);
    onset_pop_norm_min_auc_thresh_temp = table(min(sig_e_data.(ovr_label)), 'VariableNames', {ovr_label});
    onset_pop_norm_min_auc_thresh = [onset_pop_norm_min_auc_thresh, onset_pop_norm_min_auc_thresh_temp];

    
    subplot(4, 5, ovr_label_idx); 
    histogram(sig_e_data.(ovr_label), 'EdgeAlpha', 0)
    xlim([0 1]);
    ylim([0 6500]);
    title(sprintf('%s Distribution of mean AUCs', ovr_label));
    
end

t = [stim_pop_norm_min_auc_thresh; onset_pop_norm_min_auc_thresh];
t.Properties.RowNames = {'stim', 'onset'};
end

