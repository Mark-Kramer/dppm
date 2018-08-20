function cfg = preprocess_data(cfg)
% Preprocess the data

global dynanets_default;

for i = 1 : length(cfg.data.patients)
    pat = cfg.data.patients{i};
    for j = 1 : length(cfg.data.seizures{i})
        sz = cfg.data.seizures{i}{j};
        
        fprintf(['2-preprocess: ' pat '_' sz '\n']);
        
        data_file = [dynanets_default.outdatapath '/' pat '_' sz '/' prepdata_filename(cfg) '.mat'];
        if cfg.preprocess.run || ~exist(data_file, 'file')
            fprintf('... reading in the build file. \n')
            s = load([dynanets_default.outdatapath '/' pat '_' sz '/' data_filename(cfg) '.mat']);
            
            % Reference data
            if strcmp(cfg.preprocess.ref, 'cavg') == 1
                fprintf('... common average reference the data. \n')
                re_referenced_data = commonAvgRef(s.ECoG.Data);
                diagnostics_car(s.ECoG.Time, s.ECoG.Data, re_referenced_data, [dynanets_default.outfigpath '/' pat '_' sz '/fig/referencing_diagnositics']);
                s.ECoG.Data = re_referenced_data;
                clear re_referenced_data; 
            end
            
            if strcmp(cfg.preprocess.ref, 'bipolar') && strcmp(pat, 'Simulation') == 1
                fprintf('... bipolar reference the data. \n')
                re_referenced_data = bipolarRefSimulation(s.ECoG.Data);
                s.ECoG.Data     = re_referenced_data;                                  %... replace data in Seizure structure with re-referenced data.
                s.ECoG.Position = s.ECoG.Position(1:end-1,:);
                clear re_referenced_data;
            end
            
            % Filter data
            if strcmp(cfg.preprocess.filt, 'firls') == 1
                fprintf('... filtering the data. \n')
                fs = s.ECoG.SamplingRate; 
                filtered_data = lsfilter(s.ECoG.Data, fs, cfg.preprocess.band);
                diagnostics_filter(s.ECoG.Time, s.ECoG.Data, filtered_data, fs, cfg.preprocess.band, [dynanets_default.outfigpath '/' pat '_' sz '/fig/filter_diagnositics']);
                s.ECoG.Data   = filtered_data;
                clear filtered_data;
            end
            
            % Save preprocessed data in a different file
            fprintf('... saving the preprocessed data. \n')
            save(data_file, '-struct', 's');
            clear s;
        else
            fprintf(['... preprocess file exists and not reprocessed: ' data_file '\n'])
        end
    end
end

end
