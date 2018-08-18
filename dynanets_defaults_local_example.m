function dynanets_defaults_local()

global dynanets_default;

[~, host] = system('hostname');
host = strtrim(host);
if strcmp(host, 'My-MAC')
    dynanets_default.dpptoolbox = '/Users/me/analysis/toolboxes/dpp/';
    dynanets_default.bcttoolbox = '/Users/me/analysis/toolboxes/BCT';
    dynanets_default.mmmtoolbox = '/Users/me/analysis/toolboxes/GenLouvain-2.1';
    dynanets_default.outdatapath = '/Volumes/Data/Output_Data/';
    dynanets_default.outfigpath = '/Volumes/Data/Output_Data/';
elseif strcmp(host, 'My-PC')
    dynanets_default.dpptoolbox = 'C:\Users\me\analysis\toolboxes\dpp\';
    dynanets_default.bcttoolbox = 'C:\Users\me\analysis\toolboxes\BCT';
    dynanets_default.mmmtoolbox = 'C:\Users\me\analysis\toolboxes\GenLouvain-2.1';
    dynanets_default.outdatapath = 'C:\Users\me\analysis\Output_Data\';
    dynanets_default.outfigpath = 'C:\Users\me\analysis\Output_Data\';
end

end
