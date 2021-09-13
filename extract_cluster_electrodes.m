%{
This function extracts epoch data for the electrodes associated with 
clusters based on Scott's paper. 
Pass:
valid_data_sub structure from MLData_Consolidation

Returns epoch data associated with the electrodes from Scott's analysis
%}

function [reduced_elect_epoched_stim_data, reduced_elect_epoched_onset_data] = extract_cluster_electrodes(valid_data_sub)

electrodes_list_stim = unique(valid_data_sub.electrodes_stim.idx_LocalProcessed);
electrodes_list_onset = unique(valid_data_sub.electrodes_onset.idx_LocalProcessed);
reduced_elect_epoched_stim_data = valid_data_sub.epoched_stim_data.data(electrodes_list_stim, :,:);
reduced_elect_epoched_onset_data = valid_data_sub.epoched_onset_data.data(electrodes_list_onset, :,:);

end








