function xyz = flat_sq_grid_coord(n_nodes)

xyz = zeros(n_nodes, 3);
coord = reshape(1:n_nodes, sqrt(n_nodes), sqrt(n_nodes))';
parfor i = 1:n_nodes
    [I,J] = find(coord == i);
    xyz(i,:) = [I J 0];
end

end
