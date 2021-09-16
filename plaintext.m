function proper = plaintext(str_arr_or_cell_arr)

st = dbstack;
fxn = st.name

if ischar(str_arr_or_cell_arr)
    proper = plaintext_singular(string(str_arr_or_cell_arr));
else
    proper = string(1:length(str_arr_or_cell_arr));
    for i = 1:length(str_arr_or_cell_arr)
        if iscell(str_arr_or_cell_arr)
            proper(i) = plaintext_singular(string(str_arr_or_cell_arr{i}));
        elseif isstring(str_arr_or_cell_arr)
            proper(i) = plaintext_singular(string(str_arr_or_cell_arr(i)));
        end
    end
end



function proper_singular = plaintext_singular(str_or_cell)
% s = regexprep(str_or_cell, '[\\\^\_]','\\$0');
s_split = strsplit(str_or_cell, '_');

proper_singular = string(strjoin({strcat(upper(s_split{1}(1)), s_split{1}(2:end)),...
    strcat(upper(s_split{2}(1)), s_split{2}(2:end))}, ' '));
end
end