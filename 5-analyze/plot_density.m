function plot_density(nets, xl)
% Plot the density.

T = size(nets.C,3);             % Total # time points.
den = zeros(1,T);               % Output density variable.
for t=1:T                       % For each time index,
    C0 = squeeze(nets.C(:,:,t));% ... get the network,
    [den0] = density_und(C0);   % ... compute the density (requires BCT).
    den(t) = den0;              % ... save it.
end       

plot(nets.t, den);
axis tight
if nargin == 2
    xlim(xl);
end
xlabel('Time (s)')
ylabel('Density')


end