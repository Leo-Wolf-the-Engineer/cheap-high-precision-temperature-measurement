function newMatrix = extractValues_Diy(matrix,upperBound,lowerBound)
    % Find rows that lie in the specified boundaries
    rowsToExtract = (matrix(:, 1) > lowerBound) & (matrix(:, 1) < upperBound);

    % extract the 4th and 5th coloumn
    extractedValues(:,1) = matrix(rowsToExtract, 1);
    extractedValues(:,2:7) = matrix(rowsToExtract, 2:7);

    % return extracted values
    newMatrix = extractedValues;
end
