function cfg = population_result_sims(cfg, fig_file, population_results)

% Get the variables in useful format
number_of_communites_in_recruitment = [population_results.number_of_communites_in_recruitment];
PPV = [population_results.PPV];
NPV = [population_results.NPV];
FDR = [population_results.FDR];
FOR = [population_results.FOR];
sensitivity = [population_results.sensitivity];
specificity = [population_results.specificity];

%%%% Plot the community vs recruitment results for all data.

f = figure;
set(gcf, 'Position', [10,500,1400,250])
subplot(1,7,1)
bars = (0:1:50);
[h,b] = hist(number_of_communites_in_recruitment, bars);
bar(b,h/length(number_of_communites_in_recruitment), 'FaceColor', [0.8,0.8,0.8]);
xlabel('# communities in recruitment')
title('(all comm)')
ylabel('Proportion')
set(gca, 'FontSize', cfg.fig.fontsize)
xlim([min(bars) max(bars)])

subplot(1,7,2)
bars = (0:0.1:1);
[h,b] = hist(PPV, bars);
bar(b,h/length(PPV), 'FaceColor', [0.8,0.8,0.8]);
xlabel('PPV')
title('(biggest comm)')
ylabel('Proportion')
set(gca, 'FontSize', cfg.fig.fontsize)
xlim([-0.1 1.1])

subplot(1,7,3)
bars = (0:0.1:1);
[h,b] = hist(FDR, bars);
bar(b,h/length(FDR), 'FaceColor', [0.8,0.8,0.8]);
xlabel('FDR')
title('(biggest comm)')
ylabel('Proportion')
set(gca, 'FontSize', cfg.fig.fontsize)
xlim([-0.1 1.1])

subplot(1,7,4)
bars = (0:0.1:1);
[h,b] = hist(FOR, bars);
bar(b,h/length(FOR), 'FaceColor', [0.8,0.8,0.8]);
xlabel('FOR')
title('(biggest comm)')
ylabel('Proportion')
set(gca, 'FontSize', cfg.fig.fontsize)
xlim([-0.1 1.1])

subplot(1,7,5)
bars = (0:0.1:1);
[h,b] = hist(NPV, bars);
bar(b,h/length(NPV), 'FaceColor', [0.8,0.8,0.8]);
xlabel('NPV')
title('(biggest comm)')
ylabel('Proportion')
set(gca, 'FontSize', cfg.fig.fontsize)
xlim([-0.1 1.1])

subplot(1,7,5)
bars = (0:0.1:1);
[h,b] = hist(NPV, bars);
bar(b,h/length(NPV), 'FaceColor', [0.8,0.8,0.8]);
xlabel('NPV')
title('(biggest comm)')
ylabel('Proportion')
set(gca, 'FontSize', cfg.fig.fontsize)
xlim([-0.1 1.1])

subplot(1,7,6)
bars = (0:0.1:1);
[h,b] = hist(sensitivity, bars);
bar(b,h/length(sensitivity), 'FaceColor', [0.8,0.8,0.8]);
xlabel('Sensitivity')
title('(biggest comm)')
ylabel('Proportion')
set(gca, 'FontSize', cfg.fig.fontsize)
xlim([-0.1 1.1])

subplot(1,7,7)
bars = (0:0.1:1);
[h,b] = hist(specificity, bars);
bar(b,h/length(specificity), 'FaceColor', [0.8,0.8,0.8]);
xlabel('Specificity')
title('(biggest comm)')
ylabel('Proportion')
set(gca, 'FontSize', cfg.fig.fontsize)
xlim([-0.1 1.1])

print(f, cfg.fig.type, fig_file)
close(f);

end
