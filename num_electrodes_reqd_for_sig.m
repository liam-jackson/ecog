p_value = 0.05;

stim_total_trials = 319; 

stim_word_num_trials_reqd = icdf('Binomial', (p_value) / 12, stim_total_trials, .05)
stim_cons_num_trials_reqd = icdf('Binomial', (p_value) / 4, stim_total_trials, .05) 
stim_vowel_num_trials_reqd = icdf('Binomial', (p_value) / 3, stim_total_trials, .05)

stim_word_num_trials_reqd = icdf('Binomial', (1 - p_value), stim_total_trials, 1/12)
stim_cons_num_trials_reqd = icdf('Binomial', (1 - p_value), stim_total_trials, 1/4) 
stim_vowel_num_trials_reqd = icdf('Binomial', (1 - p_value), stim_total_trials, 1/3)

stim_word_sig_prop = stim_word_num_trials_reqd / stim_total_trials
stim_cons_sig_prop = stim_cons_num_trials_reqd / stim_total_trials
stim_vowel_sig_prop = stim_vowel_num_trials_reqd / stim_total_trials




