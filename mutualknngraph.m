function G = mutualknngraph(X, k, options)
%MUTUALKNNGRAPH Construct a mutual k-nearest neighbors graph
%   The mutual k-nearest neighbors graph is a subgraph of the k-nearest 
%   neighbors graph that only contains bidirectional edges, i.e. there is
%   an edge between points p and q iff p is one of q's k-nearest neighbors and 
%   q is also one of p's k-nearest neighbors.
%
%   G = MUTUALKNNGRAPH(X, k) constructs a mutual k-nearest neighbors undirected
%   graph, G, for the input data matrix X. Rows in X are observations, 
%   and columns are variables. The distance metric used is the Euclidean 
%   distance.
%
%   G = MUTUALKNNGRAPH(neighbors, k, 'Precomputed', true) takes a precomputed
%   nearest neighbors index as an argument instead of the original data matrix.
%   This is useful when creating several mutual knn graphs for the same data
%   with different values of k, as the nearest neighbors index only needs to be
%   computed once. The number of columns in neighbors must be >= k + 1  because
%   knn graph does not include self-edges, but the nearest neighbors index does.
%   k can be much less than the number of columns in neighbors.
%
%   G = MUTUALKNNGRAPH(X, k, 'Method', method) constructs a mutual k-nearest
%   neighbors graph using the specified method.
%
%   Optional parameters:
%   'Method'        - The method to use when building the knn index
%       "knnsearch" - Use KNNSEARCH from Mathwork's Statistics and Machine
%                     Learning Toolbox. This is the default method.
%       "nndescent" - Use the nearest neighbor descent algorithm to build an
%                     approximate knn index. For large matrices, this is
%                     much faster than KNNSEARCH, at the cost of slightly
%                     less accuracy. This method requires the pynndescent
%                     python package to be installed and accessible through
%                     MATLAB's Python external language interface
%
%   'Precomputed'   - Needs to be true if using a precomputed nearest neighbors
%                     index. The default is false.
%
%   See also KNNGRAPH, KNNINDEX

% SPDX-License-Identifier: BSD-3-Clause
% Copyright (c) 2020 Trevor Vannoy

arguments
    X (:,:) double
    k (1, 1) {mustBePositive, mustBeInteger}
    options.Method (1,1) string {mustBeMember(options.Method, ["knnsearch", "nndescent"])} = "knnsearch"
    options.Precomputed logical = false
end


knnGraph = knngraph(X, k, 'Method', options.Method, ...
    'Precomputed', options.Precomputed);

% The mutual knn graph is a subgraph of the knn graph that only contains
% bidirectional edges. To find bidirectional edges, we add the knn adjacency
% matrix to its transpose; entries with weight 2 in this new adjacency
% matrix correspond to bidirectional edges in the knn graph. We then remove
% all unidirectional edges from the new adjacency matrix to get an adjacency
% matrix for the mutual knn graph.
knnAdjacency = adjacency(knnGraph);
A = knnAdjacency + knnAdjacency';
A(A==1) = 0;

% normalize to weights of 1 so the undirected mutual knn graph is unweighted
A = A/2;

G = graph(A);
end
