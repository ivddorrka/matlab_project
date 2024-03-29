%%%%
% Function moveObjectsOnce moves each object once according to the step-size and colors 
% traces of their movement 
% ACCEPTS:
% * field - current field
% * objectCoordinates - current object coordinates
% * initial_agent_coordinates - these are the original coordinates of each
% object - birth-place-coordinates
% * wall_action - can be of three types 
%
% * ** simple - walls are simple walls - object can not pass through them 
% * ** absorption - in case object tries to go over the wall - it get's
% "killed" and removed from the walk (it's coordinates are removed as well)
% * ** reflected - if an object tries to go through the wall it walks in
% the wall and goes out on the other side of the field (directly opposite
% wall)
%
% * step_size_random - boolean - if true - then the stepsize is a random
% int number between [-10, 10], otherwise step is random between [-1,1]


% RETURNS:
% * average_displacement - mean of (displacement of each object from it's
% birth place) 
% * initial_agent_coordinates - in case wall type is absorption the initial
% coordinates are updated as well (dead object's coordinates should be
% removed from both current and original coordinates)
% * average_step - average step objects have done
% * updatedField - field after each object has moved
% * updatedObjectCoordinates - updated coordinates after the move
% * reached_border - boolean - true if at least one object has reached the
% border, false otherwise
% * all_dead - boolean - if true - means that there're no objects left to
% walk around, false otherwise

%%%%


function [average_displacement, initial_agent_coordinates, average_step, updatedField, updatedObjectCoordinates, reached_border, all_dead] = moveObjectsOnce(field, objectCoordinates, initial_agent_coordinates, wall_action, step_size_random)

    numObjects = size(objectCoordinates, 1);
    fieldSize = size(field, 1);
    reached_border = false;
    absorbed_objects = [];
    average_displacement = 0;
    average_step = 0;

    try % check if there're alive objects to proceed with the walk
        
        if numObjects==0
            error('MoveImpossibleException:ErrorID', 'All agents dead');
        else
            % Main loop to move each object and update the trace of
            % movement
            for i = 1:numObjects
                was_reflected = false; % necessarry in case wall-type is "reflected"

                % setting step size
                step_size = randi([-1, 1]);
                if step_size_random
                    step_size = randi([-10, 10]);
                end
                
                
                % for each object basically changes only one coordinate: x
                % or y
                modifyY = randi([0, 1]);
        
                % current data for the object
                currentX = objectCoordinates(i, 1);
                currentY = objectCoordinates(i, 2);
                color = objectCoordinates(i, 3);
                
                % in case the wall is simple -- there's no need to repaint
                % the object's current position
                to_paint = true;
                
                % case Y-coordinate changes
                if modifyY
                    newY = currentY + step_size;

                    % case new coordinate is out of boundaries
                    if newY < 1 || newY > fieldSize
                        reached_border = true;
                        if strcmp(wall_action, "reflected")
                            was_reflected = true; % signifies that object 
                            % was teleported to the opposite wall
                        end
                        % call to the wall action function to decide on the
                        % new-coordinate, whether to paint the trace and
                        % update killed objects
                        [absorbed_objects, newY, to_paint] = exec_wall_action(newY, wall_action, fieldSize, absorbed_objects, i);          
                        
                    end

                    if to_paint % mark object's trace
                        [field] = paint_steps(false, currentX, currentY, newY, color, field, was_reflected, fieldSize);      
                    end
                    
                    % update coordinate
                    objectCoordinates(i, 2) = newY;
                
                % case X-coordinate changes
                else
                    
                    newX = currentX + step_size;

                    % case new coordinate is out of boundaries
                    if newX < 1 || newX > fieldSize
                        reached_border = true;
                        if strcmp(wall_action, "reflected")
                            was_reflected = true;% signifies that object 
                            % was teleported to the opposite wall
                        end

                        % call to the wall action function to decide on the
                        % new-coordinate, whether to paint the trace and
                        % update killed objects
                        [absorbed_objects, newX, to_paint] = exec_wall_action(newX, wall_action, fieldSize, absorbed_objects, i);
                        
                    end

                    if to_paint % mark object's trace
                        [field] = paint_steps(true, currentY, currentX, newX, color, field, was_reflected, fieldSize);
                    end

                    % update coordinate
                    objectCoordinates(i, 1) = newX; 
                 
                end
                
                % update average step and average displacements for plots
                average_step = average_step + abs(step_size) / numObjects;

                dot1 = [initial_agent_coordinates(i, 1) initial_agent_coordinates(i, 2)];
                dot2 = [objectCoordinates(i,1) objectCoordinates(i, 2)];

                average_displacement = average_displacement + norm(dot1-dot2);

            end
        
            % update TOTAL average displacement 
            average_displacement = average_displacement / numObjects;

            % Kill objects who tried to walk over the wall if the wall-type
            % is absorption
            if strcmp(wall_action, "absorption")
                objectCoordinates(absorbed_objects, :) = [];
                initial_agent_coordinates(absorbed_objects, :) = [];
            end
            
            % update field, coordinates and all_dead params
            updatedField = field;
            updatedObjectCoordinates = objectCoordinates;
            all_dead = false;
        end

    % case there're no objects left to walk around
    catch exception 
        
        disp(exception.message);
        % basically averybody died
        updatedField = field;
        updatedObjectCoordinates = objectCoordinates;
        reached_border = true;
        all_dead = true;
        average_displacement = 0;
    end

end
