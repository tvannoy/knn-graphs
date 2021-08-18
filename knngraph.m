function G = knngraph(X, k, options)
%KNNGRAPH Construct a k-nearest neighbors graph
%   G = KNNGRAPH(X, k) constructs a k-nearest neighbors directed graph, G,
%   for the input data matrix X. Rows in X are observations, and columns are
%   variables. The distance metric used is the Euclidean distance.
%
%   G = KNNGRAPH(neighbors, k, 'Precomputed', true) takes a precomputed nearest
%   neighbors index as an argument instead of the original data matrix. This is
%   useful when creating several knngraphs for the same data with different
%   values of k, as the nearest neighbors index only needs to be computed once.
%   The number of columns in neighbors must be >= k + 1  because KNNGRAPH does
%   not include self-edges, but the nearest neighbors index does. k can be much
%   less than the number of columns in neighbors.
%
%   G = KNNGRAPH(X, k, 'Method', method) constructs a k-nearest neighbors graph
%   using the specified method.
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
%   See also KNNINDEX, MUTUALKNNGRAPH

% SPDX-License-Identifier: BSD-3-Clause
% Copyright (c) 2020 Trevor Vannoy

% TODO: consider adding IncludeSelfEdges as an optional argument, like in knnIndexToGraphEdges. 

arguments
    X (:,:) double
    k (1, 1) {mustBePositive, mustBeInteger}
    options.Method (1,1) string {mustBeMember(options.Method, ["knnsearch", "nndescent"])} = "knnsearch"
    options.Precomputed logical = false
end

if options.Precomputed && k >= size(X, 2)
    error("knngraph:kTooLarge","Input k = %d is too large for precomputed neighbors with k = %d", k, size(X,2))
end

if options.Precomputed
    neighbors = X;
    % size(neighbors,2) - 1 is equal to the number of neighbors not including
    % self-edges
    if k < size(neighbors,2) - 1
        neighbors = neighbors(:,1:k+1);
    end
else
    % use k + 1 because knngraph does not include self edges
    neighbors = knnindex(X, k + 1, 'Method', options.Method);
end

[sourceNodes, targetNodes] = knnIndexToGraphEdges(neighbors);

G = digraph(sourceNodes, targetNodes);
end