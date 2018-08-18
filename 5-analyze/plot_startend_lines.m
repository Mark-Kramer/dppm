function plot_startend_lines(t_start, t_end)

hold on
plot([t_start t_start], ylim, 'r-')
plot([t_end t_end], ylim, 'r-')

end