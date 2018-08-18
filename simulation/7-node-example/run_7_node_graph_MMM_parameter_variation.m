%%
global dynanets_default;
savepath = dynanets_default.outfigpath;

%% Design the graphs from Wes's thesis.

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

clr = cell(9,1);
clr{1} = rgb('red');
clr{2} = rgb('green');
clr{3} = rgb('blue');
clr{4} = rgb('orange');
clr{5} = rgb('navy');
clr{6} = rgb('maroon');
clr{7} = rgb('purple');
clr{8} = rgb('yellow');
clr{9} = rgb('black');

close all
figure(1)
set(gcf, 'Position', [0, 400, 300, 1000])
clf

% Run MMM for different values of gamma and omega.
gamma_values = [1]; %[0.01,0.1,0.5,1,2];
omega_values = [1]; %[0.1,0.5,1,2,5,10];

for k = 1:length(gamma_values)
%k=3;
    for j = 1:length(omega_values)
%j=1;
        gamma = gamma_values(k);
        omega = omega_values(j);
        
        clf
        % Example 1.
        location = 321;
        nets = zeros(n,n,2);
        nets(:,:,1) = A;            % Time 1 is graph A.
        nets(:,:,2) = B;            % Time 2 is graph B.
        run_and_plot_MMM(nets, xy, clr, location, gamma, omega)
        
        % Example 2.
        location = 323;
        nets = zeros(n,n,2);
        nets(:,:,1) = A;            % Time 1 is graph A.
        nets(:,:,2) = C;            % Time 2 is graph C.
        run_and_plot_MMM(nets, xy, clr, location, gamma, omega)
        
        % Example 3.
        location = 325;
        nets = zeros(n,n,2);
        nets(:,:,1) = A;            % Time 1 is graph A.
        nets(:,:,2) = D;            % Time 2 is graph D.
        run_and_plot_MMM(nets, xy, clr, location, gamma, omega)
        
        print('-djpeg', [savepath '/MMM_with_' num2str(gamma) '_' num2str(omega) '.jpeg'])
        pause(0.1)
     end
 end
