function stats = community_stats(track, interv)

if nargin == 1
    interv = 1:length(track.vertices);
elseif size(interv, 1) > 1
    interv = interv';
end
T = length(interv);

n = size(track.vertices{1}, 2);                 % nb of nodes.

total_nb_com = max([track.communities{:}]);
community = nan(T, total_nb_com);
com_size = zeros(T, total_nb_com);
loyalty = zeros(n, total_nb_com);
participation = nan(T,n);

for t = interv                                  % At each time step,                     
    c = track.communities{t};                   % ... get communities at this time,
    v = track.vertices{t};                      % ... get vertices at this time,
    uc = unique(c);                             % ... identify unique community labels at this time.
    t0 = t - interv(1) + 1;
    for k = 1:length(uc)                        % For each unique community at this time,
        community(t0,uc(k)) = uc(k);            % ... save it's presence at this time.
        rows = c == uc(k);                      % Find the list of nodes for community uc(k),
        vk = find(any(v(rows,:), 1));           % (can be spread over lines of v if coms have been merged),
        com_size(t0,uc(k)) = length(vk);         % ... count their number.
        loyalty(vk,uc(k)) = loyalty(vk,uc(k)) + 1; % Count how many times a node is associated with a com
        no_com = isnan(participation(t0,vk));    % Find nodes without a com
        update_com = [vk(no_com) ...            % ... or the nodes with a com assigned but of smaller size
                      vk(com_size(t0,uc(k)) > com_size(t0,participation(t0,vk(~no_com))))];
        participation(t0,update_com) = uc(k);    % ... and assign the new com for those two cases
    end
end

stats.total_nb_com = total_nb_com; % scalar, total nb of communities
stats.community = community; % T x C, label the presence of a community of each time pt
stats.lifespan = sum(isfinite(stats.community), 1); % C, nb of time pt each com is active
stats.nb_com = sum(isfinite(stats.community), 2); % T, nb of com active at each time pt
stats.com_size = com_size; % T x C, size of each com at each time pt
stats.com_max_size = max(com_size); % C, maximum size of a com
stats.com_cum_size = sum(com_size); % C, cumulative size of a com across time (gives an idea of the "volume" of a com across time and nodes)
stats.loyalty = loyalty; % N x C, nb of time pt each node was in each com
stats.norm_loyalty = loyalty ./ repmat(stats.lifespan, n, 1); % N x C, normalized loyalty by each com lifespan
stats.participation = participation; % T x N, label the participation of each node to a com at each time pt (if a node is member of several com at a given time, we label with the largest com)

end
