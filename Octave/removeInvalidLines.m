function removeInvalidLines(filename)
    % Read File
    file = fopen(filename, 'r');
    data = textscan(file, '%s', 'Delimiter', '\n');
    lines = data{1};
    fclose(file);

    % Convert to matrix
    matrix = char(lines);

    % count points and commata
    numPoints = sum(matrix == '.', 2);
    numCommas = sum(matrix == ',', 2);

    % Find Lines that have 7 points and 6 commata
    validRows = (numPoints == 7) & (numCommas == 6);

    % extract the valid rows
    validLines = lines(validRows);

    % save the valid lines to file
    file = fopen(filename, 'w');
    for i = 1:length(validLines)
        fprintf(file, '%s\n', validLines{i});
    end
    fclose(file);
end
