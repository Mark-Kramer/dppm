function [vertices, communities, edge_present, Q] = mmm(C, gamma, omega)
% Compute MMM.
% gamma: Structural resolution parameter. typically value is gamma = 1
% omega: Temporal resolution parameter omega=(0:0.2:2) in Neuron 2015, 
%        omega=[0.1,40] in Bassett 2013. "it might be helpful to have a 
%        priori knowledge about the expected number or sizes of communities"
        
% Build the adjacency matrix, and detect nets with no edges.
max_time = size(C,3);
edge_present = ones(max_time,1);
A = cell(max_time,1);
for tt = 1:max_time
    C0 = squeeze(C(:,:,tt));
    A{tt} = C0;
    if sum(C0(:))==0
        %fprintf(['No edges at ' num2str(i) '\n'])
        edge_present(tt) = 0;
    end
end
%fprintf(['... no edges detected ' num2str(sum(edge_present)) ' times. \n'])

% % Disgard nets with no edges.
% A = A(edge_present==1);

% Run MMM.
N = length(A{1});
T = length(A);
B = spalloc(N*T,N*T,N*N*T+2*N*T);
twomu=0;
for s=1:T
    k = sum(A{s});
    twom = sum(k);
    twomu = twomu + twom;
    indx = (1:N) + (s-1) * N;
    B(indx,indx) = A{s} - gamma * k' * k / twom;
end
twomu = twomu + 2 * omega * N * (T-1);
B = B + omega * spdiags(ones(N*T,2),[-N,N],N*T,N*T);
[S,Q] = genlouvain(B,[],0);
Q = Q/twomu;
S = reshape(S,N,T);         % community assignment vector
participation = S';

[communities, vertices] = participation_to_struct(participation);

end
