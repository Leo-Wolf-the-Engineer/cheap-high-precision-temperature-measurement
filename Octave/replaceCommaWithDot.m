function replaceCommaWithDot(filename)
    % Read the file
    file = fopen(filename, 'r');
    data = textscan(file, '%s', 'Delimiter', '\n');
    lines = data{1};
    fclose(file);

    % Convert the lines to a character matrix
    charMatrix = char(lines);

    % Iterate over each line to replace the first comma with a dot if no dot is at the 7th position
    for i = 1:size(charMatrix, 1)
        line = charMatrix(i, :);
        commaIndex = find(line == ',', 1);
        if ~isempty(commaIndex)
            if length(line) >= 7 && line(7) ~= '.'
                line(commaIndex) = '.';
            elseif length(line) < 7
                line(commaIndex) = '.';
            end
        end
        charMatrix(i, :) = line;
    end

    % Convert the character matrix back to a cell array of strings
    lines = cellstr(charMatrix);

    % Save the file with the modified lines
    file = fopen(filename, 'w');
    for i = 1:length(lines)
        fprintf(file, '%s\n', lines{i});
    end
    fclose(file);
end
