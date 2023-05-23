function btngrp()
    % Create a UIFigure
    fig = uifigure('Name', 'Radio Button Group Example');

    % Create a button group
    buttonGroup = uibuttongroup(fig, 'Position', [20 20 200 60]);

    % Create radio buttons
    radioButton1 = uiradiobutton(buttonGroup, 'Text', 'Option 1', 'Position', [10 30 100 20]);
    radioButton2 = uiradiobutton(buttonGroup, 'Text', 'Option 2', 'Position', [10 10 100 20]);
    radioButton3 = uiradiobutton(buttonGroup, 'Text', 'Option 3', 'Position', [110 30 100 20]);

    % Set the default selection
    radioButton1.Value = true;

    % Set the callback function
    buttonGroup.SelectionChangedFcn = @(group, event) handleSelectionChange(group.SelectedObject.Text);

    % Function to handle selection change
    function handleSelectionChange(selection)
        disp(['Selected option: ' selection]);
    end
end
