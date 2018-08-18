function cfg = track_nets(cfg)
% Track the functional nets through time

global dynanets_default;

method_list = cfg.track.method;
if isstruct(cfg.track.method)
    cfg.track.method = {cfg.track.method};
end
for m = 1 : length(method_list)
    cfg.track.method = method_list{m};
    track = method_list{m};
    
    for i = 1 : length(cfg.data.patients)
        pat = cfg.data.patients{i};
        for j = 1 : length(cfg.data.seizures{i})
            sz = cfg.data.seizures{i}{j};
                     
            data_file = [dynanets_default.outdatapath '/'  pat '_' sz '/' track_filename(cfg) '.mat'];
            if cfg.track.run || ~exist(data_file, 'file')
                fprintf(['4-track using ' track.name ': ' pat '_' sz ': ' nets_filename(cfg)])
                load([dynanets_default.outdatapath '/' pat '_' sz '/' nets_filename(cfg) '.mat'], 'nets');    % Load networks.
                
                switch track.name
                    case 'dpp'
                        fprintf([' ' num2str(track.m) ', ' num2str(track.k) '\n'])
                        [track.vertices, track.communities] = dpp(nets.C, track.k, track.m);
                    case 'cpm'
                        fprintf([' ' num2str(track.min_clique) '\n'])
                        [track.vertices, track.communities] = cpm(nets.C, track.min_clique);
                    case 'mmm'
                        fprintf([' ' num2str(track.gamma) ', ' num2str(track.omega) '\n'])
                        [track.vertices, track.communities, track.edge_present] = mmm(nets.C, track.gamma, track.omega);
                    otherwise
                        error('Unknown community tracking method.')
                end
                % Save results in a different file
                save(data_file, 'track');
            else
                fprintf(['... track file exists and not reprocessed: ' data_file '\n'])
            end
        end
    end
end
cfg.track.method = method_list;

end
