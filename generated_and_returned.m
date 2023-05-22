function [field, objectPositions] = generated_and_returned(fieldSize, numObjects)

    middle = floor(fieldSize/2);

    field = ones(fieldSize, fieldSize, 3) * 255; 

    objectPositions = repmat(middle, 2, numObjects)';

    objectColors = randi([1, 254], numObjects, 1); 

    field(middle, middle, :) = objectColors(1);

    objectPositions = [objectPositions objectColors];
    
end

