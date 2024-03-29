%%%%
% Function exec_wall_action is a helper function, to decide what to do with
% an object coordinate in case it is out of boundaries AND depending on
% the type of the wall-type

% ACCEPTS:
% * newC - x or y - new-to-be coordinate which is out of boundaries of the
% field
% * wall_action - type of the current wall
% * fieldSize - size of a current field
% * absorbed_objects - list of to-be-killed objects
% * i - nunmber of an object in the objectCoordinates list, that's been
% passed to the moving-function

% RETURNS:
% * absorbed_objects - updated list of to-be-killed objects
% * newC - the valid new x or y coordinate of an object on the field
% * to_paint - boolean - if true, that object's trace will be marked,
% otherwise not
%%%%   



function [absorbed_objects, newC, to_paint] = exec_wall_action(newC, wall_action, fieldSize, absorbed_objects, i)
    
    % case wall-type is reflected
    if strcmp(wall_action , 'reflected')
        to_paint = true;
        absorbed_objects = absorbed_objects;
        
        % distance of how far away from the opposite wall object moved 
        add_from_the_side = 0;
        if newC<0
            add_from_the_side = abs(0 - newC);
        elseif newC > fieldSize
            add_from_the_side = newC - fieldSize;
        end
        % return new valid x or y coordinate for a reflected object
        newC = reflect_object(newC, fieldSize, add_from_the_side);
    end

    % case wall-type is simple 
    if strcmp(wall_action, 'simple')

        %object's trying to move out from the field
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

    % case wall-type is absorption
    if strcmp(wall_action, 'absorption')
        % update to-be-killed objects
        absorbed_objects = [absorbed_objects, i];
        to_paint = true;
        % last-position
        if newC>fieldSize
            newC=fieldSize;
        elseif newC<=0
            newC = 1;
        else
            newC = newC;
        end

    end

end
