function [shared, nbrs, comb] = make_grp_activity(t_start, t_end, grps, shared_activity, overlap)

nbrs = unique([grps{:}]);
shared = zeros(t_end - t_start + 1, length(nbrs));
comb = zeros(t_end - t_start + 1, length(nbrs));

for g = 1 : length(grps)    
    grp = grps{g};
    for k = 1 : length(grp)
        if any(grp(k) == overlap)
            lag = 0;
        else
            lag = k;
        end
        shared(:,nbrs == grp(k)) = shared(:,nbrs == grp(k)) + circshift(shared_activity(t_start:t_end,g), lag);
        comb(:,nbrs == grp(k)) = comb(:,nbrs == grp(k)) + 1; % used for rescaling nodes belonging to multiple grps
    end
end

end
