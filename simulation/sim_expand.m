function [data, xyz, OtherData] = sim_expand(Fs, n_nodes)
% Expanding: Expanding network with different AR for subpopulations.

duration = 140; % 7 * 20s periods
T = duration * Fs;

% Generate the coordinate on a flat grid
xyz = flat_sq_grid_coord(n_nodes);

phi1 = [ 0.95];%0.6 + 0.1 * rand(1,n_nodes);  
phi2 = [-0.95];%-0.85 + 0.1 * rand(1,n_nodes);
ar_noise_level = 1;
shared_activity = init_ar_activity(n_nodes, T, phi1, phi2, ar_noise_level);

source_index = 1;                   % Index for the source.
geod = sqrt(sum((xyz - ones(n_nodes,1)*xyz(source_index,:)) .^ 2, 2));
[~, isort] = sort(geod, 'ascend');  % Sort the distance.

cortex_activity = zeros(T,n_nodes);
recruited = false(T,n_nodes);
t_intervals = uint64(linspace(1, T, 7+1));
n_start = 1;
n_width = 15;
n_step  = 10;
%overlap = arrayfun(@(x) x:x+n_width-n_step-1, n_start+n_step:n_step:n_nodes, 'UniformOutput', false);
%overlap = [overlap{:}]; overlap = isort(overlap(overlap <= 64));
overlap  = NaN;
comb = zeros(T,n_nodes);
% Part 1 and Part 7: no communities
% Part 2-6 are defined in the following loop
for j = 2 : length(t_intervals) - 2
    % At each interval we add a new grp lasting until the end of the sim
    t_start = t_intervals(j);
    t_end = t_intervals(end-1);
    grps = {isort(n_start:n_start+n_width-1)};
    [shared, nbrs, combj] = make_grp_activity(t_start, t_end, grps, shared_activity(:,j), overlap);
    cortex_activity(t_start:t_end,nbrs) = cortex_activity(t_start:t_end,nbrs) + shared;
    recruited(t_start:t_end,nbrs) = true;
    comb(t_start:t_end,nbrs) = comb(t_start:t_end,nbrs) + combj;
    n_start = n_start + n_step;
end
comb(comb == 0) = 1;
cortex_activity = cortex_activity ./ comb;

% Generate the *background* source activity (pink noise).
pink_bg_activity = zeros(T,n_nodes);
parfor n=1:n_nodes
    pink_bg_activity(:,n) = make_pink_noise_dynanets(0.75,T,1/Fs);
end
% Normalize activity from source and background to same scale.
cortex_activity(cortex_activity ~= 0) = zscore(cortex_activity(cortex_activity ~= 0));
pink_bg_activity = zscore(pink_bg_activity);
bg_noise_level = 1;
data = cortex_activity + bg_noise_level * pink_bg_activity;
OtherData.recruited = recruited;
OtherData.recruitment_order = isort;

end
