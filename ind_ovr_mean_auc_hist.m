function ind_ovr_mean_auc_hist(stim_data, onset_data)

%%%% IND STIM

ovr_labels = stim_data.Properties.VariableNames; 
ovr_labels(cellfun(@(x) strcmp(x, 'sub_num') || strcmp(x, 'stim_e_id') || strcmp(x, 'stim_cluster') || strcmp(x, 'stim_roi') , ovr_labels)) = [];

figure(); 
sgtitle('STIM INDIVIDUAL');
for ovr_label_idx = 1:length(ovr_labels)
    ovr_label = ovr_labels{ovr_label_idx};
    sub_stim_sorted_mean_auc = sortrows(stim_data, ovr_label, 'descend');

    probs = sub_stim_sorted_mean_auc.(ovr_label)(:); 
%     probs = sub_stim_sorted_mean_auc.(ovr_label)(sub_stim_sorted_mean_auc.stim_cluster == 'PtM-r'); 
    
    pd = fitdist(probs, 'Normal')

    subplot(4, 5, ovr_label_idx); 
    histogram(probs, 'EdgeAlpha', 0)
    xlim([0 1]);
    ylim([0 6500]);
    title(sprintf('%s Distribution of mean AUCs', ovr_label));
    
end

%%%% IND ONSET

ovr_labels = onset_data.Properties.VariableNames; 
ovr_labels(cellfun(@(x) strcmp(x, 'sub_num') || strcmp(x, 'onset_e_id') || strcmp(x, 'onset_cluster') || strcmp(x, 'onset_roi') , ovr_labels)) = [];

figure(); 
sgtitle('ONSET INDIVIDUAL');
for ovr_label_idx = 1:length(ovr_labels)
    ovr_label = ovr_labels{ovr_label_idx};
    sub_onset_sorted_mean_auc = sortrows(onset_data, ovr_label, 'descend');

    probs = sub_onset_sorted_mean_auc.(ovr_label)(:); 
%     probs = sub_onset_sorted_mean_auc.(ovr_label)(sub_onset_sorted_mean_auc.onset_cluster == 'PtM-r');     

    pd = fitdist(probs, 'Normal')

    subplot(4, 5, ovr_label_idx); 
    histogram(probs, 'EdgeAlpha', 0)
    xlim([0 1]);
    ylim([0 6500]);
    title(sprintf('%s Distribution of mean AUCs', ovr_label));
    
end
end

