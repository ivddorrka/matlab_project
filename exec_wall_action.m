function [absorbed_objects, newC, to_paint] = exec_wall_action(newC, wall_action, fieldSize, absorbed_objects, i)
    

    if strcmp(wall_action , 'reflected')
        to_paint = true;
        absorbed_objects = absorbed_objects;
        add_from_the_side = 0;
        
        if newC<0
            add_from_the_side = abs(0 - newC);
        elseif newC > fieldSize
            add_from_the_side = newC - fieldSize;
        end
        newC = reflect_object(newC, fieldSize, add_from_the_side);

    end
    if strcmp(wall_action, 'simple')
        if newC > fieldSize
            newC = fieldSize;
            to_paint=true;
        elseif newC < 1
            newC = 1;
            to_paint = true;
        else
            newC = currentY;
            to_paint = false;
        end
        

    end
    if strcmp(wall_action, 'absorption')
        absorbed_objects = [absorbed_objects, i];
        to_paint = true;
        if newC>fieldSize
            newC=fieldSize;
        elseif newC<=0
            newC = 1;
        else
            newC = newC;
        end

    end

    
end
