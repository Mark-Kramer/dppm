cfg = [];

% Build simulation data
cfg.data.run = true;
cfg.data.patients = {'Simulation'};
cfg.data.simscenario = 'Merge';         % Choice: 'Null', 'Expand', 'Contract', 'Split', 'Merge'
cfg.data.nbsim = 1;                     % Run a single simulation of one "seizure".
cfg.data.seizures = {{[cfg.data.simscenario '_1']}};
cfg.data.padding = [0 0];

% Preprocessing settings
cfg.preprocess.run = true;
cfg.preprocess.ref = '';                % Choice: '', 'cavg', 'bipolar'
cfg.preprocess.filt = 'firls';          % Linear-phase FIR filter
cfg.preprocess.band = [4 50];           % Bandpass

% Inference settings
cfg.infer.run = true;
cfg.infer.method = 'corr_0_lag';        % Choice: 'corr', 'corr_0_lag'
cfg.infer.windowsize = 1;               % Window size for net inference (s).
cfg.infer.windowstep = 0.5;             % Window overlap (s)
cfg.infer.smooth = false;               % Use vote to smooth networks in time
cfg.infer.scale  = true;                % Scale variance of correlation using all time.
    
%Network tracking through time, apply an example of DPP, MMM, and CPM.
cfg.track.run = true;
cfg.track.method = {
    % DPP algo parameters
    struct('name', 'dpp', 'k', 2, 'm', 4);
    
    % MMM algo parameters
    struct('name', 'mmm', 'gamma', 1, 'omega', 1);
    
    % CPM algo parameter
    struct('name', 'cpm', 'min_clique', 4);
    };

% Settings for figures
cfg.fig.run = true;
cfg.fig.type = '-djpeg';     % Choice: '-djpeg', '-depsc'
cfg.fig.plotpadding = [0 0]; % Used in xlim in some figs, e.g. [0 0], PADDING
cfg.fig.mmmthresh = 4;       % used to clean the mmm plots (minimum com size, 0 = all)
cfg.fig.analyze_seizures = true;
cfg.fig.custom_node_sort = @participation_sort_sim;
cfg.fig.custom_stats = @compare_true_recruitment_with_communities;
cfg.fig.analyze_population_fun = @population_result_sims;
cfg.fig.usetitle = true;
cfg.fig.fontsize = 12;

cfg = main_dynanets(cfg);
