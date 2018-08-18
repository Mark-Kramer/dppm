function [stats] = compare_true_recruitment_with_communities(cfg, pat, sz, nets, ~, stats)

global dynanets_default;
load([dynanets_default.outdatapath '/' pat '_' sz '/' data_filename(cfg) '.mat'], 'ECoG', 'OtherData');
% Compare participation with true recruitment.
recruited = OtherData.recruited;
[~, idx] = min((repmat(ECoG.Time, length(nets.t), 1) - repmat(netst, 1, length(ECoG.Time))) .^ 2, [], 2);
% Subsample the recruitment matrix at the time point t of the sliding windows
recruited_time_matrix = recruited(idx,:);

stats.number_of_communites_in_recruitment = length(find(stats.com_cum_size > 0));

% Measure the sensitivity/specificity
[~, i_largest_community] = max(stats.com_cum_size);
P0 = zeros(size(recruited_time_matrix));
P0(participation == i_largest_community) = 1;
sum_true_positive = sum(P0(:)==1 & recruited_time_matrix(:)==1);
sum_predicted_condition_positive = sum(P0(:)==1);
stats.PPV = sum_true_positive / sum_predicted_condition_positive;
sum_true_negative = sum(P0(:)==0 & recruited_time_matrix(:)==0);
sum_predicted_condition_negative = sum(P0(:)==0);
stats.NPV = sum_true_negative / sum_predicted_condition_negative;
sum_false_positive = sum(P0(:)==1 & recruited_time_matrix(:)==0);
stats.FDR = sum_false_positive / sum_predicted_condition_positive;
sum_false_negative = sum(P0(:)==0 & recruited_time_matrix(:)==1);
stats.FOR = sum_false_negative / sum_predicted_condition_negative;
stats.sensitivity = sum_true_positive / (sum_true_positive + sum_false_negative);
stats.specificity = sum_true_negative / (sum_false_positive + sum_true_negative);

end