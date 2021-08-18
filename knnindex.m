function neighbors = knnindex(X, k, options)
%KNNINDEX Compute k-nearest neighbors index on input data
%   neighbors = KNNINDEX(X, k) constructs a k-nearest neighbors index matrix, 
%   neighbors, for the input data matrix X. X is an M-by-d matrix of M
%   d-dimensional observations. neighbors is an M-by-k matrix, where each
%   row i contains the indices of the k-nearest neighbors of point i. Point
%   i is included in it's k-nearest neighbors list. 
%
%   neighbors = KNNINDEX(X, k, 'Method', method) constructs a k-nearest 
%   neighbors index for the input data X using the specified method.
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
%                     MATLAB's Python external language interfacea
%
%   See also KNNGRAPH

% SPDX-License-Identifier: BSD-3-Clause
% Copyright (c) 2020 Trevor Vannoy

arguments
    X (:,:) double
    k (1, 1) {mustBePositive, mustBeInteger}
    options.Method (1,1) string {mustBeMember(options.Method, ["knnsearch", "nndescent"])} = "knnsearch"
end

if options.Method == "knnsearch"
    neighbors = knnsearch(X, X, 'K', k);
elseif options.Method == "nndescent"
    % see https://pynndescent.readthedocs.io/en/latest/index.html for deatils on
    % PyNNDescent. Setting 'diversify_prob' to 0 results in a more accurate
    % index at the expense of speed; this could become an argument to knnindex
    index = py.pynndescent.NNDescent(X, ...
        pyargs('n_neighbors', py.int(k), 'diversify_prob', 0.0));

    % python indexing starts at 0, so we add one to match what MATLAB does
    neighbors = int32(index.neighbor_graph{1}) + 1;
end
end