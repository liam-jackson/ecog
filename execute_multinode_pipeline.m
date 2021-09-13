function job = execute_multinode_pipeline(number_of_nodes)

% Performs CV, mRMR, LDA on randomized ECoG feature sets across SCC nodes
% 
% Submits cv_mRMR_LDA_SCC_node_pipeline as a job to number_of_nodes nodes. 

addpath /project/busplab/software/conn 
addpath /project/busplab/software/spm12

for node_number = 1:number_of_nodes 
   job(node_number) = conn('submit', 'cv_mRMR_LDA_SCC_node_pipeline', node_number);
end



end