close all;

title_size = 28;
subtitle_size = 22; 
label_size = 24; 
legend_size = 18; 
tick_size = 18; 

sub_idx = 4; 

electrode = 1;

trial = 1; 

y1 = all_subs_indiv_elect_feat_table.consonants_name.stim_feat{sub_idx}.stim_feat_class{electrode};

y2 = all_subs_indiv_elect_feat_table.consonants_name.onset_feat{sub_idx}.onset_feat_class{electrode};

y1_arr = table2array(y1.stim_feat(trial,:));
y2_arr = table2array(y2.onset_feat(trial,:)); 

epoch_offset_fig = figure();
epoch_offset_fig.WindowState = 'maximized';

plot(y1_arr(9:end), 'LineWidth', 3);
hold on;
plot(y2_arr, 'LineWidth', 3);

title({'S372, electrode 4 feature set for trial 1', '[Stimulus advanced 9 time points]'}, 'FontSize', title_size);
xlabel('Discretized Time', 'FontSize', label_size);
ylabel('Moving Mean HG', 'FontSize', label_size);
legend({'Stim', 'Onset'}, 'FontSize', legend_size);
grid on;