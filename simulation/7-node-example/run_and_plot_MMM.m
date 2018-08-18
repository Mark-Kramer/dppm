function run_and_plot_MMM(nets, xy, clr, location, gamma, omega)

  T = size(nets,3);
  N = size(nets,1);

  % ... is not deterministic, so run it 100 times, and average the participation.
  participation = zeros(100,T,N);
  Q = zeros(100,1);
  for repeats=1:100
      clear track
      [track.vertices, track.communities, track.edge_present, Q0] = mmm(nets, gamma, omega);
      stats = community_stats(track);
      participation(repeats, :,:) = stats.participation;
      Q(repeats) = Q0;
  end
  % ... then, define particpation by examining consistency of community assignment over repeats.
  P = zeros(T,N);
  for each_time=1:T
      for each_node=1:N
          P0 = squeeze(participation(:,each_time,each_node));
          if length(unique(P0))==1      % Then this node gets only one comm assignment over all repeats.
              P(each_time,each_node) = unique(P0);
          else                          % Then this node gets more than one comm assignment.
              P(each_time,each_node) = mean(P0);
          end
      end
  end
  
  communities = unique(P(:));                       % Get unique communities, including mixes.
  n_integer_communities = length(find(mod(communities,1)==0));% Get only unmixed communities.
  fprintf(['number of (unmixed) communities ' num2str(n_integer_communities) '\n'])
  x = xy(:,1);
  y = xy(:,2);
  
  for t=1:2                                         % For the two time points,
      plt=subplot(location + (t-1));                % ... set subplot,
      G = graph(nets(:,:,t));                       % ... get the network and plot it.
      plot(G, 'XData', x, 'YData', y, 'MarkerSize', 12, 'NodeColor', [0.8,0.8,0.8], ...
          'NodeLabel', {}, 'EdgeColor', 'k', 'LineWidth', 6)
      hold on
      for k=1:length(communities)                   % For each community, color the nodes,
          if mod(communities(k),1) ~= 0             % ... if a com label is ~integer,
              scale1 = 1-(communities(k)-floor(communities(k)));
              scale2 = 1-(ceil(communities(k))-communities(k));
              clr1 = clr{floor(communities(k))} * scale1;
              clr2 = clr{ ceil(communities(k))} * scale2;
              clr0 = (clr1 + clr2);                 % ... make color an average of the 2 com to which it belongs.
          else
              clr0 = clr{communities(k)};           % Otherwise, give com a standard color.
          end
          plot(x(find(P(t,:)==communities(k))), y(find(P(t,:)==communities(k))), 'o', 'MarkerSize', 12, ...
              'MarkerFaceColor', clr0, 'MarkerEdgeColor', clr0)
      end
      axis off
      cmap = colormap;
      cmap(:,1) = linspace(1,0,64);
      cmap(:,2) = linspace(0,1,64);
      cmap(:,3) = 0;
      colormap(cmap);
      originalSize = get(gca, 'Position');
      colorbar('Ticks', [0 1], 'TickLabels', {'C_1'; 'C_2'})
      set(plt, 'Position', originalSize);          % Resize image after colorbar.
      
  end
  text(-3.5, 3, ['MMM(' num2str(gamma) ','  num2str(omega) '), Q=' num2str(mean(Q),2), ', N=' num2str(n_integer_communities)], 'FontSize', 12)
  text(-5.4, -3, 't', 'FontSize', 16)
  text(-0.4, -3, 't+1', 'FontSize', 16)