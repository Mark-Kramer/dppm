function C = color_connectivity_community(C, participation)
% Assigned the community labels contained in the participation matrix into
% the connectivity matrix so that it can be used to produce a colored
% representation of the adjacency matrix based on community membership
% example: imagesc(color_connectivity_community(C, participation))

for i = 1 : length(participation)
    if ~isnan(participation(i))
        C(i,C(i,:) > 0) = participation(i);
    end
end

end