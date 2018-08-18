global dynanets_default;
savepath = dynanets_default.outfigpath;

% Design the graphs from Wes's thesis.

n = 7;

A = zeros(n);
A(1,2) = 1;
A(2,3) = 1;
A(1,3) = 1;
A(5,6) = 1;
A(6,7) = 1;
A(5,7) = 1;
A = A + transpose(A);
imagesc(A)

B = zeros(n);
B(4,1) = 1;
B(4,3) = 1;
B(4,5) = 1;
B(4,7) = 1;
B(1,5) = 1;
B(3,7) = 1;
B(3,5) = 1;
B = B + transpose(B);
imagesc(B)

C = B;
C(1,3) = 1;
C(3,1) = 1;
imagesc(C);

D = C;
D(5,7) = 1;
D(7,5) = 1;
imagesc(D);

% Specify locations to match Wes's thesis

xy = zeros(n,2);
xy(1,:) = [-1,1];
xy(2,:) = [ 0,2];
xy(3,:) = [ 1,1];
xy(4,:) = [ 0, 0.5];
xy(5,:) = [-1,-1];
xy(6,:) = [0,-2];
xy(7,:) = [1,-1];

clr = cell(4,1);
clr{1} = rgb('red');
clr{2} = rgb('green');
clr{3} = rgb('blue');
clr{4} = rgb('orange');

close all

% Example 1.
nets = zeros(n,n,2);
nets(:,:,1) = A;            % Time 1 is graph A.
nets(:,:,2) = B;            % Time 2 is graph B.

figure(1)
set(gcf, 'Position', [0, 400, 1000, 200])
clf
plot_7_node_graph_for_all_tracking_methods(nets,xy,clr)
print('-dsvg', [savepath '/7-node-example/7_node_plots_row1.svg'])

% Example 2.
nets = zeros(n,n,2);
nets(:,:,1) = A;            % Time 1 is graph A.
nets(:,:,2) = C;            % Time 2 is graph C.

figure(2);
set(gcf, 'Position', [0, 200, 1000, 200])
clf
plot_7_node_graph_for_all_tracking_methods(nets,xy,clr)
print('-dsvg', [savepath '/7-node-example/7_node_plots_row2.svg'])


% Example 3.
nets = zeros(n,n,2);
nets(:,:,1) = A;            % Time 1 is graph A.
nets(:,:,2) = D;            % Time 2 is graph D.

figure(3)
set(gcf, 'Position', [0, 0, 1000, 200])
plot_7_node_graph_for_all_tracking_methods(nets,xy,clr)
print('-dsvg', [savepath '/7-node-example/7_node_plots_row3.svg'])

figure(2)
figure(1)