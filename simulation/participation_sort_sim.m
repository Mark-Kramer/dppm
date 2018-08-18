function [isort] = participation_sort_sim(cfg, pat, sz)

global dynanets_default;
load([dynanets_default.outdatapath '/' pat '_' sz '/' data_filename(cfg) '.mat'], 'ECoG', 'OtherData');
isort = OtherData.recruitment_order;
    
end