function color_electrode_map(d,nets)

  unique_d = unique(d);
  n = length(d);
  plot_color = zeros(1,n);
  for k=1:length(unique_d)
      plot_color(find(d == unique_d(k)))=k;
  end
  if size(nets.xy,2)==2
      scatter(nets.xy(:,1), nets.xy(:,2), 160*5, plot_color, 'filled')
  else
      scatter3(nets.xy(:,1), nets.xy(:,2), nets.xy(:,3), 160*5, plot_color, 'filled')
  end
  axis off
  
end