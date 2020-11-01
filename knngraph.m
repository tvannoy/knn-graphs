function G = knngraph(X, k)

    % rows are assumed to be observations, and columns are variables
    [num_observations, ~] = size(X);

    % knnsearch includes self-distances, so we use k + 1 to get k neighbors
    neighbors = knnsearch(X, X, 'K', k + 1);

    % create a sparse adjacency matrix 
    A = sparse(num_observations, num_observations);
    for i = 1:num_observations
        A(i, neighbors(i, :)) = 1;
        
        % remove self-edges by setting diagonal elements to 0
        A(i, i) = 0;
    end

    G = digraph(A);
end