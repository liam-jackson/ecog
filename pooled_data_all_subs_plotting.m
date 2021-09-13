function pooled_data_all_subs_plotting(params_struct)
% data_path = params_struct.data_path;
% mlpath = params_struct.mlpath;
mRMR_path = params_struct.mRMR_path;
times_folder = params_struct.times_folder;

event_duration = params_struct.event_duration;
window = params_struct.window;
stride = params_struct.stride;
% class_label = params_struct.class_label;
% topN_feat = params_struct.topN_feat;
% topN_indiv_e = params_struct.topN_indiv_e;

% mRMR_results = params_struct.mRMR_results;
% consolidated_mRMR_results = params_struct.consolidated_mRMR_results;
% indiv_elect_feat_struct = params_struct.indiv_elect_feat_struct;
% indiv_elect_LDA_struct = params_struct.indiv_elect_LDA_struct;
% all_subs_indiv_elect_LDA_table = params_struct.all_subs_indiv_elect_LDA_table;
all_labels_table = params_struct.all_labels_table;

% ohe_flag = params_struct.ohe_flag;
% mRMR_feat_fig_flag = params_struct.mRMR_feat_fig_flag;
% cluster_hist_plot_flag = params_struct.clust_hist_plot_flag;
% all_elect_conf_mtx_flag = params_struct.all_elect_conf_mtx_flag;

stats_struct = struct();

sub_nums = unique(all_labels_table.stim_all_subs{1}.sub_num);

stim_cluster_names = unique(all_labels_table.stim_all_subs{1}.stim_cluster);
stim_cluster_cats = categorical(stim_cluster_names);
onset_cluster_names = unique(all_labels_table.onset_all_subs{1}.onset_cluster);
onset_cluster_cats = categorical(onset_cluster_names);

for sub_idx = 1:length(sub_nums)
    sub_num = sub_nums(sub_idx);
    sub_str = strcat('S', string(sub_num));

    stim_data_all = all_labels_table.stim_all_subs;
    
    stim_stats_all_classes_sub = table(stim_cluster_cats, 'VariableNames', {'stim_cluster'});
    for class_idx = 1:length(stim_data_all)
        class_label = all_labels_table.class_label{class_idx};
        stim_data_class_sub = stim_data_all{class_idx};
        stim_data_class_sub = stim_data_class_sub(stim_data_class_sub.sub_num == sub_num, :);
        stim_data_class_sub.stim_cluster = categorical(stim_data_class_sub.stim_cluster);
        
        stim_stats_sub = grpstats(stim_data_class_sub, {'stim_cluster'}, {'mean','meanci'},...
            'DataVars', 'stim_accuracy',...
            'VarNames', {'stim_cluster', 'GroupCount', strcat(class_label, '_mean_stim_accuracy'), strcat(class_label, '_meanci_stim_accuracy')});
        stim_stats_all_classes_sub = outerjoin(stim_stats_all_classes_sub, stim_stats_sub, 'MergeKeys', 1);
        stats_struct.(sub_str).stim_stats = stim_stats_all_classes_sub;
        
    end
    
    onset_data_all = all_labels_table.onset_all_subs;
    
    onset_stats_all_classes_sub = table(onset_cluster_cats, 'VariableNames', {'onset_cluster'});
    for class_idx = 1:length(onset_data_all)
        class_label = all_labels_table.class_label{class_idx};
        onset_data_class_sub = onset_data_all{class_idx};
        onset_data_class_sub = onset_data_class_sub(onset_data_class_sub.sub_num == sub_num, :);
        onset_data_class_sub.onset_cluster = categorical(onset_data_class_sub.onset_cluster);
        
        onset_stats_sub = grpstats(onset_data_class_sub, {'onset_cluster'}, {'mean','meanci'},...
            'DataVars', 'onset_accuracy',...
            'VarNames', {'onset_cluster', 'GroupCount', strcat(class_label, '_mean_onset_accuracy'), strcat(class_label, '_meanci_onset_accuracy')});
        onset_stats_all_classes_sub = outerjoin(onset_stats_all_classes_sub, onset_stats_sub, 'MergeKeys', 1);
        stats_struct.(sub_str).onset_stats = onset_stats_all_classes_sub;
        
    end
end

stim_stats_all_classes_all = table(stim_cluster_cats, 'VariableNames', {'stim_cluster'});
for class_idx = 1:length(stim_data_all)
    class_label = all_labels_table.class_label{class_idx};
    stim_data_class_all = stim_data_all{class_idx};
    stim_data_class_all.stim_cluster = categorical(stim_data_class_all.stim_cluster);
    stim_stats_all = grpstats(stim_data_class_all, {'stim_cluster'}, {'mean','meanci'},...
        'DataVars', 'stim_accuracy',...
        'VarNames', {'stim_cluster', 'GroupCount', strcat(class_label, '_mean_stim_accuracy'), strcat(class_label, '_meanci_stim_accuracy')});
    stim_stats_all_classes_all = outerjoin(stim_stats_all_classes_all, stim_stats_all, 'MergeKeys', 1);
    stats_struct.('All').stim_stats = stim_stats_all_classes_all;
end
onset_stats_all_classes_all = table(onset_cluster_cats, 'VariableNames', {'onset_cluster'});
for class_idx = 1:length(onset_data_all)
    class_label = all_labels_table.class_label{class_idx};
    onset_data_class_all = onset_data_all{class_idx};
    onset_data_class_all.onset_cluster = categorical(onset_data_class_all.onset_cluster);
    onset_stats_all = grpstats(onset_data_class_all, {'onset_cluster'}, {'mean','meanci'},...
        'DataVars', 'onset_accuracy',...
        'VarNames', {'onset_cluster', 'GroupCount', strcat(class_label, '_mean_onset_accuracy'), strcat(class_label, '_meanci_onset_accuracy')});
    onset_stats_all_classes_all = outerjoin(onset_stats_all_classes_all, onset_stats_all, 'MergeKeys', 1);
    stats_struct.('All').onset_stats = onset_stats_all_classes_all;
end


for sub_num_idx = 1:length(sub_nums)
    sub_num = sub_nums(sub_num_idx);
    sub_str = strcat('S', string(sub_num));

    sub_stim_stats_table = stats_struct.(sub_str).stim_stats;
    sub_stim_mean = [sub_stim_stats_table.word_name_mean_stim_accuracy, sub_stim_stats_table.consonants_name_mean_stim_accuracy, sub_stim_stats_table.vowel_name_mean_stim_accuracy];
    sub_stim_meanci_low = [sub_stim_stats_table.word_name_meanci_stim_accuracy(:,1), sub_stim_stats_table.consonants_name_meanci_stim_accuracy(:,1), sub_stim_stats_table.vowel_name_meanci_stim_accuracy(:,1)];
    sub_stim_meanci_high = [sub_stim_stats_table.word_name_meanci_stim_accuracy(:,2), sub_stim_stats_table.consonants_name_meanci_stim_accuracy(:,2), sub_stim_stats_table.vowel_name_meanci_stim_accuracy(:,2)];

    sub_stim_fig = figure();

    sub_stim_bar = bar(sub_stim_mean, 'grouped');
    hold on;
    [sub_stim_ngroups, sub_stim_nbars] = size(sub_stim_mean);
    sub_stim_err_x = nan(sub_stim_nbars, sub_stim_ngroups);
    for i = 1:sub_stim_nbars
        sub_stim_err_x(i,:) = sub_stim_bar(i).XEndPoints;
    end
    
    errorbar(sub_stim_err_x', sub_stim_mean, sub_stim_meanci_low, sub_stim_meanci_high, 'k', 'linestyle', 'none');
    title(sprintf('Mean Accuracies for LDA models \ntrained on %s electrodes \nfor Stimulus Data', sub_str));
    legend({'word', 'consonants', 'vowel', 'MeanCI'});
    set(gca, 'xticklabel', stim_cluster_cats);
    sub_stim_fig.Name = sprintf('Stim %s', sub_str);
    sub_stim_fig.NumberTitle = 'off';
    hold off;
    
    sub_onset_stats_table = stats_struct.(sub_str).onset_stats;
    sub_onset_mean = [sub_onset_stats_table.word_name_mean_onset_accuracy, sub_onset_stats_table.consonants_name_mean_onset_accuracy, sub_onset_stats_table.vowel_name_mean_onset_accuracy];
    sub_onset_meanci_low = [sub_onset_stats_table.word_name_meanci_onset_accuracy(:,1), sub_onset_stats_table.consonants_name_meanci_onset_accuracy(:,1), sub_onset_stats_table.vowel_name_meanci_onset_accuracy(:,1)];
    sub_onset_meanci_high = [sub_onset_stats_table.word_name_meanci_onset_accuracy(:,2), sub_onset_stats_table.consonants_name_meanci_onset_accuracy(:,2), sub_onset_stats_table.vowel_name_meanci_onset_accuracy(:,2)];

    sub_onset_fig = figure();

    sub_onset_bar = bar(sub_onset_mean, 'grouped');
    hold on;
    [sub_onset_ngroups, sub_onset_nbars] = size(sub_onset_mean);
    sub_onset_err_x = nan(sub_onset_nbars, sub_onset_ngroups);
    for i = 1:sub_onset_nbars
        sub_onset_err_x(i,:) = sub_onset_bar(i).XEndPoints;
    end
    
    errorbar(sub_onset_err_x', sub_onset_mean, sub_onset_meanci_low, sub_onset_meanci_high, 'k', 'linestyle', 'none');
    title(sprintf('Mean Accuracies for LDA models \ntrained on %s electrodes \nfor onsetulus Data', sub_str));
    legend({'word', 'consonants', 'vowel', 'MeanCI'});
    set(gca, 'xticklabel', onset_cluster_cats);
    sub_onset_fig.Name = sprintf('Onset %s', sub_str);
    sub_onset_fig.NumberTitle = 'off';
    hold off;    
    
end        
    
all_stim_stats_table = stats_struct.('All').stim_stats;
all_stim_mean = [all_stim_stats_table.word_name_mean_stim_accuracy, all_stim_stats_table.consonants_name_mean_stim_accuracy, all_stim_stats_table.vowel_name_mean_stim_accuracy];
all_stim_meanci_low = [all_stim_stats_table.word_name_meanci_stim_accuracy(:,1), all_stim_stats_table.consonants_name_meanci_stim_accuracy(:,1), all_stim_stats_table.vowel_name_meanci_stim_accuracy(:,1)];
all_stim_meanci_high = [all_stim_stats_table.word_name_meanci_stim_accuracy(:,2), all_stim_stats_table.consonants_name_meanci_stim_accuracy(:,2), all_stim_stats_table.vowel_name_meanci_stim_accuracy(:,2)];

all_stim_fig = figure();

all_stim_bar = bar(all_stim_mean, 'grouped');
hold on;
[all_stim_ngroups, all_stim_nbars] = size(all_stim_mean);

% Get the x coordinate of the bars
all_stim_err_x = nan(all_stim_nbars, all_stim_ngroups);
for i = 1:all_stim_nbars
    all_stim_err_x(i,:) = all_stim_bar(i).XEndPoints;
end

errorbar(all_stim_err_x', all_stim_mean, all_stim_meanci_low, all_stim_meanci_high, 'k', 'linestyle', 'none');
title(sprintf('Mean Accuracies for LDA models \ntrained on All electrodes \nfor Stimulus Data'));
legend({'word', 'consonants', 'vowel', 'MeanCI'});
set(gca, 'xticklabel', stim_cluster_cats)
all_stim_fig.Name = sprintf('Stim All');
all_stim_fig.NumberTitle = 'off';
hold off;

all_onset_stats_table = stats_struct.('All').onset_stats;
all_onset_mean = [all_onset_stats_table.word_name_mean_onset_accuracy, all_onset_stats_table.consonants_name_mean_onset_accuracy, all_onset_stats_table.vowel_name_mean_onset_accuracy];
all_onset_meanci_low = [all_onset_stats_table.word_name_meanci_onset_accuracy(:,1), all_onset_stats_table.consonants_name_meanci_onset_accuracy(:,1), all_onset_stats_table.vowel_name_meanci_onset_accuracy(:,1)];
all_onset_meanci_high = [all_onset_stats_table.word_name_meanci_onset_accuracy(:,2), all_onset_stats_table.consonants_name_meanci_onset_accuracy(:,2), all_onset_stats_table.vowel_name_meanci_onset_accuracy(:,2)];

all_onset_fig = figure();

all_onset_bar = bar(all_onset_mean, 'grouped');
hold on;
[all_onset_ngroups, all_onset_nbars] = size(all_onset_mean);

% Get the x coordinate of the bars
all_onset_err_x = nan(all_onset_nbars, all_onset_ngroups);
for i = 1:all_onset_nbars
    all_onset_err_x(i,:) = all_onset_bar(i).XEndPoints;
end

errorbar(all_onset_err_x', all_onset_mean, all_onset_meanci_low, all_onset_meanci_high, 'k', 'linestyle', 'none');
title(sprintf('Mean Accuracies for LDA models \ntrained on All electrodes \nfor Onset Data'));
legend({'word', 'consonants', 'vowel', 'MeanCI'});
set(gca, 'xticklabel', onset_cluster_cats)
all_onset_fig.Name = sprintf('Onset All');
all_onset_fig.NumberTitle = 'off';
hold off;

pooled_data_stats_file = sprintf('e%s_w%s_s%s_pooled_data_stats', string(event_duration), string(window), string(stride));
pooled_data_stats_filename_full = fullfile(mRMR_path, times_folder, pooled_data_stats_file);
save(pooled_data_stats_filename_full, 'stats_struct', '-v7.3');

end

