function main()
    
%   initial numbers 
    initial_number_of_agents = 50;
    initial_size_of_field = 100;
    number_rounds = 0;
    number_rounds_to_border = 0;
    reached_border_first_time = false;
    wall_type = "simple";
    wall_type_for_setup = "simple";
    step_size_random_setup = false;
    step_size_random = false;

    average_speed_total = 0;
    speed_total = 0;





%     fig = uifigure('Name', 'Random Walks', 'AutoResizeChildren', 'off', 'ResizeFcn', @(src, evt)resizing(src, evt));

    fig = uifigure('Name', 'Random Walks');
    ax = uiaxes(fig);
    ax.Position = [80 10 fig.Position(3)-10 fig.Position(4)-10];
  
    plotAx = uiaxes(fig);
    plotAx.NextPlot = 'add';
    plotAx.Position = [ax.Position(1)+ax.Position(3) 115 round(ax.Position(3)/3) round(ax.Position(3)/3)];
%     plotAx.XLim = [-100 100];
%     plotAx.YLim = [-100 100];
%     plotAx.XTick = -100:20:100;
%     plotAx.YTick = -100:20:100;
    plotAx.Box = 'on';
%     plotAx.GridAlpha = 0.4;

    [field, OC] = generated_and_returned(initial_size_of_field, initial_number_of_agents);

    image(ax, uint8(field));
    axis(ax, 'off'); 

    textarea = uitextarea(fig);
    textarea.InnerPosition = [10 fig.Position(2)+round(fig.Position(2)/2) 70 40];    
    textarea.Value = 'Init message';
    textarea.Editable = false;

    textarea2 = uitextarea(fig);
    textarea2.InnerPosition = [10 textarea.Position(2)-50 70 40];   
    txt2val = "Number of rounds: " + num2str(number_rounds);
    textarea2.Value = txt2val;
    textarea2.Editable = false;

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
    %%%%%%%%%% Random-step choice END %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% CALLBACKS %%%%%%%%%%%%%%%%%%

    function changeCB_Value(checkBox)
        if checkBox.Value
            step_size_random = true;
            step_size_random_setup = true;
        else
            step_size_random = false;
            step_size_random_setup = false;
        end
    end

    function handleSelectionChange(selection)
        if strcmp(selection, 'absorption')
            wall_type = 'absorption';
            wall_type_for_setup = 'absorption';
        end
        if strcmp(selection,'simple')
            wall_type = 'simple';
            wall_type_for_setup = 'simple';
        end
        if strcmp(selection, 'reflected')
            wall_type = 'reflected';
            wall_type_for_setup = 'reflected';
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
            moveInfiniteButton.Text = 'Start';
            textarea.Value = ['Inifinite moves stopped, press "Start" to start infinite moves ' ...
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
                [average_step, field, OC, reached_border, all_dead] = moveObjectsOnce(field, OC, wall_type_for_setup, step_size_random_setup);
                number_rounds = number_rounds + 1;
                if ~all_dead
                    speed_total = (speed_total + average_step);
                    average_speed_total = speed_total / number_rounds;
%                     children = plotAx.Children; 
%                     for i=1:numel(children)
%                         children(i).XData = children(i).XData + 1;
%                     end
%                     plot(plotAx, -100, yCoord, 'o', 'MarkerFaceColor', 'g', 'MarkerSize', 7);
                    plot(plotAx, -100, average_speed_total, 'o', 'MarkerFaceColor', 'g', 'MarkerSize', 7);
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
                error('MoveImpossibleException:ErrorID', 'Can not proceed with a single move!');
            end

        catch exception 
            textarea.Value = exception.message;
        end
    end
    

    function updateSetup()
        
        if isTimerRunning
            stop(t); 
        end

        [field, OC] = generated_and_returned(initial_size_of_field, initial_number_of_agents);
        image(ax, uint8(field));
        wall_type_for_setup = wall_type;
        step_size_random_setup = step_size_random;
        textarea.Value = "Field size: " + num2str(initial_size_of_field) + ", number of Agents: " + ...
            num2str(initial_number_of_agents) + ", wall-type: " + wall_type_for_setup;

    end


    %%%%%%%%%%%%% CALLBACKS END %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
