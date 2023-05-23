    
function [newC] = reflect_object(newPossible, fieldSize, add_from_the_side)
 
    
    if newPossible < 1 
        newC = fieldSize-add_from_the_side;
    end
    if newPossible >= fieldSize
        newC = add_from_the_side;
    end

    

end