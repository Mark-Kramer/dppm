function file = track_filename(cfg)

params_str = nets_filename(cfg);
idx = strfind(params_str, '_');
params_str = [params_str(idx+1:end) '_' method2str(cfg.track.method)];
file  = ['track_' params_str];
    
end
