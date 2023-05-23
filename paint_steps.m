%%%%
% Function paint_steps is a helper function, to decide what to do with
% an object coordinate in case it is out of boundaries AND depending on
% the type of the wall-type

% ACCEPTS:
% * c - boolean - if true - than the x-coordinate is stable, and object has
% moved along y-coordinate, vice-versa otherwise
% * c_stable - coordinate of a stable coordinate
% * c_moving_start - coordinate-start for a moving 
% * c_moving_end - coordinate-end for a moving 
% * color - color to mark the trace
% * field - current field to make trace on
% * was_reflected - boolean: whether object was reflected through the wall or not
% * fieldSize - size of the current field

% RETURNS:
% field - updated field with colored steps



function [field] = paint_steps(c, c_stable, c_moving_start, c_moving_end, color, field, was_reflected, fieldSize)
   
    if ~was_reflected || (abs(c_moving_end-c_moving_start)<=10 && ~was_reflected)

        for i = min(c_moving_start, c_moving_end):max(c_moving_start, c_moving_end)
            if ~c
                field(i, c_stable, :) = color; 
            else
                field(c_stable, i, :) = color; 
            end

        end

    else
        if c_moving_end-c_moving_start>10
            for i = 1:c_moving_start
               if ~c
                field(i, c_stable, :) = color; 
            else
                field(c_stable, i, :) = color; 
               end
            end

            for i = c_moving_end:fieldSize
               if ~c
                field(i, c_stable, :) = color; 
            else
                field(c_stable, i, :) = color; 
               end
            end


        else
            for i = 1:c_moving_end
               if ~c
                field(i, c_stable, :) = color; 
            else
                field(c_stable, i, :) = color; 
               end
            end

            for i = c_moving_start:fieldSize
               if ~c
                field(i, c_stable, :) = color; 
            else
                field(c_stable, i, :) = color; 
               end
            end
        end

    end

end
