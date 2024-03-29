%%%%
% Function reflect_object is a helper function, to generate a correct
% position for an object if wall-type is "reflected and an object walked
% through it

% ACCEPTS:
% * newPossible - new-coordinate assigned initialy in a moving function,
%  here will be out of boundaries of the field
% * fieldSize - size of the current field
% * add_from_the_side - how far away an object walked away from the
% opposite wall after walking through the wall

% RETURNS:
% * newC - the valid new x or y coordinate of an object on the field
%%%%   



function [newC] = reflect_object(newPossible, fieldSize, add_from_the_side)
 
    if newPossible < 1 
        newC = fieldSize-add_from_the_side;
    end
    if newPossible >= fieldSize
        newC = add_from_the_side;
    end

end