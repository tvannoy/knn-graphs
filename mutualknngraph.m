function G = mutualknngraph(X, k)
    knn_graph = knngraph(X, k);

    % The mutual knn graph is a subgraph of the knn graph that only contains 
    % bidirectional edges. To find bidirectional edges, we add the knn adjacency
    % matrix to its transpose; entries with weight 2 in this new adjacency 
    % matrix correspond to bidirectional edges in the knn graph. We then remove
    % all unidirectional edges from the new adjacency matrix to get an adjacency
    % matrix for the mutual knn graph. 
    A = knn_graph.adjacency + knn_graph.adjacency.';
    A(A==1) = 0;

    % normalize to weights of 1 so the undirected mutual knn graph is unweighted
    A = A/2;

    G = graph(A);
end