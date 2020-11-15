classdef GraphTests < matlab.unittest.TestCase
    properties (TestParameter)
        data = struct('OneDim', [1; 2; 5; 7; 13; 3; 4.5; 11.1; 0.3],...
            'OneDimRepeatedValues', [1; 2.5; 3.5; 1; 2.5; 5.3; 6; 10]);
    end

    methods (Test)
        function res = testNearestNeighbors(testCase)
            import matlab.unittest.constraints.IsSameSetAs;
            import matlab.unittest.constraints.HasSize;

            G = knngraph(testCase.data.OneDim, 1);
            edges = table2array(G.Edges(:, 1));

            % IsSameSetAs can handle permutations, so it doesn't matter if the
            % the edges are not in the same order. Moreover, permutations across
            % columns are allowed also, meaning edge directions are not unique. 
            % I verify that the number of edges are the same to ensure that 
            % bidirectional edges have to show up twice, though a repeated edge
            % would be considered the same as a bidirectional edge, which isn't 
            % ideal, but good enough.
            expectedEdges = [1, 9; 2, 1; 3, 7; 4, 3; 5, 8; ... 
                6, 2; 8, 5; 7, 3; 9, 1];
            
            testCase.verifyThat(edges, IsSameSetAs(expectedEdges))
            testCase.verifyThat(edges, HasSize(size(expectedEdges)))
        end

        function res = testMutalNearestNeighbors(testCase)
            import matlab.unittest.constraints.IsSameSetAs;
            import matlab.unittest.constraints.HasSize;
            
            G = mutualknngraph(testCase.data.OneDim, 1);
            edges = table2array(G.Edges(:, 1));

            % IsSameSetAs can handle permutations, so it won't matter if the 
            % edge is reported as e.g. 9 -> 1 instead of 1 -> 9
            expectedEdges = [9, 1; 3, 7; 8, 5];

            testCase.verifyThat(edges, IsSameSetAs(expectedEdges))
            testCase.verifyThat(edges, HasSize(size(expectedEdges)))
        end

        function res = testThreeNearestNeighbors(testCase)
            import matlab.unittest.constraints.IsSameSetAs;
            import matlab.unittest.constraints.HasSize;

            G = knngraph(testCase.data.OneDim, 3);
            edges = table2array(G.Edges(:, 1));

            expectedEdges = [1, 9; 1, 2; 1, 6; 2, 1; 2, 6; 2, 9; 
                3, 7; 3, 4; 3, 6; 4, 3; 4, 7; 4, 6; 5, 8; 5, 4; 5, 3;
                6, 2; 6, 7; 6, 1; 7, 3; 7, 6; 7, 2; 8, 5; 8, 4; 8, 3;
                9, 1; 9, 2; 9, 6];

            testCase.verifyThat(edges, IsSameSetAs(expectedEdges))
            testCase.verifyThat(edges, HasSize(size(expectedEdges)))
        end

        function res = testThreeMutualNearestNeighbors(testCase)
            import matlab.unittest.constraints.IsSameSetAs;
            import matlab.unittest.constraints.HasSize;
            
            G = mutualknngraph(testCase.data.OneDim, 3);
            edges = table2array(G.Edges(:, 1));

            expectedEdges = [1, 9; 1, 2; 1, 6; 2, 6; 2, 9; 6, 7; 3, 4; 3, 7; 5, 8];

            testCase.verifyThat(edges, IsSameSetAs(expectedEdges))
            testCase.verifyThat(edges, HasSize(size(expectedEdges)))
        end

        function res = testRepeatedValuesNearestNeighbors(testCase)
            import matlab.unittest.constraints.IsSameSetAs;
            import matlab.unittest.constraints.HasSize;

            G = knngraph(testCase.data.OneDimRepeatedValues, 1);
            edges = table2array(G.Edges(:, 1));

            expectedEdges = [1, 4; 2, 5; 3, 2; 4, 1; 5, 2; 6, 7; 7, 6; 8, 7];

            testCase.verifyThat(edges, IsSameSetAs(expectedEdges))
            testCase.verifyThat(edges, HasSize(size(expectedEdges)))
        end

        function res = testRepeatedValuesMutualNearestNeighbors(testCase)
            import matlab.unittest.constraints.IsSameSetAs;
            import matlab.unittest.constraints.HasSize;

            G = mutualknngraph(testCase.data.OneDimRepeatedValues, 1);
            edges = table2array(G.Edges(:, 1));

            expectedEdges = [1, 4; 2, 5; 6, 7];

            testCase.verifyThat(edges, IsSameSetAs(expectedEdges))
            testCase.verifyThat(edges, HasSize(size(expectedEdges)))
        end

        function res = testPrecomputedIndexKNN(testCase)
            import matlab.unittest.constraints.IsSameSetAs;
            import matlab.unittest.constraints.HasSize;

            % k for the index needs to be at least 1 greater than the desired k
            % because the index includes self-edges
            index = knnindex(testCase.data.OneDim, 5);

            G = knngraph(index, 3, 'Precomputed', true);
            edges = table2array(G.Edges(:, 1));

            expectedEdges = [1, 9; 1, 2; 1, 6; 2, 1; 2, 6; 2, 9; 
                3, 7; 3, 4; 3, 6; 4, 3; 4, 7; 4, 6; 5, 8; 5, 4; 5, 3;
                6, 2; 6, 7; 6, 1; 7, 3; 7, 6; 7, 2; 8, 5; 8, 4; 8, 3;
                9, 1; 9, 2; 9, 6];

            testCase.verifyThat(edges, IsSameSetAs(expectedEdges))
            testCase.verifyThat(edges, HasSize(size(expectedEdges)))

        end

        function res = testPrecomputedIndexMutualKNN(testCase)
            import matlab.unittest.constraints.IsSameSetAs;
            import matlab.unittest.constraints.HasSize;

            % k for the index needs to be at least 1 greater than the desired k
            % because the index includes self-edges
            index = knnindex(testCase.data.OneDim, 8);

            G = mutualknngraph(index, 3, 'Precomputed', true);
            edges = table2array(G.Edges(:, 1));

            expectedEdges = [1, 9; 1, 2; 1, 6; 2, 6; 2, 9; 6, 7; 3, 4; 3, 7; 5, 8];

            testCase.verifyThat(edges, IsSameSetAs(expectedEdges))
            testCase.verifyThat(edges, HasSize(size(expectedEdges)))

        end

        function res = testKnnGraphErrorHandling(testCase)
            import matlab.unittest.constraints.Throws

            index = knnindex(testCase.data.OneDim, 3);

            testCase.verifyThat(@() knngraph(index, 3, 'Precomputed', true), Throws("knngraph:kTooLarge"))

            testCase.verifyThat(@() mutualknngraph(index, 3, 'Precomputed', true), Throws("knngraph:kTooLarge"))
        end
    end
end