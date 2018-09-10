function cfg = analyze_nets(cfg)
% Plot all kind of cool results

close all;
global dynanets_default;

if ~cfg.fig.run
    return
end

method_list = cfg.track.method;
for m = 1 : length(method_list)
    cfg.track.method = method_list{m};
    switch cfg.track.method.name
        case 'dpp'
            save_name = [num2str(cfg.track.method.m) '_' num2str(cfg.track.method.k)];
        case 'mmm'
            save_name = [num2str(cfg.track.method.gamma) '_' num2str(cfg.track.method.omega)];
        case 'cpm'
            save_name = num2str(cfg.track.method.min_clique);
    end
    
    for i = 1 : length(cfg.data.patients)
        pat = cfg.data.patients{i};
        %population_results = [];
        
        if cfg.fig.analyze_seizures
            % analyze each seizure
            for j = 1 : length(cfg.data.seizures{i})
                sz = cfg.data.seizures{i}{j};
                
                fprintf(['5-analyze: ' pat '_' sz ': ' track_filename(cfg) '\n'])
                mkdir([dynanets_default.outfigpath '/' pat '_' sz '/fig/']);
                
                % Load networks
                load([dynanets_default.outdatapath '/' pat '_' sz '/' nets_filename(cfg) '.mat'], 'nets');
                % Load community tracking
                load([dynanets_default.outdatapath '/' pat '_' sz '/' track_filename(cfg) '.mat'], 'track');
                fig_path = [dynanets_default.outfigpath '/' pat '_' sz '/fig'];
                
                if strcmp(cfg.track.method.name, 'mmm')
                    % Find participation that lasts at least 2 step, and has at least cfg.fig.mmmthresh nodes.
                    track = filter_small_communities(track, 2, cfg.fig.mmmthresh);
                end
                
                population_results(j) = analyze_dpp(cfg, fig_path, pat, sz, nets, track); %#ok<AGROW>
            end
        end
        
        % Save the per-patient results and run the overall analyze by patient
        if ~isempty(cfg.fig.analyze_population_fun)
            scenario = cfg.data.simscenario;
            data_file = [dynanets_default.outdatapath '/' pat '_' scenario '_population_results/' cfg.track.method.name '_' save_name '_' nets_filename(cfg) '.mat'];
            if ~exist(data_file, 'file')
                mkdir([dynanets_default.outdatapath '/' pat '_' scenario '_population_results/']);
                mkdir([dynanets_default.outfigpath  '/' pat '_' scenario '_population_results/fig/']);
            end
            if isempty(population_results)
                load(data_file, 'population_results');
            else
                save(data_file, 'population_results');
            end
            
            fig_path = [dynanets_default.outfigpath '/' pat '_' scenario '_population_results/fig'];
            fig_file = [fig_path '/' cfg.track.method.name '_' save_name '_' nets_filename(cfg)];
            cfg = cfg.fig.analyze_population_fun(cfg, fig_file, population_results);
        end
    end
end

cfg.track.method = method_list;

end

