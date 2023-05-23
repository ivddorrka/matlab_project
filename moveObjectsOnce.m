function [average_step, updatedField, updatedObjectCoordinates, reached_border, all_dead] = moveObjectsOnce(field, objectCoordinates, wall_action, step_size_random)

    numObjects = size(objectCoordinates, 1);
    disp("NUM OBJECTS = " + num2str(numObjects));
    fieldSize = size(field, 1);
    reached_border = false;

    absorbed_objects = [];
    
    
    try
        average_step = 0;
        if numObjects==0
            error('MoveImpossibleException:ErrorID', 'All agents dead');
        else
            for i = 1:numObjects
                was_reflected = false;
                step_size = randi([-1, 1]);
                if step_size_random
                    step_size = randi([-10, 10]);
                end
        
                modifyY = randi([0, 1]);
        
                
                currentX = objectCoordinates(i, 1);
                currentY = objectCoordinates(i, 2);
                color = objectCoordinates(i, 3);
        
                to_paint = true;
                if modifyY
        
                    newY = currentY + step_size;
                    if newY < 1 || newY > fieldSize
                        reached_border = true;
                        if strcmp(wall_action, "reflected")
                            was_reflected = true;
                        end
                        [absorbed_objects, newY, to_paint] = exec_wall_action(newY, wall_action, fieldSize, absorbed_objects, i);          
                        
                    end

                    if to_paint
                        
                        
                        [field] = paint_steps(false, currentX, currentY, newY, color, field, was_reflected, fieldSize);
                        
                    end
        
                    objectCoordinates(i, 2) = newY;
                else
        
                    newX = currentX + step_size;
                    if newX < 1 || newX > fieldSize
                        if strcmp(wall_action, "reflected")
                            was_reflected = true;
                        end
                        reached_border = true;
                        [absorbed_objects, newX, to_paint] = exec_wall_action(newX, wall_action, fieldSize, absorbed_objects, i);
                        
                    end

                    if to_paint
                        
                        [field] = paint_steps(true, currentY, currentX, newX, color, field, was_reflected, fieldSize);
                     
                    end
                    objectCoordinates(i, 1) = newX; 
                 
                end
                average_step = average_step + abs(step_size) / numObjects;
            end
        
        
            objectCoordinates(absorbed_objects, :) = [];
            updatedField = field;
            updatedObjectCoordinates = objectCoordinates;
            all_dead = false;
        end
        
    catch exception 
        disp(exception.message);
        updatedField = field;
        updatedObjectCoordinates = objectCoordinates;
        reached_border = true;
        all_dead = true;
    end

end
