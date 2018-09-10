function run_simulations(scenario_name, sim_name)         
%% Possible scenarios to choose:
% Null:         no connectivity.
% Expand:       growing coupled region.
% Contract:     shrinking coupled region.
% Split:        a coupled region splits in two.
% Merge:        two coupled regions merge into one.

global dynanets_default;
outpath = dynanets_default.outdatapath;

Fs = 500;               % Simulation sampling frequency.
n_nodes = 64;           % Nb of simulated nodes

fprintf(['... running ' scenario_name ' simulation. \n'])
   
switch scenario_name
    case 'Null'
        [data, xyz, OtherData] = sim_null(Fs, n_nodes);
    case 'Expand'
        [data, xyz, OtherData] = sim_expand(Fs, n_nodes);
    case 'Contract'
        [data, xyz, OtherData] = sim_contract(Fs, n_nodes);
    case 'Split'
        [data, xyz, OtherData] = sim_split(Fs, n_nodes);
    case 'Merge'
        [data, xyz, OtherData] = sim_merge(Fs, n_nodes);
end

%% Save results to file
OtherData; %#ok<VUNUS>

% Arbitrary labels.
labels = cell(size(data,2),1);
parfor k=1:length(labels)
    labels{k} = num2str(k);
end

taxis = (1:size(data,1))/Fs;

% Format the save to match the "ECoG" mgh toolbox format.
ECoG.Position = [xyz(:,1), xyz(:,2), xyz(:,3)];
ECoG.Name = ['Simulation_' scenario_name];
ECoG.SamplingRate = Fs;
ECoG.Labels = labels;
ECoG.Data = data;
ECoG.Time = taxis; %#ok<STRNU>

Name = ['Simulation_' sim_name]; %#ok<NASGU>
Patient = 'Simulation'; %#ok<NASGU>
MatlabFile = [outpath '/Simulation_' sim_name '/data_pad[0,0].mat']; 

save(MatlabFile, 'Name', 'Patient', 'MatlabFile', 'ECoG', 'OtherData');

end
