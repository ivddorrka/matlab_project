function [updatedField, updatedObjectCoordinates, reached_border] = moveObjectsOnce(field, objectCoordinates, wall_action)

    numObjects = size(objectCoordinates, 1);
    fieldSize = size(field, 1);
    reached_border = false;


    for i = 1:numObjects
        
        modifyY = randi([0, 1]);

        
        currentX = objectCoordinates(i, 1);
        currentY = objectCoordinates(i, 2);
        color = objectCoordinates(i, 3);

        to_paint = true;
        if modifyY

            newY = currentY + randi([-1, 1]);
            if newY < 1 || newY > fieldSize
                reached_border = true;
                if wall_action == "reflected"
                    newY = reflect_object(newY, fieldSize);
                end
                if wall_action == "simple"
                    newY = currentY;
                    to_paint = false;
                end
                if wall_action == "absorption"
                    objectCoordinates(i, :) = [];
                    to_paint = false;
                end



            end
            if to_paint
                field(currentX, newY, :) = color; 
                objectCoordinates(i, 2) = newY; 
            end


        else
            newX = currentX + randi([-1, 1]);
            if newX < 1 || newX > fieldSize
                if wall_action == "reflected"
                    newX = reflect_object(newX, fieldSize);
                end
                if wall_action == "simple"
                    newX = currentX;
                    to_paint = false;
                end
                if wall_action == "absorption"
                    objectCoordinates(i, :) = [];
                    to_paint = false;
                end


            end
            if to_paint
                field(newX, currentY, :) = color; 
                objectCoordinates(i, 1) = newX; 
            end
%             newX = currentX + randi([-1, 1]);
%             if newX >= 1 && newX <= size(field, 1)
%                 field(newX, currentY, :) = color; 
%                 objectCoordinates(i, 1) = newX; 
%             end
        end
    end

    updatedField = field;
    updatedObjectCoordinates = objectCoordinates;

end
