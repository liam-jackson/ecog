% Decodes feature names from create_features.m

function [electrode, window] = electrode_window_parser(eXXwYY)

if iscell(eXXwYY)
    label_split = strsplit(eXXwYY{1}, {'e', 'w'});
elseif isstring(eXXwYY)
    label_split = strsplit(eXXwYY, {'e', 'w'});
elseif ischar(eXXwYY)
    label_split = strsplit(eXXwYY, {'e', 'w'});
end
    
electrode = str2double(label_split{2});
window = str2double(label_split{3});

end

