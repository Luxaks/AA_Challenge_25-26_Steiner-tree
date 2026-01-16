G = [
    [0, 2, 3, 6, 0, 0, 0, 0, 0, 0],
    [2, 0, 1, 0, 4, 0, 0, 0, 0, 0],
    [3, 1, 0, 5, 0, 2, 0, 0, 0, 0],
    [6, 0, 5, 0, 0, 0, 3, 0, 0, 0],
    [0, 4, 0, 0, 0, 7, 0, 2, 0, 0],
    [0, 0, 2, 0, 7, 0, 0, 0, 4, 0],
    [0, 0, 0, 3, 0, 0, 0, 0, 1, 5],
    [0, 0, 0, 0, 2, 0, 0, 0, 6, 0],
    [0, 0, 0, 0, 0, 4, 1, 6, 0, 3],
    [0, 0, 0, 0, 0, 0, 5, 0, 3, 0]
]

T = [0, 4, 6, 9]

N = 10

from itertools import combinations
from collections import defaultdict, deque
import sys
import time

def all_edges(g):
    """Return a list of edges (u, v, w) with u < v to avoid duplicates."""
    edges = []
    for u in range(0, N):
        for v in range(u + 1, N):
            w = G[u][v]
            if w != 0:
                edges.append((u,v,w))
    return edges

def connected(sub_edges, required):
    """Check if the subgraph formed by sub_edges connects all required nodes."""
    adj = defaultdict(list)
    for u, v, _ in sub_edges:
        adj[u].append(v)
        adj[v].append(u)

    start = next(iter(required))
    visited = set()
    q = deque([start])
    while q:
        node = q.popleft()
        visited.add(node)
        for nb in adj[node]:
            if nb not in visited:
                q.append(nb)

    return set(required).issubset(visited)

def backtrack(idx, chosen, cur_weight):
    """Recursive backtracking over the edge list."""
    global best_weight, best_solution, edges

    if cur_weight >= best_weight:
        return

    if idx == len(edges):
        if connected(chosen, T):
            best_weight = cur_weight
            best_solution = list(chosen)
        return

    u, v, w = edges[idx]

    chosen.append((u, v, w))
    backtrack(idx + 1, chosen, cur_weight + w)
    
    chosen.pop()
    backtrack(idx + 1, chosen, cur_weight)

# ==================================================

best_weight = sys.maxsize
best_solution = None

start = time.time()
edges = all_edges(G)
# print(edges)
end_pre = (time.time() - start) * 1000

start = time.time()
backtrack(0, [], 0)
end_bt = (time.time() - start) * 1000

if best_solution is None:
    print("No Steiner tree found.")
else:
    print(f"Minimum weight: {best_weight}")
    for u, v, w in best_solution:
        print(f"  {u} - {v} (weight {w})")
print("Time elapsed (PREP): %.4f ms" % end_pre)
print("Time elapsed (BT): %.4f ms" % end_bt)
