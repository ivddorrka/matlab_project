x = 1;  % x-coordinate starting value
y = 0;  % Initial value of y-coordinate

% Create a figure and axes
figure;
ax = axes;

% Set up the plot
plot(ax, x, y, 'o-');
xlabel('Time');
ylabel('Value');
title('Continuous Plot');

% Enter the loop to update the plot
while true
    % Generate or update the value of y
    y = randi(10);  % Replace with your own value
    
    % Increment x by 1
    x = x + 1;
    
    % Update the plot
    plot(ax, x, y, 'o-');
    drawnow;  % Update the plot immediately
    
    % Pause for a short duration (optional)
    pause(0.1);  % Adjust the duration as needed
end