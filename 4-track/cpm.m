function [M, I] = cpm(nets, min_clq_size)
% Clique percolation method
% Based on Palla et al. 2005 and Palla et al. 2007

M = cell(1, size(nets,3)); % List of vertices in each community
I = cell(1, size(nets,3)); % Community labels
biggestId = 0;
dead_community = [];
dead_community_idx = []; 

for t = 1 : size(nets,3)
    % Step 1: find the communities (via CPM) at each time step
    M{t} = clique_communities(nets(:,:,t), min_clq_size);
    if t == 1
        if ~isempty(M{t})
            % For first time step, each get a different Id number
            I{t} = 1 : size(M{t}, 1);
            biggestId = max(I{t});
        end
        continue;
    elseif isempty(M{t})
        % Add the communities at t-1 to the dead list
        [dead_community, dead_community_idx] = ...
            update_dead_community(dead_community, dead_community_idx, M{t-1}, I{t-1});
        continue;
    else
        I{t} = zeros(1, size(M{t},1));
    end  

    
    % Step 2: Link communities through time using maximum overlap approach
    matched_D = false(1, length(I{t-1}));
    matched_E = false(1, length(I{t}));
    % Construct a graph consisting of the union of links from networks at steps t-1 and t
    uC = nets(:,:,t-1) | nets(:,:,t);
    % Extract the CPM community structure of this joint network
    V = clique_communities(uC, min_clq_size);
    % For every community in the joint system
    for k = 1 : size(V, 1)
        
        % Extract communities Dk at t-1 contained in the joint community
        Dk = [];
        for i = 1 : size(M{t-1},1)
            if all((M{t-1}(i,:) & V(k,:)) == M{t-1}(i,:))
                Dk = [Dk i]; %#ok<AGROW>
            end
        end

        % Extract the list of communities at t that are contained in the joint community
        Ek = [];
        for j = 1 : size(M{t},1)
            if all((M{t}(j,:) & V(k,:)) == M{t}(j,:))
                Ek = [Ek j]; %#ok<AGROW>
            end
        end

        % Compute the relative overlap between all pairs of communites Dik and Ejk
        Ck = zeros(length(Dk), length(Ek));
        for i = 1 : length(Dk)
            for j = 1 : length(Ek)
                Ck(i,j) = sum(M{t-1}(Dk(i),:) & M{t}(Ek(j),:)) / sum(M{t-1}(Dk(i),:) | M{t}(Ek(j),:));
            end
        end
        
        % Find the largest largest overlap 
        Cmax = max(Ck(:));
        if ~isempty(Cmax) && Cmax > 0
            [imax, jmax] = find(Ck == Cmax);
            if length(imax) > 1
                % Randomly pick one if several coms with highest overlap
                pick = randi(length(imax));
                imax = imax(pick);
                jmax = jmax(pick);
            end

            % Use the largest relative overlap to link communities across time
            % i.e. we attribute the id of Dk(imax) a Ek(jmax)
            I{t}(Ek(jmax)) = I{t-1}(Dk(imax));
            matched_D(Dk(imax)) = true;
            matched_E(Ek(jmax)) = true;
        end
    end
    
    % For all new born communities at t (= unmatched with t-1), try to find
    % dead communities in the past that correspond to them (trick to
    % address disappearing and reappearing communities)
    for born = find(~matched_E)
        for dead = 1 : size(dead_community, 1)
            if all(dead_community(dead, :) == M{t}(born,:))
                % If found in the past, reuse label, and remove from dead
                % community lists
                I{t}(born) = dead_community_idx(dead);
                matched_E(born) = true;
                dead_community_idx(dead) = []; %#ok<AGROW>
                dead_community(dead, :) = []; %#ok<AGROW>
                break;
            end
        end
    end
    % Add the communities at t-1 unmatched with t to the dead list
    [dead_community, dead_community_idx] = ...
        update_dead_community(dead_community, dead_community_idx, ...
                              M{t-1}(~matched_D,:), I{t-1}(~matched_D));
        
    % Create new labels for remaining unmatched communities at t
    I{t}(~matched_E) = biggestId + (1 : sum(~matched_E));
    biggestId = max(biggestId, max(I{t}));
end

end

function [dead_com, dead_idx] = update_dead_community(dead_com, dead_idx, dying_com, dying_idx)

if isempty(dying_com)
    return
end

for dying = 1 : size(dying_com, 1)
    dead = 1;
    while size(dead_com, 1) > 0 && dead <= size(dead_com, 1)
        if all(dead_com(dead, :) == dying_com(dying,:))
            % Already exists, keep the most recent label
            dead_idx(dead) = [];
            dead_com(dead, :) = [];
        else
            dead = dead + 1;
        end
    end
    dead_com = [dead_com; dying_com(dying,:)]; %#ok<AGROW>
    dead_idx = [dead_idx, dying_idx(dying)]; %#ok<AGROW>
end

end
