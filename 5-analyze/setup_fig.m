function setup_fig(cfg, ftitle)

if cfg.fig.usetitle
    title(ftitle, 'Interpreter', 'None');
else
    title([]);
end
if isfield(cfg.fig, 'fontsize')
    set(gca, 'fontsize', cfg.fig.fontsize);
end
set(gca,'LooseInset',get(gca,'TightInset'))

end