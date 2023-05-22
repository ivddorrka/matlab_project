% MATLAB code for create a figure
fig = uifigure('Position', [100 100 300 275]);
  
% create a label
label = uilabel(fig, 'Position', [100 120, 120 40],...
'FontSize', 30,...
'FontWeight', 'bold');
  
% create a dropdownObject and pass the figure as parent
dropdownObject = uidropdown(fig,...
'Items', {'Mango','Guava','Orange','Apple'},...
'Value', 'Apple',...
'Editable', 'on',...
'Position', [84 204 100 20],...
'ValueChangedFcn', @(dd, event) fruitSelected(dd, label));
  
% function to call when option is selected (callback)
function fruitSelected(dd, label)
 
    % read the value from the dropdown
    val = dd.Value;
          
    % set the text property of label
    label.Text = val;
end