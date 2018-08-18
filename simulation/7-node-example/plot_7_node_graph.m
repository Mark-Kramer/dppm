function plot_7_node_graph(nets, track, xy, clr, location)

  x = xy(:,1);
  y = xy(:,2);

  subplot(location)
  G = graph(nets(:,:,1));
  plot(G, 'XData', xy(:,1), 'YData', xy(:,2), 'MarkerSize', 12, 'NodeColor', [0.8,0.8,0.8], 'NodeLabel', {}, ...
      'EdgeColor', 'k', 'LineWidth', 6)
  hold on
  plot(x(find(track.vertices{1}(1,:))), y(find(track.vertices{1}(1,:))), 'o', 'MarkerSize', 12, ...
      'MarkerFaceColor', clr{track.communities{1}(1)}, 'MarkerEdgeColor', clr{track.communities{1}(1)})
  plot(x(find(track.vertices{1}(2,:))), y(find(track.vertices{1}(2,:))), 'o', 'MarkerSize', 12, ...
      'MarkerFaceColor', clr{track.communities{1}(2)}, 'MarkerEdgeColor', clr{track.communities{1}(2)})
  
  axis off

  subplot(location+1)
  G = graph(nets(:,:,2));
  plot(G, 'XData', xy(:,1), 'YData', xy(:,2), 'MarkerSize', 12, 'NodeColor', [0.8,0.8,0.8], 'NodeLabel', {}, ...
      'EdgeColor', 'k', 'LineWidth', 6)
  hold on
  plot(x(find(track.vertices{2}(1,:))), y(find(track.vertices{2}(1,:))), 'o', 'MarkerSize', 12, ...
      'MarkerFaceColor', clr{track.communities{2}(1)}, 'MarkerEdgeColor', clr{track.communities{2}(1)})
  axis off
  
end