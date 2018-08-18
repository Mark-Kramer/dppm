function [data, xyz, OtherData] = sim_contract(Fs, n_nodes)
% Contract: Contracting network with different AR for subpopulations. Run 
% "Expand", then reverse time.

[data, xyz, OtherData] = sim_expand(Fs, n_nodes);
% Reverse the order of time.
data = data(end:-1:1,:);
OtherData.recruited = OtherData.recruited(end:-1:1,:);
OtherData.recruitment_order = OtherData.recruitment_order(end:-1:1);

end
