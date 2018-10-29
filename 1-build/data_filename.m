function file = data_filename(cfg)

file = 'data';
if ~isempty(cfg.data.custom_str)
    file = [file '_' cfg.data.custom_str];
end

end