%%%%
% Function main - the main function of the program, shoud be started
% withput any parameters
% neother accepts nor returns anything
%%%%


function main()
    
%%%% initial parameters %%%%
    initial_number_of_agents = 50;
    initial_size_of_field = 100;
    % round means each objects has made its move
    number_rounds = 0;
    % number of rounds to reach the border for the first time
    number_rounds_to_border = 0;
    reached_border_first_time = false;
    % initially set wall-type to simple
    wall_type = "simple";
    wall_type_for_setup = "simple";

    % initially set step-size to not-random  (aka step-size is either 0 or 1)
    step_size_random_setup = false;
    step_size_random = false;

    % x-coordinate for both for data-plots
    new_x_for_plot = 0;
    % initially each agent is generated in the middle of the field
    generate_agents_in_random_places = false;

    % average total OVERALL speed 
    average_speed_total = 0;
    speed_total = 0;

    %initial objects' (or agents' coordinates)
    initial_agent_coordinates = [];

    % create figure for graphical depiction of the random-walk
    fig = uifigure('Name', 'Random Walks');
    ax = uiaxes(fig);
    ax.Position = [80 10 fig.Position(3)-10 fig.Position(4)-10];
  
    % speed-plot
    plotAx = uiaxes(fig);
    plotAx.NextPlot = 'add';
    plotAx.Position = [ax.Position(1)+ax.Position(3) 10 round(ax.Position(3)/3) round(ax.Position(3)/4)];
    plotAx.Box = 'on';
    plotAx.Title.String = "Average speed";

    % displacement-plot
    plotAx2 = uiaxes(fig);
    plotAx2.NextPlot = 'add';
    plotAx2.Position = [ax.Position(1)+ax.Position(3) plotAx.Position(2)+plotAx.Position(4)+40 round(ax.Position(3)/3) round(ax.Position(3)/4)];
    plotAx2.Box = 'on';
    plotAx2.Title.String = "Mean-displacement";
    
    % creating the initial field & objects on it
    [field, OC] = generated_and_returned(initial_size_of_field, initial_number_of_agents, generate_agents_in_random_places);
    initial_agent_coordinates = OC;
    image(ax, uint8(field));
    axis(ax, 'off'); 

    % monitor with user-friendly helping messages
    textarea = uitextarea(fig);
    textarea.InnerPosition = [10 fig.Position(2)+round(fig.Position(2)/2) 70 40];    
    textarea.Value = 'Init message';
    textarea.Editable = false;

    % monitor with number-of-rounds to reach the wall counter 
    % as soon as the wall was reached for the first time - will never
    % update it's value again
    textarea2 = uitextarea(fig);
    textarea2.InnerPosition = [10 textarea.Position(2)-50 70 40];   
    txt2val = "Number of rounds: " + num2str(number_rounds);
    textarea2.Value = txt2val;
    textarea2.Editable = false;

    % setupButton in case user chose other conditions for the random-walk
    setupButton = uibutton(fig, 'Text', 'SETUP', 'Position', [10 textarea2.Position(2)-50 70 40]);    
    setupButton.ButtonPushedFcn = @(btn, event) updateSetup();


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% BUTTON MOVEs ONCE/INF %%%%%%%%%%%%
    moveOnceButton = uibutton(fig, 'Text', 'Move Once');    
    moveOnceButton.ButtonPushedFcn = @(btn, event) updateField("once");
    moveOnceButton.Position = setupButton.Position;
    moveOnceButton.Position(2) = moveOnceButton.Position(2)-50;

    moveInfiniteButton = uibutton(fig, 'Text', 'Move Infinite');    
    moveInfiniteButton.Position = moveOnceButton.Position;
    moveInfiniteButton.Position(2) = moveInfiniteButton.Position(2)-50;
    moveInfiniteButton.ButtonPushedFcn = @(btn, event) updateFieldInfinite();
    %%%%%%%%%%% BUTTON MOVE END %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%% TIMER FOR MOVING %%%%%%%%%%%%%%
    t = timer('ExecutionMode', 'fixedRate', 'Period', 0.1, 'TimerFcn', @(~,~) updateField("infinit"));
    isTimerRunning = false;
    %%%%%%%%%%%%%%%% TIMER END %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% SLIDER FOR NUM AGENTS/FieldSize %%%%%%%%%%%%%

    slider = uislider(fig);
    slider.Position = [10 moveInfiniteButton.Position(2)-30 70 40]; % Position the slider below the textarea    
    
    slider.Limits = [1, 200];  
    slider.Value = initial_number_of_agents;  
    slider.ValueChangedFcn = @(src, event) sliderValueChanged(src);

    label = uilabel(fig);
    label.Position = slider.Position;
    label.Position(2) = label.Position(2) -70;
    label.Position(4) = 60;
    label.Text = 'Number of agents';



    slider2 = uislider(fig);
    slider2.Position = [10 label.Position(2)-10 70 40]; % Position the slider below the textarea    
    
    slider2.Limits = [10, 1000];  
    slider2.Value = initial_size_of_field;  
    slider2.ValueChangedFcn = @(src, event) fieldSizeValueChanged(src);

    label2 = uilabel(fig);
    label2.Position = slider2.Position;
    label2.Position(2) = label2.Position(2) -70;
    label2.Position(4) = 60;
    label2.Text = 'Size of field';

    %%%%%% SLIDER FOR NUM AGENTS END %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%% Wall choice type %%%%%%%%%%%%%%

    buttonGroup = uibuttongroup(fig, 'Position', [label2.Position(1) + label2.Position(3) + 20 label2.Position(2)+15 220 60]);

    radioButton1 = uiradiobutton(buttonGroup, 'Text', 'reflected', 'Position', [10 30 100 20]);
    radioButton2 = uiradiobutton(buttonGroup, 'Text', 'simple', 'Position', [10 10 100 20]);
    radioButton3 = uiradiobutton(buttonGroup, 'Text', 'absorption', 'Position', [110 30 100 20]);

    radioButton2.Value = true;

    buttonGroup.SelectionChangedFcn = @(group, event) handleSelectionChange(group.SelectedObject.Text);

    %%%%%%%%%% Wall choice type END %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%% Random-step choice %%%%%%%%%%%%
    checkBoxstep = uicheckbox(fig);
    checkBoxstep.Text = 'Random-Step';
    checkBoxstep.Position = [buttonGroup.Position(1)+buttonGroup.Position(3)+10 buttonGroup.Position(2)+40 120 20];
    checkBoxstep.ValueChangedFcn = @(src, evt) changeCB_Value(checkBoxstep);

    checkBoxRandomAgents = uicheckbox(fig);
    checkBoxRandomAgents.Text = 'Random-Agents';
    checkBoxRandomAgents.Position = [buttonGroup.Position(1)+buttonGroup.Position(3)+10 buttonGroup.Position(2)+20 120 20];
    checkBoxRandomAgents.ValueChangedFcn = @(src, evt) randomAgentsGen(checkBoxRandomAgents);
    %%%%%%%%%% Random-step choice END %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% CALLBACKS %%%%%%%%%%%%%%%%%%

    function changeCB_Value(checkBox)
        if checkBox.Value
            step_size_random = true;
            
        else
            step_size_random = false;
            
        end
    end

    function randomAgentsGen(checkBox)
        generate_agents_in_random_places = false;
        if checkBox.Value
            generate_agents_in_random_places = true;
        end
    end


    function handleSelectionChange(selection)
        if strcmp(selection, 'absorption')
            wall_type = 'absorption';
            
        end
        if strcmp(selection,'simple')
            wall_type = 'simple';
            
        end
        if strcmp(selection, 'reflected')
            wall_type = 'reflected';
            
        end

        textarea.Value = "New wall type for the next setup is " + selection;
    end

    
    function sliderValueChanged(slider)
        initial_number_of_agents = round(slider.Value);  
        textarea.Value = "Number of agents for the next setup is " + num2str(initial_number_of_agents);
    end

    function fieldSizeValueChanged(slider)
        initial_size_of_field = round(slider.Value);
        textarea.Value = "Size of the field for the next setup is " + num2str(initial_size_of_field);
    end


    function updateFieldInfinite()
        if isTimerRunning
            stop(t); 
            moveInfiniteButton.Text = 'Move Infinite';
            textarea.Value = ['Inifinite moves stopped, press "Move Infinite" to start infinite moves ' ...
                'or "Move Once" to move each agent once'];
        else 
            start(t); 
            moveInfiniteButton.Text = 'Stop';
            textarea.Value = 'Inifinite moves started until "Stop" will be pressed';
        end
        isTimerRunning = ~isTimerRunning;
    end
    
    function updateField(inp)
        try
            if (isTimerRunning && inp=="infinit") || (~isTimerRunning && inp=="once")
                [average_displacement, initial_agent_coordinates, average_step, field, OC, reached_border, all_dead] = moveObjectsOnce(field, OC, initial_agent_coordinates, wall_type_for_setup, step_size_random_setup);
                number_rounds = number_rounds + 1;
                

                if ~all_dead
                    speed_total = (speed_total + average_step);
                    average_speed_total = speed_total / number_rounds;

                    plot(plotAx, new_x_for_plot, average_speed_total, 'o', 'MarkerFaceColor', 'g', 'MarkerSize', 4);
                    plot(plotAx2, new_x_for_plot, average_displacement, 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 4);
                    new_x_for_plot = new_x_for_plot + 1;

                end

                   
                if ~reached_border && ~reached_border_first_time
                    textarea2.Value = "Number of rounds: " + num2str(number_rounds);
                else
                    if number_rounds_to_border ==0
                        number_rounds_to_border = number_rounds;
                        reached_border_first_time = true;
                    end
                    textarea2.Value = "Number of rounds to reach the border: " + num2str(number_rounds_to_border);
                end
                image(ax, uint8(field));
                if inp=="once" && ~all_dead
                    textarea.Value = "Moved once";
                elseif all_dead
                    textarea.Value = "All objects died, can not move anymore";
                end

            else
                error('MoveImpossibleException:ErrorID', 'Can not proceed with a single move, while infinit moves are running, stop them first!');
            end

        catch exception 
            textarea.Value = exception.message;
        end
    end
    

    function updateSetup()
        
        if isTimerRunning
            stop(t); 
        end


        [field, OC] = generated_and_returned(initial_size_of_field, initial_number_of_agents, generate_agents_in_random_places);
        image(ax, uint8(field));
        wall_type_for_setup = wall_type;
        step_size_random_setup = step_size_random;
        number_rounds = 0;
        number_rounds_to_border = 0;
        reached_border_first_time = false;
        initial_agent_coordinates = OC;
        new_x_for_plot = 0;
        isTimerRunning = false;

        average_speed_total = 0;
        speed_total = 0;


        textarea.Value = "Field size: " + num2str(initial_size_of_field) + ", number of Agents: " + ...
            num2str(initial_number_of_agents) + ", wall-type: " + wall_type_for_setup + ...
            ", step size is random: " + num2str(step_size_random_setup);
        textarea2.Value = "Number of rounds: " + num2str(number_rounds);
        moveInfiniteButton.Text = 'Move Infinite';
        % clear the plots
        delete(plotAx.Children);
        delete(plotAx2.Children);
        
        
    end


    %%%%%%%%%%%%% CALLBACKS END %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
