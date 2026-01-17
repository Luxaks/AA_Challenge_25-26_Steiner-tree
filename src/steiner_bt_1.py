# Primary Steiner tree algorithm using Backtracking.

from collections import defaultdict, deque
import sys
import time

# read data from file
# TODO: streamline file I/O via checker
def read_graph(file):
    G = []
    T = []

    # first line contains number of vertices, number of edges, number of terminals
    first = file.readline().strip()
    if not first:
        raise ValueError("no first line")
    N, M, Tn = map(int, first.split())

    # second line contains terminal nodes
    second = file.readline().strip()
    if not second and Tn > 0:
        raise ValueError("no second line")
    T = list(map(int, second.split()))
    if len(T) != Tn:
        raise ValueError("not enough terminal nodes")

    # following lines contain edges in the format Start End Weight    
    for _ in range(M):
        line = file.readline().strip()
        if not line:
            raise ValueError("not enough data lines")
        u, v, w = map(int, line.split())
        if u > v: u, v = v, u
        G.append((u,v,w))
    
    return N, G, T

# check if all terminals are in current tree solution
def connected(cur_tree, terminals):
    adj = defaultdict(list)
    for u, v, _ in cur_tree:
        adj[u].append(v)
        adj[v].append(u)

    start = next(iter(terminals))
    visited = set()
    q = deque([start])
    while q:
        node = q.popleft()
        visited.add(node)
        for nb in adj[node]:
            if nb not in visited:
                q.append(nb)

    return set(terminals).issubset(visited)

def backtrack(idx, chosen, cur_weight):
    global best_weight, best_solution, G, T

    # if weight already exceeds the current minimum,
    # a check is no longer needed (the solution is not optimal)
    if cur_weight >= best_weight:
        return

    # otherwise, check if current configuration includes all terminals
    if idx == len(G):
        if connected(chosen, T):
            best_weight = cur_weight
            best_solution = list(chosen)
        return

    u, v, w = G[idx]

    # BACKTRACK: add next edge
    chosen.append((u, v, w))
    backtrack(idx + 1, chosen, cur_weight + w)
    
    # BACKTRACK: remove edge and compare result on alternate branch
    chosen.pop()
    backtrack(idx + 1, chosen, cur_weight)

# ==================================================

# ENTRY: check args
if len(sys.argv) != 2:
    print("Usage: python3 greedy <filename>")
    exit(1)
fname = sys.argv[1]

# PREPARE: init minimum, set null solution
best_weight = sys.maxsize
best_solution = None

# BEGIN: read data
try:
    N, G, T = read_graph(open(fname, "r"))
except FileNotFoundError:
    print(f"'{fname}' is not a valid file!")
    exit(2)


# SOLVE: find Steiner tree and calculate time taken in milliseconds
start = time.time()
backtrack(0, [], 0)
end_bt = (time.time() - start) * 1000

# RESULT: print data to console and write total weight to file
# TODO: streamline file I/O via checker
if best_solution is None:
    print("No Steiner tree found.")
else:
    open("example.out", "w").write(f"{best_weight}")
    print(f"Minimum weight: {best_weight}")
    for u, v, w in best_solution:
        print(f"  {u} - {v} (weight {w})")
# print("Time elapsed (PREP): %.4f ms" % end_pre)
print("Time elapsed (BT): %.4f ms" % end_bt)
