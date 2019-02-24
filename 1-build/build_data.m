function cfg = build_data(cfg)
% Build the input data file

global dynanets_default;

for i = 1 : length(cfg.data.patients)
    pat = cfg.data.patients{i};
    for j = 1 : length(cfg.data.seizures{i})
        sz = cfg.data.seizures{i}{j};
        
        fprintf(['1-build: ' pat '_' sz '\n'])
        
        data_file = [dynanets_default.outdatapath '/' pat '_' sz '/' data_filename(cfg) '.mat'];
        if cfg.data.run || ~exist(data_file, 'file')
            fprintf('... building. \n')
            if ~exist([dynanets_default.outdatapath '/' pat '_' sz '/'], 'dir')
                mkdir([dynanets_default.outdatapath '/' pat '_' sz '/']);
            end
            if ~exist([dynanets_default.outfigpath '/' pat '_' sz '/fig/'], 'dir')
                mkdir([dynanets_default.outfigpath '/' pat '_' sz '/fig/']);
            end
            
            if strcmp(pat, 'Simulation')
                run_simulations(cfg.data.simscenario, sz);
            elseif isfield(cfg.data, 'build_fun') && ~isempty(cfg.data.build_fun)
                cfg.data.build_fun(data_file, pat, sz);
            end
        else
            fprintf(['... build file exists and not rebuilt: ' data_file '\n'])
        end
    end
end

end
