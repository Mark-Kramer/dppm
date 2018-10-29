%% Setup params

global dynanets_default;
simscenarios = {'Expand'; 'Contract'; 'Split'; 'Merge'};
n_sim = 1; % select sim to plot

cfg = [];
cfg.data.patients = {'Simulation'};
cfg.preprocess.ref = '';
cfg.preprocess.filt = 'firls';
cfg.preprocess.band = [4 50]; 
cfg.infer.method = 'corr_0_lag';
params = {
    % DPP algo parameters
    struct('name', 'dpp', 'k', 2, 'm', 4);
    % MNM algo parameters
    struct('name', 'mmm', 'gamma', 0.01, 'omega', 1);
    % CPM algo parameter
    struct('name', 'cpm', 'min_clique', 4);
};
cfg.fig.type = 'pdf';
cfg.fig.mmmthresh = 4;

% prepare a nice colormap
cc_nowhite = colorcube;
cc_nowhite = cc_nowhite(1:end-1,:); % remove white
cc_nowhite = cc_nowhite(circshift(1:63,34),:); % search a nice color for value 1


%%
for sc = 1 : length(simscenarios)

    %% Compare different tracking methods
    cfg.data.simscenario = simscenarios{sc};

    data_path  = [dynanets_default.outfigpath cfg.data.patients{1} '_' cfg.data.simscenario '_' num2str(n_sim) '/'];
    fig_path   = [dynanets_default.outfigpath 'paper_fig/'];
    mkdir(fig_path);
    fname = ['sim_examples_' cfg.data.simscenario '_' num2str(n_sim)];

    load(sprintf([data_path data_filename(cfg) '.mat'], n_sim), 'OtherData');
    load(sprintf([data_path nets_filename(cfg) '.mat'], n_sim), 'nets');

    close all
    f = figure;


    %% Ground truth   
    n_nodes = 64;
    s_nodes = 48; % size of the circles
    xyz = flat_sq_grid_coord(n_nodes);
    if strcmp(cfg.data.simscenario, 'Expand')
        frames = [40 81 133 198 212]; % frame selection for C   
        itv = [20 40 60 80 100 120];
        isort = OtherData.recruitment_order;
        n_width = 15;
        n_step  = 10;
        sp = 1; %+ (sc - 1)*5*2;
        m = nan(sqrt(n_nodes));
        for n_start = 1:n_step:n_nodes-n_width
            m(isort(n_start:n_start+n_width-1)) = 1;
            ax1 = subplot(3, 5, sp); 
            scatter(xyz(:,1), xyz(:,2), s_nodes, m(:), 'filled');
            hold on
            scatter(xyz(:,1), xyz(:,2), s_nodes, zeros(n_nodes,1));
            caxis([1 2])
            axis image; axis ij;
            if sp == 1
                xlabel('Nodes'); xticks([1 8]);
                ylabel('Nodes'); yticks([1 8]);
                ax1.XRuler.Axle.LineStyle = 'none';  
                ax1.YRuler.Axle.LineStyle = 'none';
            else
                axis off;
            end
            title(['t \in [' num2str(itv(sp)) 's, ' num2str(itv(sp+1)-1) 's]'])
            
            ax2 = subplot(3, 5, sp+5);
            imagesc(~nets.C(isort,isort,frames(sp))) % Plot the corr matrix
            colormap(ax2, 'gray');
            axis image;
            if sp == 1
                xlabel('Nodes'); xticks([1 64]);
                ylabel('Nodes'); yticks([1 64]);
            else
                xticks([]);
                yticks([]);
            end
            sp = sp + 1;
        end
    elseif strcmp(cfg.data.simscenario, 'Contract')
        frames = [40 81 133 198 212]; % frame selection for C 
        itv = [20 40 60 80 100 120];
        isort = OtherData.recruitment_order;
        n_width = 15;
        n_step  = 10;
        sp = 5; %+ (sc - 1)*5*2;
        m = nan(sqrt(n_nodes));
        for n_start = 1:n_step:n_nodes-n_width
            m(isort(n_start:n_start+n_width-1)) = 1;
            ax1 = subplot(3, 5, sp); 
            scatter(xyz(:,1), xyz(:,2), s_nodes, m(:), 'filled');
            hold on
            scatter(xyz(:,1), xyz(:,2), s_nodes, zeros(n_nodes,1));
            caxis([1 2])
            axis image; axis ij;
            if sp == 1
                xlabel('Nodes'); xticks([1 8]);
                ylabel('Nodes'); yticks([1 8]);
                ax1.XRuler.Axle.LineStyle = 'none';  
                ax1.YRuler.Axle.LineStyle = 'none';
            else
                axis off;
            end
            title(['t \in [' num2str(itv(sp)) 's, ' num2str(itv(sp+1)-1) 's]'])
            
            ax2 = subplot(3, 5, sp+5);
            imagesc(~nets.C(isort,isort,frames(sp))) % Plot the corr matrix
            colormap(ax2, 'gray');
            axis image;
            if sp == 1
                xlabel('Nodes'); xticks([1 64]);
                ylabel('Nodes'); yticks([1 64]);
            else
                xticks([]);
                yticks([]);
            end
            sp = sp - 1;
        end
    elseif strcmp(cfg.data.simscenario, 'Split')
        frames = [40 81 133]; % frame selection for C  
        itv = [20 40 60 80];
        grp = {4:6,2:6; 2:8,2:6; [2:4 6:8],2:6};
        isort = OtherData.recruitment_order;
        sp = 1; %+ (sc - 1)*3*2;
        for i = 1:size(grp,1)
            m = nan(sqrt(n_nodes));
            m(grp{i,:}) = 1;
            ax1 = subplot(3, 3, sp);
            scatter(xyz(:,1), xyz(:,2), s_nodes, m(:), 'filled');
            hold on
            scatter(xyz(:,1), xyz(:,2), s_nodes, zeros(n_nodes,1));
            caxis([1 2])
            axis image; axis ij;
            if sp == 1
                xlabel('Nodes'); xticks([1 8]);
                ylabel('Nodes'); yticks([1 8]);
                ax1.XRuler.Axle.LineStyle = 'none';  
                ax1.YRuler.Axle.LineStyle = 'none';
            else
                axis off;
            end
            title(['t \in [' num2str(itv(sp)) 's, ' num2str(itv(sp+1)-1) 's]'])
            
            ax2 = subplot(3, 3, sp+3);
            imagesc(~nets.C(isort,isort,frames(sp))) % Plot the corr matrix
            colormap(ax2, 'gray');
            axis image;
            if sp == 1
                xlabel('Nodes'); xticks([1 64]);
                ylabel('Nodes'); yticks([1 64]);
            else
                xticks([]);
                yticks([]);
            end
            sp = sp + 1;
        end
    elseif strcmp(cfg.data.simscenario, 'Merge')
        frames = [40 81 133]; % frame selection for C  
        itv = [20 40 60 80];
        grp = {4:6,2:6; 2:8,2:6; [2:4 6:8],2:6};
        isort = OtherData.recruitment_order;
        sp = 3; %+ (sc - 1)*3*2;
        for i = 1:size(grp,1)
            m = nan(sqrt(n_nodes));
            m(grp{i,:}) = 1;
            ax1 = subplot(3, 3, sp); 
            scatter(xyz(:,1), xyz(:,2), s_nodes, m(:), 'filled');
            hold on
            scatter(xyz(:,1), xyz(:,2), s_nodes, zeros(n_nodes,1));
            caxis([1 2])
            axis image; axis ij;
            if sp == 1
                xlabel('Nodes'); xticks([1 8]);
                ylabel('Nodes'); yticks([1 8]);
                ax1.XRuler.Axle.LineStyle = 'none';  
                ax1.YRuler.Axle.LineStyle = 'none';
            else
                axis off;
            end
            title(['t \in [' num2str(itv(sp)) 's, ' num2str(itv(sp+1)-1) 's]'])
            
            ax2 = subplot(3, 3, sp+3);
            imagesc(~nets.C(isort,isort,frames(sp))) % Plot the corr matrix
            colormap(ax2, 'gray');
            axis image;
            if sp == 1
                xlabel('Nodes'); xticks([1 64]);
                ylabel('Nodes'); yticks([1 64]);
            else
                xticks([]);
                yticks([]);
            end
            sp = sp - 1;
        end
    end
    
    Fs = 500;
    ground_truth = nan(size(OtherData.recruited));
    ground_truth(OtherData.recruited) = 1;    
    subplot(3,4,9);
    t = 0:1/Fs:(size(ground_truth,1)-1)/Fs;
    t_sub = ismember(round(t,3), nets.t);
    imagescwithpcolor(t(t_sub), 1:size(ground_truth,2), ground_truth(t_sub,isort)');
    caxis([1 2])
    box on
    xticks([0 40 80 120])
    xlabel('Time (s)')
    yticks([1 64])
    ylabel('Nodes')
    title(['True ' simscenarios{sc}])
    
    
    %% DPPM
    cfg.track.method = params{1};
    load(sprintf([data_path track_filename(cfg) '.mat'], n_sim), 'track');
    stats = community_stats(track);
    subplot(3,4,10);
    imagescwithpcolor(nets.t, 1:size(stats.participation,2), stats.participation(:,isort)'); 
    caxis([1 2])
    box on
    xticks([0 40 80 120])
    yticks([1 64])
    title('DPPM (4,2)')


    %% CPM
    cfg.track.method = params{3};
    load(sprintf([data_path track_filename(cfg) '.mat'], n_sim), 'track');
    stats = community_stats(track);
    ax3 = subplot(3,4,11);
    imagescwithpcolor(nets.t, 1:size(stats.participation,2), stats.participation(:,isort)'); 
    box on
    xticks([0 40 80 120])
    yticks([1 64])
    title('CPM (4)')

    
    %% MMM
    cfg.track.method = params{2};
    load(sprintf([data_path track_filename(cfg) '.mat'], n_sim), 'track');
    
    % Find participation that lasts more than 1 step, and has at least 3 nodes.
    community_labels = unique(track.participation);
    final_participation = NaN(size(track.participation));
    counter_label = 1;
    for k=1:length(community_labels)
        [r,c] = find(track.participation==k);
        if length(unique(r))>1 && length(unique(c)) > cfg.fig.mmmthresh   
            i0 = find(track.participation==k);
            final_participation(i0) = counter_label;
            counter_label = counter_label+1;
        end
    end
    nc = histcounts(final_participation(:), 'BinMethod', 'integers');
    [~, inc] = max(nc);
    if inc ~= 1
        tmp = final_participation == 1;
        final_participation(final_participation == inc) = 1;
        final_participation(tmp) = inc;
    end
    ax3 = subplot(3,4,12);
    imagescwithpcolor(nets.t, 1:size(final_participation,2), final_participation(:,isort)'); 
    caxis([1 max(final_participation(:))+1])
    box on
    xticks([0 40 80 120])
    yticks([1 64])
    title('MMM (0.01,1)')

    
    %% Save
    colormap(cc_nowhite);
    set(gcf, 'color', 'w');
    export_fig(f, [fig_path fname '.' cfg.fig.type]);
    close(f)

end

