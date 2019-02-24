function file = track_filename(cfg, method_idx)

params_str = nets_filename(cfg);
idx = strfind(params_str, '_');
if isstruct(cfg.track.method)
    method = cfg.track.method;
elseif (iscell(cfg.track.method) && length(cfg.track.method) == 1)
    method = cfg.track.method{1};
elseif iscell(cfg.track.method) && length(cfg.track.method) > 1
    method = cfg.track.method{method_idx};
end
params_str = [params_str(idx+1:end) '_' method2str(method)];
file  = ['track_' params_str];
    
end
