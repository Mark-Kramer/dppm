function file = data_filename(cfg)

params_str = ['pad[' num2str(-cfg.data.padding(1)) ',' num2str(cfg.data.padding(2)) ']'];
file = ['data_' params_str];


end