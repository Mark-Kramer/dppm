%%
global dynanets_default;
savepath = dynanets_default.outfigpath;


%% Create a 9 node network.

n = 9;

A = zeros(n);
A(1,4) = 1;
A(1,5) = 1;
A(2,3) = 1;
A(2,7) = 1;
A(2,5) = 1;
A(2,6) = 1;
A(3,6) = 1;
A(4,5) = 1;
A(4,8) = 1;
A(4,7) = 1;
A(5,6) = 1;
A(5,8) = 1;
A(5,9) = 1;
A(6,9) = 1;
A(7,8) = 1;
A(8,9) = 1;

A = A + transpose(A);
imagesc(A);

% Get the list of edges.
iupper = find(triu(ones(n),1));
upper_mask = zeros(n);
upper_mask(iupper) = 1;
edges  = find(A.*upper_mask);

% Specify the xy-coordinates.
xy(1,:) = [-1,1];
xy(2,:) = [ 0,1.5];
xy(3,:) = [ 1,1];
xy(4,:) = [-1.5, 0];
xy(5,:) = [0.25, 0.25];
xy(6,:) = [ 1.5, 0];
xy(7,:) = [-1, -1];
xy(8,:) = [ 0, -1.5];
xy(9,:) = [ 1, -1];

% Simulate 100 time steps, where at each step we drop 2 edges, randomly chosen.
n_noise_edges = 2;                          % Number of edges to remove.
T = 100;
nets = zeros(n,n,T);
for t=1:T
    % Choose two edges to remove.
    i0 = edges(randperm(length(edges)));
    remove_these = i0(1:n_noise_edges);
    
    % Make the edge-removed network.
    C0 = A;
    C0(remove_these) = 0;
    C0 = C0 .* transpose(C0);
    nets(:,:,t) = C0;
end

% Plot the results.
clr = cell(4,1);
clr{2} = rgb('red');
clr{6} = rgb('orange');
clr{7} = rgb('maroon');
clr{4} = rgb('purple');
clr{5} = rgb('navy');
clr{1} = rgb('blue');
clr{3} = rgb('green');
clr{8} = rgb('yellow');
clr{9} = rgb('black');

% Plot example DPP results for 10 time steps.
[track.vertices, track.communities] = dpp(nets, 2,4);
stats = community_stats(track);
P = stats.participation;

figure(1)
set(gcf, 'Position', [0,0,1000,300])
clf
for t=1:10
    subplot(3,10,t)
    x = xy(:,1);
    y = xy(:,2);
    t0= 10+t*1;
    G = graph(nets(:,:,t0));
    plot(G, 'XData', x, 'YData', y, 'MarkerSize', 12, 'NodeColor', [0.8,0.8,0.8], 'NodeLabel', {}, ...
        'EdgeColor', 'k', 'LineWidth', 6)
    hold on
    P0 = P(t0,:);
    unique_comm = unique(P0);
    for k=1:length(unique_comm)
        if isfinite(unique_comm(k))
            plot(x(P0 == unique_comm(k)), y(P0 == unique_comm(k)), 'o', 'MarkerSize', 12, ...
                'MarkerFaceColor', clr{mod(unique_comm(k),8)+1}, 'MarkerEdgeColor', clr{mod(unique_comm(k),8)+1})
            if t==1
                text(-5.9,0,'DPP(4,2)', 'FontSize', 16)
                text(-5.9,3,['N removed = ' num2str(n_noise_edges)], 'FontSize', 16)
                text(-8,-1,['Comm detected = ' num2str(stats.total_nb_com)])
            end
        end
    end
    axis off
end

% Plot example CPM results for 10 time steps.
clear track
[track.vertices, track.communities] = cpm(nets, 3);
stats = community_stats(track);
P = stats.participation;

for t=1:10
    subplot(3,10,10+t)
    x = xy(:,1);
    y = xy(:,2);
    t0= 10+t*1;
    G = graph(nets(:,:,t0));
    plot(G, 'XData', x, 'YData', y, 'MarkerSize', 12, 'NodeColor', [0.8,0.8,0.8], 'NodeLabel', {}, ...
        'EdgeColor', 'k', 'LineWidth', 6)
    hold on
    P0 = P(t0,:);
    unique_comm = unique(P0);
    for k=1:length(unique_comm)
        if isfinite(unique_comm(k))
            plot(x(P0 == unique_comm(k)), y(P0 == unique_comm(k)), 'o', 'MarkerSize', 12, ...
                'MarkerFaceColor', clr{mod(unique_comm(k),8)+1}, 'MarkerEdgeColor', clr{mod(unique_comm(k),8)+1})
        end
        if t==1
            text(-5.5,0,'CPM(3)', 'FontSize', 16)
            text(-8,-1,['Comm detected = ' num2str(stats.total_nb_com)])
        end
    end
    axis off
end

% Plot example MMM results for 10 time steps.
clear track
gamma = 1;
omega = 1;
[track.vertices, track.communities, track.edge_present, Q] = mmm(nets, gamma, omega);
stats = community_stats(track);
P = stats.participation;
fprintf([num2str(Q) '\n'])

for t=1:10
    subplot(3,10,20+t)
    x = xy(:,1);
    y = xy(:,2);
    t0= 10+t*1;
    G = graph(nets(:,:,t0));
    plot(G, 'XData', x, 'YData', y, 'MarkerSize', 12, 'NodeColor', [0.8,0.8,0.8], 'NodeLabel', {}, ...
        'EdgeColor', 'k', 'LineWidth', 6)
    hold on
    P0 = P(t0,:);
    unique_comm = unique(P0);
    for k=1:length(unique_comm)
        if isfinite(unique_comm(k))
            plot(x(P0 == unique_comm(k)), y(P0 == unique_comm(k)), 'o', 'MarkerSize', 12, ...
                'MarkerFaceColor', clr{mod(unique_comm(k),8)+1}, 'MarkerEdgeColor', clr{mod(unique_comm(k),8)+1})
        end
        if t==1
            text(-8,0,['MMM(' num2str(gamma) ',' num2str(omega) ')'], 'FontSize', 16)
            text(-8,-1,['Comm detected = ' num2str(length(unique(P(:))))])
            text(-8,-2,['Q = ' num2str(Q,3)])
        end
    end
    axis off
end

print('-dsvg', [savepath '/9-node-example/example_plots_noise_edges_' num2str(n_noise_edges) '.svg'])

%% Run the results for 100 repetitions.

for removed=0:3
    n_noise_edges = removed;                          % Number of edges to remove.

    K = 100;                                    % Number of repetitions
    nb_com = zeros(3,K);                        % Results to store.
    lifespan = zeros(3,K);
    proportion_participation = zeros(3,K);
    
    for k=1:K                                   % For each repetition,
        
        fprintf([num2str(k) '\n'])
        
        T = 100;                                % ... simulate 100 time steps,
        nets = zeros(n,n,T);
        for t=1:T
            
            % Choose two edges to remove.
            i0 = edges(randperm(length(edges)));
            remove_these = i0(1:n_noise_edges);
            
            C0 = A;
            C0(remove_these) = 0;
            C0 = C0 .* transpose(C0);
            nets(:,:,t) = C0;
            
        end
        
        % Do DPP.
        clear track
        [track.vertices, track.communities] = dpp(nets, 3,5);
        stats = community_stats(track);
        nb_com(1,k) = stats.total_nb_com;
        [~,oldest] = max(stats.lifespan);
        lifespan(1,k) = stats.lifespan(oldest) / T;
        % Compute the proportion of nodes in oldest comm at each time, then avg over time.
        proportion_participation(1,k) = length(find(stats.participation == oldest)) / (n*T);
        
        % Do CPM.
        clear track
        [track.vertices, track.communities] = cpm(nets, 3);
        stats = community_stats(track);
        nb_com(2,k) = stats.total_nb_com;
        [~,oldest] = max(stats.lifespan);
        lifespan(2,k) = stats.lifespan(oldest) / T;
        proportion_participation(2,k) = length(find(stats.participation == oldest)) / (n*T);
        
        % Do MMM.
        gamma = 1;
        omega = 1;
        clear track
        [track.vertices, track.communities, track.edge_present, Q] = mmm(nets, gamma, omega);
        stats = community_stats(track);
        fprintf([num2str(k) ' ' num2str(Q)])
        total_nb_com = length(unique(stats.participation));
        nb_com(3,k) = total_nb_com;
        lifespan_mmm = zeros(1, total_nb_com);
        for t = 1:T                                       % At each time step,
            c = stats.participation(t,:);                 % ... get communities at this time,
            uc = unique(c);                               % ... identify unique community labels at this time.
            lifespan_mmm(uc) = lifespan_mmm(uc) + 1;
        end
        [~,oldest] = max(lifespan_mmm);
        lifespan(3,k) = lifespan_mmm(oldest) / T;
        proportion_participation(3,k) = length(find(stats.participation == oldest)) / (n*T);
        
    end
    
    figure(2)
    set(gcf, 'Position', [0,0,800,200])
    clf
    
    subplot(1,3,1)
    mn = mean(nb_com,2);
    sem = std(nb_com, [], 2) / sqrt(K);
    bar(mn, 'FaceColor', [0.8,0.8,0.8])
    hold on
    for k=1:3
        plot([k,k], [mn(k)-2*sem(k), mn(k)+2*sem(k)], 'k', 'LineWidth', 2)
    end
    hold off
    set(gca, 'XTickLabel', {'DPP(3,5)'; 'CPM(3)'; ['MMM(' num2str(gamma) ',' num2str(omega) ')']})
    ylabel('Number of communities')
    set(gca, 'FontSize', 12)
    xlim([0.5 3.5])
    
    subplot(1,3,2)
    mn = mean(lifespan,2);
    sem = std(lifespan, [], 2) / sqrt(K);
    bar(mn, 'FaceColor', [0.8,0.8,0.8])
    hold on
    for k=1:3
        plot([k,k], [mn(k)-2*sem(k), mn(k)+2*sem(k)], 'k', 'LineWidth', 2)
    end
    hold off
    set(gca, 'XTickLabel', {'DPP(3,5)'; 'CPM(3)'; ['MMM(' num2str(gamma) ',' num2str(omega) ')']})
    ylabel('Lifespan (normalized)')
    set(gca, 'FontSize', 12)
    ylim([0 1.05])
    xlim([0.5 3.5])
    text(1,1.1, ['N removed = ' num2str(n_noise_edges)], 'FontSize', 16)
    
    subplot(1,3,3)
    mn = mean(proportion_participation,2);
    sem = std(proportion_participation, [], 2) / sqrt(K);
    bar(mn, 'FaceColor', [0.8,0.8,0.8])
    hold on
    for k=1:3
        plot([k,k], [mn(k)-2*sem(k), mn(k)+2*sem(k)], 'k', 'LineWidth', 2)
    end
    hold off
    set(gca, 'XTickLabel', {'DPP(3,5)'; 'CPM(3)'; ['MMM(' num2str(gamma) ',' num2str(omega) ')']})
    ylabel('% nodes in oldest community')
    set(gca, 'FontSize', 12)
    ylim([0 1.05])
    xlim([0.5 3.5])
    
    print('-depsc', [savepath '/9-node-example/noise_edges_' num2str(n_noise_edges) '.eps'])
end
