function generateFieldWithObjects(numObjects)
    fieldSize = 100;

    field = ones(fieldSize, fieldSize, 3) * 255; % Assuming white color is represented by 255

    objectPositions = randi([1, fieldSize], numObjects, 2);
    objectColors = randi([1, 254], numObjects, 1); % Generate single color values
    for i = 1:numObjects
        x = objectPositions(i, 1);
        y = objectPositions(i, 2);
        color = objectColors(i);
        field(x, y, :) = color;
    end

%     % Now this will display the field:
%     imshow(uint8(field));
end
