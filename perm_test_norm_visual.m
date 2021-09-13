%%%% significant electrodes only, one-vs-rest labels

title_size = 28;
subtitle_size = 22; 
label_size = 24; 
legend_size = 18; 
tick_size = 18; 

z_thresh = icdf('normal', (1 - p_value), 0, 1);

stim_baag_auc_perm = stim_all_nodes_all_iters.BAAG;
stim_baag_zscores = zscore(stim_baag_auc_perm);

stim_sig_e_baag_zscores = stim_baag_zscores(stim_baag_zscores >= z_thresh);
stim_sig_e_baag_auc_perm = stim_baag_auc_perm(stim_baag_zscores >= z_thresh);


stim_baag_perm_fig = figure('FileName', 'stim_baag_perm_auc_left.png');
stim_baag_perm_fig.WindowState = 'maximized';

sgtitle({'Distribution of AUC, Z-scores of Classifiers Trained on', 'Randomized Individual Electrode Stimulus Data', 'Class Label: BAAG'}, 'FontSize', title_size);
subplot(1,2,2);
zscore_hist = gca;
hold on;
stim_baag_perm_hist = histogram(stim_baag_zscores);
stim_sig_e_baag_perm_hist = histogram(stim_sig_e_baag_zscores,...
    'BinWidth', stim_baag_perm_hist.BinWidth,...
    'BinEdges', stim_baag_perm_hist.BinEdges);
z_xline = xline(z_thresh, '--k', 'LineWidth', 2);
ylim([0 6000]);

zscore_hist.FontSize = label_size;
title('Z-Score Distribution of Random AUC Data', 'FontSize', title_size);
xlabel('Z-Score', 'FontSize', label_size);
ylabel('Count', 'FontSize', label_size);
legend([stim_baag_perm_hist, stim_sig_e_baag_perm_hist, z_xline], {'BAAG Z Distribution', sprintf('p = %3.2f region', p_value), sprintf('Threshold = %3.2f', z_thresh)}, 'Location', 'northwest', 'FontSize', legend_size);
hold off; 

subplot(1,2,1);
auc_hist = gca; 
hold on;
stim_baag_auc_hist = histogram(stim_baag_auc_perm);
% stim_sig_e_baag_auc_hist = histogram(stim_sig_e_baag_auc_perm,...
%     'BinWidth', stim_baag_auc_hist.BinWidth,...
%     'BinEdges', stim_baag_auc_hist.BinEdges);
% auc_xline = xline(min(stim_sig_e_baag_auc_perm), '--k', 'LineWidth', 2);
xlim([0 1]);
ylim([0 6000]);

auc_hist.FontSize = label_size;
title('Random AUC Distribution', 'FontSize', title_size);
xlabel('AUC', 'FontSize', label_size);
ylabel('Count', 'FontSize', label_size);
% legend([stim_baag_auc_hist, stim_sig_e_baag_auc_hist], {'BAAG AUC Distribution', sprintf('p = %3.2f region', p_value), 'Threshold'}, 'Location', 'northwest', 'FontSize', legend_size);
legend([stim_baag_auc_hist], {'BAAG AUC Distribution'}, 'Location', 'northwest', 'FontSize', legend_size);
hold off; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stim_baag_real_auc_data = sub_stim_e_id_auc_all_labels.BAAG; 
stim_sig_e_baag_real_auc_data = threshd_auc_data.stim_sig_data{1}.mean_auc;

stim_baag_perm_with_real_fig = figure('FileName', 'stim_baag_perm_with_real_data.png'); 
stim_baag_perm_with_real_fig.WindowState = 'maximized';
sgtitle(sprintf('Comparing AUC Distributions for Real Data vs.\nRandomized Individual Electrode Stimulus Data\nClass Label: BAAG. %s', plainformat(times_folder)), 'FontSize', title_size);

subplot(1,2,1);
auc_hist3 = gca; 
hold on;
stim_baag_auc_hist3 = histogram(stim_baag_auc_perm);

stim_sig_e_baag_auc_hist3 = histogram(stim_sig_e_baag_auc_perm,...
    'BinWidth', stim_baag_auc_hist3.BinWidth,...
    'BinEdges', stim_baag_auc_hist3.BinEdges);
auc_xline = xline(min(stim_sig_e_baag_auc_perm), '--k', 'LineWidth', 2);
xlim([0 1]);

auc_hist3.FontSize = label_size;
title('Randomized Data', 'FontSize', title_size);
xlabel('AUC', 'FontSize', label_size);
ylabel('Count', 'FontSize', label_size);
legend([stim_baag_auc_hist3, stim_sig_e_baag_auc_hist3, auc_xline], {'BAAG AUC Distribution', sprintf('p = %3.2f region', p_value), sprintf('Threshold = %3.2f', threshold_table{'stim', 'BAAG'})}, 'Location', 'northwest', 'FontSize', legend_size);
hold off; 


subplot(1,2,2);
hold on;
stim_baag_real_auc_hist3 = histogram(stim_baag_real_auc_data);

stim_sig_e_baag_real_auc_hist3 = histogram(stim_sig_e_baag_real_auc_data,...
    'BinWidth', stim_baag_real_auc_hist3.BinWidth,...
    'BinEdges', stim_baag_real_auc_hist3.BinEdges);

auc_xline = xline(min(stim_sig_e_baag_auc_perm), '--k', 'LineWidth', 2);
xlim([0 1]);
% ylim([0 6000]);

auc_hist_real = gca; 
auc_hist_real.FontSize = label_size;
title('Real Data', 'FontSize', title_size);
xlabel('AUC', 'FontSize', label_size);
ylabel('Count', 'FontSize', label_size);
% legend([stim_baag_auc_hist3, stim_sig_e_baag_auc_hist3, stim_baag_real_auc_hist3, stim_sig_e_baag_real_auc_hist3, auc_xline], {'BAAG AUC Distribution', sprintf('p = %3.2f region', p_value), 'Threshold'}, 'Location', 'northwest', 'FontSize', legend_size);
legend([stim_baag_real_auc_hist3, stim_sig_e_baag_real_auc_hist3, auc_xline], {'BAAG AUC Distribution', sprintf('p = %3.2f region', p_value), sprintf('Threshold = %3.2f', threshold_table{'stim', 'BAAG'})}, 'Location', 'northwest', 'FontSize', legend_size);
hold off; 


exportgraphics(stim_baag_perm_fig, fullfile(figures_path, stim_baag_perm_fig.FileName))
exportgraphics(stim_baag_perm_with_real_fig, fullfile(figures_path, stim_baag_perm_with_real_fig.FileName))



