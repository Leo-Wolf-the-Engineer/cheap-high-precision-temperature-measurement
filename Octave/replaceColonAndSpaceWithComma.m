function replaceColonAndSpaceWithComma(filename)
    % Read the file
    file = fopen(filename, 'r');
    data = textscan(file, '%s', 'Delimiter', '\n');
    lines = data{1};
    fclose(file);

    % Convert the lines to a character matrix
    charMatrix = char(lines);

    % Replace colons and spaces with commas
    charMatrix(charMatrix == ':') = ',';
    charMatrix(charMatrix == ' ') = ',';

    % Convert the character matrix back to a cell array of strings
    lines = cellstr(charMatrix);

    % Save the file with the modified lines
    file = fopen(filename, 'w');
    for i = 1:length(lines)
        fprintf(file, '%s\n', lines{i});
    end
    fclose(file);
end
