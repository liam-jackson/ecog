addpath /project/busplab/software/ecog/util/
addpath /project/busplab/software/spm12
addpath /project/busplab/software/conn
addpath /project/busplab/software/display	
addpath /project/busplab/software/display/surf

load('/projectnb2/busplab/Experiments/ECoG_Preprocessed_AM/electrodes.mat', 'electrodes')

ops.clusters_as_colors = 1; % include cluster label
ops.output_resolution = 300;
ops.force_close = 1;

for benf_row = 1:height(sig_benf_data)
    ovr_label = sig_benf_data.ovr_label(benf_row); 
    stim_benf_label_data = sig_benf_data.stim_sig_bool{benf_row}; 
    onset_benf_label_data = sig_benf_data.onset_sig_bool{benf_row}; 
    
    if ~isempty(stim_benf_label_data)
        sub_nums = unique(stim_benf_label_data.sub_num);
        for sub_num_idx = 1:length(sub_nums)
            sub_num = sub_nums(sub_num_idx); 
            e_row_ids = stim_benf_label_data.stim_table_idx(stim_benf_label_data.sub_num == sub_num & ~strcmp(cellstr(stim_benf_label_data.stim_cluster), 'NaN'));
            ops.img_title = sprintf('%s, S%d, Stimulus Aligned', string(ovr_label), sub_num);
            ops.img_savename = fullfile(figures_path, sprintf('%s_S%d_stim', string(ovr_label), sub_num)); % filename to save as
            if ~isempty(e_row_ids)
                plot_greenlee_electrodes_on_brain(e_row_ids, [], ops);
            end
        end
    end
    
    if ~isempty(onset_benf_label_data)
        sub_nums = unique(onset_benf_label_data.sub_num);
        for sub_num_idx = 1:length(sub_nums)
            sub_num = sub_nums(sub_num_idx); 
            e_row_ids = onset_benf_label_data.onset_table_idx(onset_benf_label_data.sub_num == sub_num & ~strcmp(cellstr(onset_benf_label_data.onset_cluster), 'NaN'));
            ops.img_title = sprintf('%s, S%d, Onset Aligned', string(ovr_label), sub_num);
            ops.img_savename = fullfile(figures_path, sprintf('%s_S%d_onset', string(ovr_label), sub_num)); % filename to save as             
            if ~isempty(e_row_ids)
                plot_greenlee_electrodes_on_brain(e_row_ids, [], ops);
            end
        end
    end
    
    
end    


% plot_greenlee_electrodes_on_brain(stim_elecs, [], ops)
% plot_greenlee_electrodes_on_brain(onset_elecs, [], ops)

