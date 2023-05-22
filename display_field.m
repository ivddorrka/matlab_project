function display_field(field)
    
    fig = uifigure('Name', 'Random Walks');
    figSize = fig.Position(3:4);

    ax = uiaxes(fig);
    ax.Position = [0 0 figSize(1)-20 figSize(2)-20]; 

%     [field, ~, ~] = generated_and_returned(200);

    image(ax, uint8(field));
    axis(ax, 'off'); % Turn off the axis labels and ticks
end