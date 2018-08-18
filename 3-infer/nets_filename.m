function file = nets_filename(cfg)

params_str = prepdata_filename(cfg);
idx = strfind(params_str, '_');
params_str = [params_str(idx+1:end) '_' cfg.infer.method];

file = ['nets_' params_str];

end