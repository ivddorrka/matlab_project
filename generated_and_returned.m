%%%%
% Function to generate the initial field (or park) of a size fieldSize x fieldSize 
% ACCEPTS:
% * fieldSize
% * numObjects - number of agents to be generated on the field
% * generate_agents_in_random_places - boolean - if true - each agent is
% generated in a random place accross the field, otherwise all of them
% start from the middle

% RETURNS:
% * field - fieldSize x fieldSize x 3 object, where each cell is eithe
% blank (white) or has an agent in it(colored with a shade of grey from
% 1-254
% * objectPositions - Nx3 object where each row is  
% (x-coordinate,y-coordinate, color) of each object
%%%%
 
function [field, objectPositions] = generated_and_returned(fieldSize, numObjects, generate_agents_in_random_places)

    middle = floor(fieldSize/2);

    field = ones(fieldSize, fieldSize, 3) * 255; 
    objectColors = randi([1, 254], numObjects, 1);

    if ~generate_agents_in_random_places
        %%% GENERATE ALL OBJECTS IN THE MIDDLE %%%
        objectPositions = repmat(middle, 2, numObjects)';
    
        field(middle, middle, :) = objectColors(1);
    
        objectPositions = [objectPositions objectColors];
    else
        %%% GENERATE OBJECTS IN RANDOM PLACES %%%
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

