function [communities, vertices] = participation_to_struct(participation)

[n_win, n_nodes] = size(participation);
communities = cell(1, n_win);
vertices = cell(1, n_win);

for i = 1:n_win
    communities{i} = unique(participation(i,isfinite(participation(i,:))));
    vertices{i} = false(length(communities{i}), n_nodes);
    for j = 1:length(communities{i})
        vertices{i}(j,participation(i,:) == communities{i}(j)) = true;
    end
end

end