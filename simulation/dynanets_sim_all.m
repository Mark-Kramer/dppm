simscenarios = {'Expand'; 'Contract'; 'Split'; 'Merge'};     %Choice: 'Null', 'Expand', 'Contract', 'Split', 'Merge'
nbsim        = 100;

for i_scenario = 1:length(simscenarios)
%i_scenario=5;
    cfg = [];

    % Build simulation data
    cfg.data.run = true;
    cfg.data.patients = {'Simulation'};
    cfg.data.simscenario = simscenarios{i_scenario};     %Choice: 'Null', 'Expand', 'Contract', 'Split', 'Merge'
    % to run a series of sim, use that code instead:
    cfg.data.nbsim = nbsim;
    seizure = cell(cfg.data.nbsim,1);
    for k=1:cfg.data.nbsim
        seizure{k,1} = strcat(cfg.data.simscenario, '_', num2str(k));
    end
    cfg.data.seizures = {seizure};
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
    
    %Network tracking through time
    cfg.track.run = true;
    cfg.track.method = {
        % DPP algo parameters
        struct('name', 'dpp', 'k', 2, 'm', 4);
        struct('name', 'dpp', 'k', 3, 'm', 5);
        
        % MMM algo parameters
        struct('name', 'mmm', 'gamma', 2, 'omega', 10);
        struct('name', 'mmm', 'gamma', 2, 'omega', 5);
        struct('name', 'mmm', 'gamma', 2, 'omega', 2);
        struct('name', 'mmm', 'gamma', 2, 'omega', 1);
        struct('name', 'mmm', 'gamma', 2, 'omega', 0.5);
        struct('name', 'mmm', 'gamma', 2, 'omega', 0.1);
        struct('name', 'mmm', 'gamma', 2, 'omega', 0.01);
        
        struct('name', 'mmm', 'gamma', 1, 'omega', 10);
        struct('name', 'mmm', 'gamma', 1, 'omega', 5);
        struct('name', 'mmm', 'gamma', 1, 'omega', 2);
        struct('name', 'mmm', 'gamma', 1, 'omega', 1);
        struct('name', 'mmm', 'gamma', 1, 'omega', 0.5);
        struct('name', 'mmm', 'gamma', 1, 'omega', 0.1);
        struct('name', 'mmm', 'gamma', 1, 'omega', 0.01);
        
        struct('name', 'mmm', 'gamma', 0.5, 'omega', 10);
        struct('name', 'mmm', 'gamma', 0.5, 'omega', 5);
        struct('name', 'mmm', 'gamma', 0.5, 'omega', 2);
        struct('name', 'mmm', 'gamma', 0.5, 'omega', 1);
        struct('name', 'mmm', 'gamma', 0.5, 'omega', 0.5);
        struct('name', 'mmm', 'gamma', 0.5, 'omega', 0.1);
        struct('name', 'mmm', 'gamma', 0.5, 'omega', 0.01);
        
        struct('name', 'mmm', 'gamma', 0.1, 'omega', 10);
        struct('name', 'mmm', 'gamma', 0.1, 'omega', 5);
        struct('name', 'mmm', 'gamma', 0.1, 'omega', 2);
        struct('name', 'mmm', 'gamma', 0.1, 'omega', 1);
        struct('name', 'mmm', 'gamma', 0.1, 'omega', 0.5);
        struct('name', 'mmm', 'gamma', 0.1, 'omega', 0.1);
        struct('name', 'mmm', 'gamma', 0.1, 'omega', 0.01);
        
        struct('name', 'mmm', 'gamma', 0.01, 'omega', 10);
        struct('name', 'mmm', 'gamma', 0.01, 'omega', 5)
        struct('name', 'mmm', 'gamma', 0.01, 'omega', 2);
        struct('name', 'mmm', 'gamma', 0.01, 'omega', 1);
        struct('name', 'mmm', 'gamma', 0.01, 'omega', 0.5);
        struct('name', 'mmm', 'gamma', 0.01, 'omega', 0.1);
         struct('name', 'mmm', 'gamma', 0.01, 'omega', 0.01);
        
        % CPM algo parameter
        struct('name', 'cpm', 'min_clique', 3);
        struct('name', 'cpm', 'min_clique', 4);
        struct('name', 'cpm', 'min_clique', 5);
        struct('name', 'cpm', 'min_clique', 6);
        };

    % Settings for figures
    cfg.fig.run = true;
    cfg.fig.type = '-djpeg';     % Choice: '-djpeg', '-depsc'
    cfg.fig.plotpadding = [0 0]; % Used in xlim in some figs, e.g. [0 0], PADDING
    cfg.fig.mmmthresh = 4; % used to clean the mmm plots (minimum com size, 0 = all)
    cfg.fig.analyze_seizures = true;
    cfg.fig.custom_node_sort = @participation_sort_sim;
    cfg.fig.custom_stats = @compare_true_recruitment_with_communities;
    cfg.fig.analyze_population_fun = @population_result_sims;
    cfg.fig.usetitle = true;
    cfg.fig.fontsize = 12;
    
    cfg = main_dynanets(cfg);
    
    %clearvars -global -except simscenarios nbsim i_scenario
    
end
