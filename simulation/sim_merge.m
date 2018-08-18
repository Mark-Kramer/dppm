function [data, xyz, OtherData] = sim_merge(Fs, n_nodes)
% Scenario Merge: two populations merge into one with different AR Run 
% "Split", then reverse time.

[data, xyz, OtherData] = sim_split(Fs, n_nodes);
% Reverse the order of time.
data = data(end:-1:1,:);
OtherData.recruited = OtherData.recruited(end:-1:1,:);
OtherData.recruitment_order = 1:64;

end
