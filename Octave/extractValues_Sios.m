function newMatrix = extractValues_Sios(matrix,upperBound,lowerBound)
    % Find rows that lie in the specified boundaries
    rowsToExtract = (matrix(:, 1) > lowerBound) & (matrix(:, 1) < upperBound);

    % extract the 4th and 5th coloumn
    extractedValues(:,1) = matrix(rowsToExtract, 1);
    extractedValues(:,4:5) = matrix(rowsToExtract, 4:5);

    % return extracted Values
    newMatrix = extractedValues;
end
