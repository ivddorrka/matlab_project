function [field, objectPositions] = generated_and_returned(fieldSize, numObjects, generate_agents_in_random_places)

    middle = floor(fieldSize/2);

    field = ones(fieldSize, fieldSize, 3) * 255; 
    objectColors = randi([1, 254], numObjects, 1);

    if ~generate_agents_in_random_places
        objectPositions = repmat(middle, 2, numObjects)';
    
        field(middle, middle, :) = objectColors(1);
    
        objectPositions = [objectPositions objectColors];
    else
        objectPositions = randi([1, fieldSize], numObjects, 2);
         
        for i = 1:numObjects
            x = objectPositions(i, 1);
            y = objectPositions(i, 2);
            color = objectColors(i);
            field(x, y, :) = color;
        end
        objectPositions = [objectPositions objectColors];
    end
    

    
end

