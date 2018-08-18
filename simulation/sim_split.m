function [data, xyz, OtherData] = sim_split(Fs, n_nodes)
% Scenario Split: one population splits into two other ones with different AR

duration = 100; % 5 * 20s periods
T = duration * Fs;

% Generate the coordinate on a flat grid
xyz = flat_sq_grid_coord(n_nodes);

% Prepare the shared AR activity for each of the 3 groups
% AR coefficients hardcoded here to make sure they've got different dynamics.
NB_GRP = 3;
phi1 = [ 0.95];
phi2 = [-0.95];
ar_noise_level = 1;
shared_activity = init_ar_activity(NB_GRP, T, phi1, phi2, ar_noise_level);

t_intervals = uint64(linspace(1, T, 5+1));
n_start = 1;
n_width = 15;
n_step  = 10;
grps = { n_start          : n_start+n_width-1;             % grp1 1:15
         n_start+n_step   : n_start+n_step+n_width-1;      % grp2 11:26
         n_start+2*n_step : n_start+2*n_step+n_width-1 };  % grp3 21:36
overlap = NaN; %[intersect(grps{1}, grps{2}), intersect(grps{3}, grps{2})];
cortex_activity = zeros(T, n_nodes);
recruited = false(T, n_nodes);
comb = zeros(T,n_nodes);
% Part 1 and Part 5: no communities
% Part 2,3,4 are defined in the following loop
for j = 2 : length(t_intervals) - 2
    t_start = t_intervals(j);
    t_end = t_intervals(j + 1) - 1;
    switch j
        case 2
            % Part 2: one community #2
            grp_idx = 2;
        case 3
            % Part 3: 3 communities #1,#2,#3 with #1,#2 having nodes with shared
            % activity and #2,#3 having nodes with shared activity
            grp_idx = [1, 2, 3];
        case 4
            % Part 4: 2 communities, #1 and #3 (#2 is off)
            grp_idx = [1, 3];
    end
    [shared, nbrs, combj] = make_grp_activity(t_start, t_end, grps(grp_idx), shared_activity(:,grp_idx), overlap);
    cortex_activity(t_start:t_end,nbrs) = cortex_activity(t_start:t_end,nbrs) + shared;
    recruited(t_start:t_end,nbrs) = true;
    comb(t_start:t_end,nbrs) = comb(t_start:t_end,nbrs) + combj;
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
OtherData.recruitment_order = 1:64;

end
