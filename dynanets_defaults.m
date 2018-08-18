function dynanets_defaults()
% Setup path variables and load required toolboxes

persistent initialized;
if isempty(initialized)
  initialized = false;
elseif initialized
  return;
end

global dynanets_default;
dynanets_default.codepath = mfilename('fullpath');
dynanets_default.codepath = fileparts(dynanets_default.codepath);
addpath(dynanets_default.codepath);

% Load local config if existing
try
    dynanets_defaults_local();
catch
    error('You need to define dynanets_default_local.m to init dynanets_default');
end
% Folder to store mat file results
if ~isfield(dynanets_default, 'outdatapath')      
    dynanets_default.outdatapath = ''; 
end
% Folder to store figs
if ~isfield(dynanets_default, 'outfigpath')
    dynanets_default.outfigpath = '';
end

% Check if the requested paths have been defined in the local config
requested_paths = {
    'dpptoolbox'     % Dynamic-plex-propagation Toolbox
    'bcttoolbox'     % Brain Connectivity Toolbox, https://sites.google.com/site/bctnet/
    'mmmtoolbox'     % CPM code
    'export_fig'     % Export_fig toolbox
};
for p = 1:length(requested_paths)
    if ~isfield(dynanets_default, requested_paths{p})
        error(['You need to define dynanets_default.' requested_paths{p} ' in dynanets_default_local.m']);
    end
end

% Load the necessary sub-folders and toolboxes
addpath([dynanets_default.codepath '/1-build'])
addpath([dynanets_default.codepath '/2-preprocess'])
addpath([dynanets_default.codepath '/3-infer'])
addpath([dynanets_default.codepath '/4-track'])
addpath([dynanets_default.codepath '/5-analyze'])
addpath(genpath([dynanets_default.codepath '/simulation']));
addpath(genpath(dynanets_default.dpptoolbox));
addpath(genpath(dynanets_default.bcttoolbox));
addpath(genpath(dynanets_default.mmmtoolbox));
addpath(genpath(dynanets_default.export_fig));

% remember that the function has executed in a persistent variable
initialized = true;

end
