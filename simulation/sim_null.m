function [data, xyz, OtherData] = sim_null(Fs, n_nodes)
% Null: Null case. Pink noise.

duration = 100;
T = duration * Fs;

% Generate the coordinate on a flat grid
xyz = flat_sq_grid_coord(n_nodes);

pink_bg_activity = zeros(T,n_nodes);
for n=1:n_nodes
  pink_bg_activity(:,n) = make_pink_noise_dynanets(0.75, T, 1 / Fs);
end
data = pink_bg_activity;
OtherData.recruited = [];

end
