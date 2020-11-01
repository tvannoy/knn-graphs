function G = mutualknngraph(X, k)
%MUTUALKNNGRAPH Construct a mutual k-nearest neighbors graph
%   G = MUTUALKNNGRAPH(X, k) constructs a mutual k-nearest neighbors undirected
%   graph, G, for the input data matrix X. Rows in X are observations, 
%   and columns are variables. The distance metric used is the Euclidean 
%   distance.
%
%   The mutual k-nearest neighbors graph is a subgraph of the k-nearest 
%   neighbors graph that only contains bidirectional edges, i.e. there is
%   an edge between points p and q iff p is one of q's k-nearest neighbors and 
%   q is also one of p's k-nearest neighbors.

arguments
    X (:,:) double
    k (1, 1) {mustBePositive, mustBeInteger}
end
knnGraph = knngraph(X, k);

% The mutual knn graph is a subgraph of the knn graph that only contains
% bidirectional edges. To find bidirectional edges, we add the knn adjacency
% matrix to its transpose; entries with weight 2 in this new adjacency
% matrix correspond to bidirectional edges in the knn graph. We then remove
% all unidirectional edges from the new adjacency matrix to get an adjacency
% matrix for the mutual knn graph.
A = knnGraph.adjacency + knnGraph.adjacency.';
A(A==1) = 0;

% normalize to weights of 1 so the undirected mutual knn graph is unweighted
A = A/2;

G = graph(A);
end