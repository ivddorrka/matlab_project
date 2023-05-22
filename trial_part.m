% Set the field size
fieldSize = 100;

% Create the field with white color
field = ones(fieldSize, fieldSize, 3) * 255; % Assuming white color is represented by 255

% Set the number of objects
numObjects = 20;

% Generate random positions for the objects
objectPositions = randi([1, fieldSize], numObjects, 2);

% Generate random colors for the objects (excluding white)
objectColors = randi([1, 254], numObjects, 1); % Generate single color values

% Place the objects on the field
for i = 1:numObjects
    x = objectPositions(i, 1);
    y = objectPositions(i, 2);
    color = objectColors(i);
    field(x, y, :) = color;
end

% Display the field
imshow(uint8(field));
