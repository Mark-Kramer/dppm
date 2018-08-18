function plot_7_node_graph_for_all_tracking_methods(nets, xy, clr)

  % DPPM (1,3)
  [track.vertices, track.communities] = dpp(nets, 1,3);
  location = 161;
  plot_7_node_graph(nets, track, xy, clr, location)
  text(-3.5, 3, 'DPPM(3,1)', 'FontSize', 16)
  text(-5.4, -3, 't', 'FontSize', 16)
  text(-0.4, -3, 't+1', 'FontSize', 16)
  
  % CPM (3)
  location = 163;
  run_and_plot_CPM(nets, xy, clr, location, 3)
  
  % MMM (1,1)
  location = 165;
  gamma = 1;
  omega = 1;
  run_and_plot_MMM(nets, xy, clr, location, gamma, omega)
  
end