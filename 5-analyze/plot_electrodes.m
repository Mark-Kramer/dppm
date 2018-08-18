function plot_electrodes(xy, measure)

if size(xy,2)==2
    scatter(xy(:,1), xy(:,2), 160*5, measure, 'filled');
else
    scatter3(xy(:,1), xy(:,2), xy(:,3), 160*5, measure, 'filled');
end
xlabel('Electrode position (cm)')
ylabel('Electrode position (cm)')
zlabel('Electrode position (cm)')
colorbar

end