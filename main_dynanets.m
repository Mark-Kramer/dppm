function cfg = main_dynanets(cfg)

dynanets_defaults;

% Simulate or load the data from edf/ns5 and save to .mat
cfg = build_data(cfg);

% Preprocess data and save to .mat
cfg = preprocess_data(cfg);

% Infer functional networks
cfg = infer_nets(cfg);

% Track networks
cfg = track_nets(cfg);

% Analyze results
cfg = analyze_nets(cfg);

end
