function [sourceNodes, targetNodes] = knnIndexToGraphEdges(neighbors, options)
%knnIndexToGraphEdges transform k-nearest neighbor index into graph edges
%   [sourceNodes, targetNodes] = knnIndexToGraphEdges(neighbors) returns 
%   arrays of source and target nodes for the edges in the knn graph represented
%   by the k-nearest neighbors index, neighbors. neighbors is an M-by-k matrix,
%   where each row i contains the indices of the k-nearest neighbors of
%   point i. Point i is included in it's k-nearest neighbors list. sourceNodes
%   and targetNodes are 1-by-M*(k-1) vectors the source and target nodes for
%   each edge, respectively.
%
%   [sourceNodes, targetNodes] = knnIndexToGraphEdges(neighbors, 'IncludeSelfEdges', true)
%   includes self-edges in the source and target node arrays.  
%
%   See also KNNINDEX

% SPDX-License-Identifier: BSD-3-Clause
% Copyright (c) 2020 Trevor Vannoy

arguments
    neighbors (:,:) double
    options.IncludeSelfEdges = false
end

[nNodes, k] = size(neighbors);

% Turn the k-nearest neighbor indices into lists of source and target edges for
% the knn graph. When reshaping the neighbor index matrix into an array, the
% neighbor matrix needs to be transposed because the neighbors are in rows but
% reshape goes by columns
sourceNodes = repelem(1:nNodes, k);
targetNodes = reshape(neighbors', 1, []);

if ~options.IncludeSelfEdges
    % When subtracting sourceNodes from targetNodes, self-edges will show up as
    % zeros; Using find will return the indices of all non-zero entries, i.e.
    % all edges that aren't self-edges
    nonSelfEdges = find(targetNodes - sourceNodes);

    % remove self-edges
    sourceNodes = sourceNodes(nonSelfEdges);
    targetNodes = targetNodes(nonSelfEdges);
end
end