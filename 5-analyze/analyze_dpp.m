function stats = analyze_dpp(cfg, fig_path, pat, sz, nets, track)

xlim_new = [nets.t(1) nets.t(end)];
if isfield(cfg.fig, 'plotpadding')
    xlim_new = [xlim_new(1)+cfg.fig.plotpadding(1) xlim_new(end)-cfg.fig.plotpadding(2)];
end
ioi = xlim_new;
if isfield(cfg.fig, 'interval_of_interest') % applied after padding
    ioi = [ioi(1) + cfg.fig.interval_of_interest(1) ioi(2) - cfg.fig.interval_of_interest(2)];
end

cc_nowhite = colorcube;
cc_nowhite = cc_nowhite(1:end-1,:);

% Only consider times within the plot padding.
restricted_time_interval = find(nets.t >= xlim_new(1) & nets.t <= xlim_new(2));
time = nets.t(restricted_time_interval);

% Compute a bunch of summary statistics about the communities
stats = community_stats(track, restricted_time_interval);
if isfield(cfg.fig, 'custom_stats') && ~isempty(cfg.fig.custom_stats)
    stats = cfg.fig.custom_stats(cfg, pat, sz, nets, track, stats);
end

% Nb of nodes
n_nodes = size(nets.C,1);

% Load node sorting if specified (used to plot participation in a
% particular order for example)
if isfield(cfg.fig, 'custom_node_sort') && ~isempty(cfg.fig.custom_node_sort)
    node_sort = cfg.fig.custom_node_sort(cfg, pat, sz);
else
    node_sort = 1:n_nodes;
end


%--------------------------------------------------------------------------
% Density plot
f = figure;
plot_density(nets);
plot_startend_lines(ioi(1), ioi(2));
xlim(xlim_new);
setup_fig(cfg, [pat ' ' sz ' ' nets_filename(cfg)]);
print(f, cfg.fig.type, [fig_path '/density_' nets_filename(cfg)])
close(f);

%--------------------------------------------------------------------------
% Plot the number of coms through time
f = figure;
plot(time, stats.nb_com);
ylim([0, max(stats.nb_com)+1]);
xlabel('Time (s)')
ylabel('Number of Communities')
title([pat ' ' sz ' ' track_filename(cfg)], 'Interpreter', 'None')
plot_startend_lines(ioi(1), ioi(2));
print(f, cfg.fig.type, [fig_path '/community_nb_' track_filename(cfg)])
close(f);

%--------------------------------------------------------------------------
% Community census over time.
f = figure;
colormap(cc_nowhite)
community = stats.community;
imagescwithpcolor(time, (1:size(community,2)), community')
xlabel('Time (s)')
ylabel('Community #')
title([pat ' ' sz ' ' track_filename(cfg)], 'Interpreter', 'None')
plot_startend_lines(ioi(1), ioi(2));
print(f, cfg.fig.type, [fig_path '/community_census_' track_filename(cfg)])
close(f);

%--------------------------------------------------------------------------
% plot a hist of the lifespan of each community
f = figure;
lifespan = stats.lifespan;
if max(lifespan)>1
    hist(lifespan,1:max(lifespan))
else
    hist(lifespan)
end
xlabel('Lifespan (nb of windows)')
ylabel('Nb of community')
print(f, cfg.fig.type, [fig_path '/community_lifespan_' track_filename(cfg)])
close(f);

%--------------------------------------------------------------------------
% plot the size of the biggest community at any time point
f = figure;
siz = stats.com_size;
plot(time, max(siz,[],2));
xlabel('Time (s)')
ylabel('Size of the biggest community')
title([pat ' ' sz ' ' track_filename(cfg)], 'Interpreter', 'None')
axis tight
plot_startend_lines(ioi(1), ioi(2));
print(f, cfg.fig.type, [fig_path '/community_size_' track_filename(cfg)])
close(f);

%--------------------------------------------------------------------------
% Community participation over time.
f = figure;
participation = stats.participation;
colormap(cc_nowhite)
imagescwithpcolor(time, (1:n_nodes), participation(:,node_sort)')
xlabel('Time (s)')
ylabel('Node')
title([pat ' ' sz ' ' track_filename(cfg)], 'Interpreter', 'None')
plot_startend_lines(ioi(1), ioi(2));
export_fig(f, [fig_path '/community_participation_' track_filename(cfg) '.' cfg.fig.type(3:end)]);
close(f);

%--------------------------------------------------------------------------
% plot a heatmap to represent how many windows a node was part of the longest community 
f = figure;
loyalty = stats.loyalty;
[~, id] = max(lifespan);
[ia,~] = find(community == id);
plot_electrodes(nets.xy, loyalty(:,id));
title(['oldest community: ' num2str(id) ' between ' num2str(time(min(ia))) 's and ' num2str(time(max(ia))) 's'])
print(f, cfg.fig.type, [fig_path '/loyalty_map_' track_filename(cfg)])
close(f)

%--------------------------------------------------------------------------
% % Movie of the evolution of the communities
% movie_dynamic_communities([fig_path '/movie_DPP_' track_filename(cfg) '.mp4'],...
%     nets.C, track.vertices, track.communities, nets.xy, nets.t)
% close;
% f = figure;
% comm = extract_comm(nets.C, track.vertices, track.communities);
% circ = generate_circmat(nets.xy);
% k = 1;
% for t = xlim_new(1) : (xlim_new(2) - xlim_new(1)) / 16 : xlim_new(2)
%     tt = find(nets.t >= t, 1, 'first');
%     if isempty(tt)
%         continue
%     end
%     bendplot(nets.C(:,:,tt), comm{tt}, circ, nets.xy);
%     title(['Time ', num2str(nets.t(tt))]);
%     print(f, cfg.fig.type, [fig_path '/movie_DPP_' track_filename(cfg) '_snapshot' num2str(k)])
%     k = k + 1;
% end
% close(f)

end