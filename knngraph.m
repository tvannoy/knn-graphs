function G = knngraph(X, k)
%KNNGRAPH Construct a k-nearest neighbors graph
%   G = KNNGRAPH(X, k) constructs a k-nearest neighbors directed graph, G,
%   for the input data matrix X. Rows in X are observations, and columns are
%   variables. The distance metric used is the Euclidean distance.

arguments
    X (:,:) double
    k (1, 1) {mustBePositive, mustBeInteger}
end

% rows are assumed to be observations, and columns are variables
[nObservations, ~] = size(X);

% knnsearch includes self-distances, so we use k + 1 to get k neighbors
neighbors = knnsearch(X, X, 'K', k + 1);

% create a sparse adjacency matrix 
A = sparse(nObservations, nObservations);
for i = 1:nObservations
    A(i, neighbors(i, :)) = 1;
    
    % remove self-edges by setting diagonal elements to 0
    A(i, i) = 0;
end

G = digraph(A);
end