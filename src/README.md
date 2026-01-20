# Source code
This directory contains the four Python code files, as follows:
* `generator.py` — Generate (highly) connected graphs with a given vertex count, and a list of terminals from among these.

Usage: 
```bash
python3 generator.py <n> <t>
```

* `backtrack.py` — The main Steiner solver algorithm, using backtracking.

* `fuchs.py` — A heuristic algorithm, based on dynamic programming, implementing the Fuchs improved Dreyfus-Wagner method.

* `greedy.py` — A heuristic algorithm, based on the greedy technique, implementing the Takahashi-Matsuyama method.

Usage:
```bash
python3 <solver> [-t | <input_file>] <output_file>
```

## Inputs
The input of the solver algorithms should be of this format:

N M T

(line of T integers between 0 and N-1, inclusive)

(M lines of the type U V W, where U and V are integers like above, and W is a non-zero integer, ideally between 1 and 10, inclusive)

This produces a graph of N vertices and M edges, with the specified T terminals. The edges should be unique, but the ordering of the vertices does not matter.  
(So you can input either "x y weight" or "y x weight", but not both!)
