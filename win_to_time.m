function t = win_to_time(win)
% convert nb of windows to sec. For now, assumes consecutive windows with
% 50% overlap
% 
% example: 5 windows corresponds to 3s

t = zeros(size(win));
t(win > 0) = (win(win > 0) - 1) / 2 + 1;

end