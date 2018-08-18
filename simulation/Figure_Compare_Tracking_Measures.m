%% Compare different tracking methods, Sensivity vs. specificity plot

global dynanets_default;
simscenarios = {'Expand'; 'Contract'; 'Split'; 'Merge'};


cfg = [];
cfg.data.patients = {'Simulation'};
cfg.data.padding = [0 0];
cfg.preprocess.ref = '';
cfg.preprocess.filt = 'firls';
cfg.preprocess.band = [4 50]; 
cfg.infer.method = 'corr_0_lag';
cfg.fig.type = '-dpdf';

fig_path   = [dynanets_default.outfigpath 'paper_fig/'];
mkdir(fig_path);
plot_style = 'withbars';
% plot_style = 'ellipses';
% plot_style = 'boundary';
% plot_style = 'all';
fname = [fig_path '/compare_tracking_' plot_style];

close all
f = figure;
hold on;


%%
for sc = 1 : length(simscenarios)
    %%
    cfg.data.simscenario = simscenarios{sc};
    pat = cfg.data.patients{1};
    scenario = cfg.data.simscenario;
    data_path = [dynanets_default.outfigpath '/' pat '_' scenario '_population_results/'];
    
    subplot(2,2,sc);
    hold on;

    %% MMM
%     gamma_values = [0.01,0.1,0.5,1,2];
%     omega_values = [0.1,0.5,1,2,5,10];
    gamma_values = [0.01,1,2];
    omega_values = [0.1,1,5];
    se_m = []; se_l = []; se_u = []; se_all = []; se_s = [];
    sp_m = []; sp_l = []; sp_u = []; sp_all = []; sp_s = [];
    % mmm_results = zeros(length(gamma_values), length(omega_values));
    i = 1;
    for k = 1:length(gamma_values)
        for j = 1:length(omega_values)
            load([data_path '/mmm_' num2str(gamma_values(k)) '_' num2str(omega_values(j)) '_' nets_filename(cfg) '.mat'])
            se = [population_results.sensitivity];
    %         se_all = [se_all se];
            sp = [population_results.specificity];
    %         sp_all = [sp_all sp];
    %         mmm_results(k,j) = mean([population_results.sensitivity]);
            se_m(i) = mean(se); se_l(i) = quantile(se, 0.025); se_u(i) = quantile(se, 0.975); %#ok<*SAGROW>
            se_s(i) = std(se);% / sqrt(length(se));
            sp_m(i) = mean(sp); sp_l(i) = quantile(sp, 0.025); sp_u(i) = quantile(sp, 0.975);
            sp_s(i) = std(sp);% / sqrt(length(sp));
            i = i + 1;
        end
    end
    p1 = plot(se_m, sp_m, '.');
    c1 = get(p1,'Color');
    % With errorbars
    % errorbar(se_m, sp_m, sp_m-sp_l, sp_u-sp_m, se_m-se_l, se_u-se_m, '.', 'Color', c1);
    errorbar(se_m, sp_m, sp_s, sp_s, se_s, se_s, '.', 'Color', c1);

    % % Draw some ellipses
    % for i = 1 : length(se_m)
    %     rectangle('Position', [se_m(i)-se_s(i)/2 sp_m(i)-sp_s(i)/2 se_s(i) sp_s(i)], 'Curvature', [1 1], ...
    %         'FaceColor', c1, 'EdgeColor', 'none');
    % end

    % % Details all results as bars
    % subplot(2,1,1)
    % bar((1:5), mmm_results)

    % Plot an area around the error bars
    % y = [sp_l, sp_u, sp_m, sp_m];
    % x = [se_m, se_m, se_l, se_u];
    % k = boundary(x',y',0); % additional param [0 = conv hull to 1, default 0.5]
    % hold on
    % fill(x(k), y(k), c1,'FaceAlpha',.2, 'EdgeColor', 'none');

    % Other idea: use all the points before searching for the convex hull or
    % estimating the pdf with a 2d hist or kde2d
    % hold on
    % plot(se_all, sp_all, '.', 'Color', c1)
    % % hist3([se_all' sp_all'])
    % [bandwidth,density,X,Y]=kde2d([se_all' sp_all'],2^7);
    % density = density ./ sum(density(:));
    % density(density < 0.0001) = nan;
    % surf(X,Y,density,'LineStyle','none'), view([0,90])
    % %  colormap hot, hold on, alpha(.8)

    
    %% CPM
    c_array = (3:6);
    se_m = []; se_l = []; se_u = []; se_all = []; se_s = [];
    sp_m = []; sp_l = []; sp_u = []; sp_all = []; sp_s = [];
    for i = 1:length(c_array)
        load([data_path '/cpm_' num2str(c_array(i)) '_' nets_filename(cfg) '.mat'])
        se = [population_results.sensitivity];
    %     se_all = [se_all se];
        sp = [population_results.specificity];
    %     sp_all = [sp_all sp];
        se_m(i) = mean(se); se_l(i) = quantile(se, 0.025); se_u(i) = quantile(se, 0.975); %#ok<*SAGROW>
        se_s(i) = std(se) / sqrt(length(se));
        sp_m(i) = mean(sp); sp_l(i) = quantile(sp, 0.025); sp_u(i) = quantile(sp, 0.975);
        sp_s(i) = std(sp) / sqrt(length(sp));
    end
    p2 = plot(se_m, sp_m, '.');
    c2 = get(p2,'Color');
    % errorbar(se_m, sp_m, sp_m-sp_l, sp_u-sp_m, se_m-se_l, se_u-se_m, '.', 'Color', c2);
    errorbar(se_m, sp_m, sp_s, sp_s, se_s, se_s, '.', 'Color', c2);
    % for i = 1 : length(se_m)
    %     rectangle('Position', [se_m(i)-se_s(i)/2 sp_m(i)-sp_s(i)/2 se_s(i) sp_s(i)], 'Curvature', [1 1], ...
    %         'FaceColor', c2, 'EdgeColor', 'none');
    % end
    % y = [sp_l, sp_u, sp_m, sp_m];
    % x = [se_m, se_m, se_l, se_u];
    % k = boundary(x',y',0); % additional param [0 = conv hull to 1, default 0.5]
    % hold on
    % fill(x(k), y(k), c2,'FaceAlpha',.2, 'EdgeColor', 'none');
    % hold on
    % plot(se_all, sp_all, '.', 'Color', c2)

    %% DPM 
    k_array = [4,5];
    m_array = [2,3];
    se_m = []; se_l = []; se_u = []; se_all = []; se_s = [];
    sp_m = []; sp_l = []; sp_u = []; sp_all = []; sp_s = [];
    for i = 1:length(k_array)
        load([data_path '/dpp_' num2str(k_array(i)) '_' num2str(m_array(i)) '_' nets_filename(cfg) '.mat'])
        se = [population_results.sensitivity];
    %     se_all = [se_all se];
        sp = [population_results.specificity];
    %     sp_all = [sp_all sp];
        se_m(i) = mean(se); se_l(i) = quantile(se, 0.025); se_u(i) = quantile(se, 0.975); %#ok<*SAGROW>
        se_s(i) = std(se) / sqrt(length(se));
        sp_m(i) = mean(sp); sp_l(i) = quantile(sp, 0.025); sp_u(i) = quantile(sp, 0.975);
        sp_s(i) = std(sp) / sqrt(length(sp));
    end
    p3 = plot(se_m, sp_m, '.');
    c3 =  get(p3,'Color');
    % errorbar(se_m, sp_m, sp_m-sp_l, sp_u-sp_m, se_m-se_l, se_u-se_m, '.', 'Color', c3);
    errorbar(se_m, sp_m, sp_s, sp_s, se_s, se_s, '.', 'Color', c3, 'LineWidth', 2);
    circ_r = 0.1;
    rectangle('Position', [se_m(1)-circ_r/2 sp_m(1)-circ_r/2 circ_r circ_r], ...
        'Curvature', [1 1], 'EdgeColor', c3, 'LineWidth', 2);
    % for i = 1 : length(se_m)
    %     rectangle('Position', [se_m(i)-se_s(i)/2 sp_m(i)-sp_s(i)/2 se_s(i) sp_s(i)], 'Curvature', [1 1], ...
    %         'FaceColor', c3, 'EdgeColor', 'none');
    % end
    % y = [sp_l, sp_u, sp_m, sp_m];
    % x = [se_m, se_m, se_l, se_u];
    % k = boundary(x',y',0); % additional param [0 = conv hull to 1, default 0.5]
    % hold on
    % fill(x(k), y(k), c3,'FaceAlpha',.2, 'EdgeColor', 'none');
    % hold on
    % plot(se_all, sp_all, '.', 'Color', c3)

    xlim([0 1.02]);
%     lim = xlim();
%     xlim([lim(1) - 0.01 1.02]);
    xticks(0:.2:1);
%     lim = ylim();
%     ylim([lim(1) - 0.01 1.01]);
    ylim([0.4 1.02])
    xlabel('Sensitivity');
    ylabel('Specificity');
    title(cfg.data.simscenario)
    set(gca, 'FontSize', 12);
    legend([p1 p2 p3], 'MMM', 'CPM', 'DPPM', 'Location', 'southwest');
    box on;

end

%%
print(f, cfg.fig.type, fname)
%close(f)

%print(f, cfg.fig.type, [fig_path '/compare_tracking_methods_' nets_filename(cfg) ])
%close(f);