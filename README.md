# knn-graphs
MATLAB functions for creating k-nearest neighbor (knn) graphs. 

Many machine learning and data mining algorithms use k-nearest neighbor graphs. While MATLAB provides graph/digraph objects, it does not provide any high-level functions to create k-nearest neighbor graphs. The functions in this repo provide constructors for various k-nearest-neighbor-type graphs, which are returned as native MATLAB graph objects. 

Available graph types:
- k-nearest neighbor (`knngraph`)
- mutual k-nearest neighbor (`mutualknngraph`)

## Performance considerations
The most expensive part of knn graph creation is the knn search. In a lot of cases, MATLAB's [knnsearch](https://www.mathworks.com/help/stats/knnsearch.html) function performs an exhaustive search, which has a complexity of O(n^2) and is very time-consuming for large data. 

The functions in this repo provide the option of using [pynndescent](https://github.com/lmcinnes/pynndescent), an approximate knn search, to speed things up. `pynndescent` is used through MATLAB's Python language interface. There is now a [MATLAB implementation of NN-descent](https://www.mathworks.com/matlabcentral/fileexchange/84535-nearest-neighbor-descent-nn-descent), but there was a memory leak when I last tried to use it.

## Dependencies
- Statistics and Machine Learning toolbox

#### Optional
If you want to perform a fast approximate knn search, you will need [pynndescent](https://github.com/lmcinnes/pynndescent) installed. 

Refer to [Mathworks' documentation](https://www.mathworks.com/help/matlab/call-python-libraries.html) on setting up the Python language interface. You will need to use a Python version that your version of MATLAB supports. I recommend using [Anaconda](https://www.anaconda.com/) on Linux; it can be used on Windows as well, but, in my experience, it is not trivial to get MATLAB to recognize your Anaconda environment on Windows.

## Usage
Creating a 10-nearest neighbor graph on random data:
```matlab
X = rand(50e3, 20);
G = knngraph(X, 10);
```

Creating a mutual 5-nearest neighbor graph on random data:
```matlab
X = rand(50e3, 20);
G = mutualknngraph(X, 5);
```

Precomputing the knn search for 10 neighbors:
```matlab
X = rand(50e3, 20);

% by default, knn index creation includes self-edges, so use k+1
neighbors = knnindex(X, 11);

% create 10-nearest neighbor graph
G10 = knngraph(neighbors, 10);

% create 4-nearest neighbor graph without recomputing the knn search
G4 = knngraph(neighbors, 4);
```
Since computing the knn index is the most expensive operation, precomputing it can save time if you need to build multiple graphs.

For more detailed documentation and usage, see each function's help text. 

## Contributing
Feel free to submit pull requests! More types of nearest-neighbor graphs, bug fixes, optimizations, etc. are all appreciated.