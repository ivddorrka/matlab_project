    
function [newC] = reflect_object(newPossible, fieldSize)
 
    
    if newPossible < 1 
        newC = fieldSize;
    end
    if newPossible > fieldSize
        newC = 1;
    end

    

end