function main()
    
%   initial numbers 
    initial_number_of_agents = 50;
    initial_size_of_field = 100;
    number_rounds = 0;
    number_rounds_to_border = 0;
    reached_border_first_time = false;
    wall_type = "reflected";
    wall_type_for_setup = "reflected";





%     fig = uifigure('Name', 'Random Walks', 'AutoResizeChildren', 'off', 'ResizeFcn', @(src, evt)resizing(src, evt));
%     figSize = fig.Position(3:4);
%     textarea = uitextarea(fig);
%     textarea.Position = [10 fig.Position(2) 150 50];    
%     textarea.Value = 'Init message';
%     textarea.Editable = false;
    fig = uifigure('Name', 'Random Walks');
    ax = uiaxes(fig);
%     ax.Position = textarea.Position
    ax.Position = [80 10 fig.Position(3)-10 fig.Position(4)-10];
  
    [field, OC] = generated_and_returned(initial_size_of_field, initial_number_of_agents);

    image(ax, uint8(field));
    axis(ax, 'off'); 
%     disp(fig.Position);

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



    
%     textarea = uitextarea(fig);
%     textarea.Position = [figSize(1)-25 figSize(2)-10 10 20];    
%     textarea.Value = 'Init message';
%     textarea.Editable = false;


%     setupButton = uibutton(fig, 'Text', 'SETUP', 'Position', [figSize(1)-60 figSize(2)-60 150 60]);    
%     setupButton.ButtonPushedFcn = @(btn, event) updateSetup();



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
    
    slider2.Limits = [50, 1000];  
    slider2.Value = initial_size_of_field;  
    slider2.ValueChangedFcn = @(src, event) fieldSizeValueChanged(src);

    label2 = uilabel(fig);
    label2.Position = slider2.Position;
    label2.Position(2) = label2.Position(2) -70;
    label2.Position(4) = 60;
    label2.Text = 'Size of field';

    %%%%%% SLIDER FOR NUM AGENTS END %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    dropdown = uidropdown(fig, 'Items', ["reflected", "simple", "absorption"]);
    dropdown.Position = [label2.Position(1)+label2.Position(3)+20 10 100 50];
    
    
    dropdown.Value = "reflected";
    dropdown.Editable = 'on';
    dropdown.ValueChangedFcn = @(source, event) dropdownCallback(source);



% 'Value', 'Apple',...
% 'Editable', 'on',...
% 'Position', [84 204 100 20],...
% 'ValueChangedFcn', @(dd, event) fruitSelected(dd, label));
%   
% % function to call when option is selected (callback)
% function fruitSelected(dd, label)
%   
% % read the value from the dropdown
% val = dd.Value;
%       
% % set the text property of label
% label.Text = val;
% end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% CALLBACKS %%%%%%%%%%%%%%%%%%



% % function to call when option is selected (callback)
% function fruitSelected(dd, label)
%   
% % read the value from the dropdown
% val = dd.Value;
%       
% % set the text property of label
% label.Text = val;
% end
    function dropdownCallback(source)
        
        wall_type = source.Value;
        textarea.Value = "Wall type for next setup is " + wall_type;
        disp(['Selected Option: ' wall_type]);
    
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
                [field, OC, reached_border] = moveObjectsOnce(field, OC, wall_type_for_setup);
                number_rounds = number_rounds + 1;
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
                if inp=="once"
                    textarea.Value = "Moved once";
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
        textarea.Value = "Field size: " + num2str(initial_size_of_field) + ", number of Agents: " + num2str(initial_number_of_agents);

    end


    
    function resizing(src, evt)
        figPosition = src.Position;
        ax.Position = [10 10 figPosition(1) figPosition(2)]; 
        textarea.Position = [figPosition(1)-25 figPosition(2)-10 50 10];
       
    end

    %%%%%%%%%%%%% CALLBACKS END %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
