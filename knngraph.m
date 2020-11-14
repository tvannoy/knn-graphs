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

% Turn the k-nearest neighbor indices returned by knnsearch into lists of 
% source and target edges for the knn graph. Source nodes are repeated k + 1
% times because there are k + 1 neighbors returned by knnsearch. When reshaping
% the neighbor index matrix into an array, the neighbor matrix needs to be 
% transposed because the neighbors are in rows but reshape goes by columns
sourceNodes = repelem(1:nObservations, k + 1);
targetNodes = reshape(neighbors', 1, []);

% When subtracting sourceNodes from targetNodes, self-edges will show up as
% zeros; Using find will return the indices of all non-zero entries, i.e. all
% edges that aren't self-edges
nonSelfEdges = find(targetNodes - sourceNodes);

% remove self-edges
sourceNodes = sourceNodes(nonSelfEdges);
targetNodes = targetNodes(nonSelfEdges);

G = digraph(sourceNodes, targetNodes);
end