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
