function [ciL, ciU] = confidence_interval_boostrap(v, fun, varargin)
% [CIL, CIU] = CONFIDENCE_INTERVAL_BOOSTRAP(V, FUN, VARARGIN)
% Bootstraps error bars.

NBITERATION = 1000;

val = zeros(NBITERATION,1);
len = length(v);
for m = 1 : NBITERATION
    v0 = v(randsample(len,len,1));
    val(m) = fun(v0);
end
ciL = quantile(val, 0.025);
ciU = quantile(val, 0.975);

if nargin > 2 && strcmp(varargin{1}, 'relative')
    ciL = ciL - fun(v);
    ciU = ciU - fun(v);
end

end