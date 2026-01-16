# G = [
#     [0, 2, 3, 6, 0, 0, 0, 0, 0, 0],
#     [2, 0, 1, 0, 4, 0, 0, 0, 0, 0],
#     [3, 1, 0, 5, 0, 2, 0, 0, 0, 0],
#     [6, 0, 5, 0, 0, 0, 3, 0, 0, 0],
#     [0, 4, 0, 0, 0, 7, 0, 2, 0, 0],
#     [0, 0, 2, 0, 7, 0, 0, 0, 4, 0],
#     [0, 0, 0, 3, 0, 0, 0, 0, 1, 5],
#     [0, 0, 0, 0, 2, 0, 0, 0, 6, 0],
#     [0, 0, 0, 0, 0, 4, 1, 6, 0, 3],
#     [0, 0, 0, 0, 0, 0, 5, 0, 3, 0]
# ]

# T = [0, 4, 6, 9]

# N = 10

from itertools import combinations
from collections import defaultdict, deque
import sys
import time

def read_graph(file):
    G = []
    T = []

    first = file.readline().strip()
    if not first:
        raise ValueError("no first line")
    N, M, Tn = map(int, first.split())

    second = file.readline().strip()
    if not second and Tn > 0:
        raise ValueError("no second line")
    T = list(map(int, second.split()))
    if len(T) != Tn:
        raise ValueError("not enough terminal nodes")
    
    for _ in range(M):
        line = file.readline().strip()
        if not line:
            raise ValueError("not enough data lines")
        u, v, w = map(int, line.split())
        G.append((u,v,w))
    
    return G, T

# def all_edges(graph):
#     """Return a list of edges (u, v, w) with u < v to avoid duplicates."""
#     edges = []
#     for u in range(0, N):
#         for v in range(u + 1, N):
#             w = graph[u][v]
#             if w != 0:
#                 edges.append((u,v,w))
#     return edges

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
    global best_weight, best_solution, edges, T

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

edges, T = read_graph(open("example.in", "r"))

start = time.time()
# edges = all_edges(G)
print(edges)
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
    open("example.out", "w").write(str(best_weight))

print("Time elapsed (PREP): %.4f ms" % end_pre)
print("Time elapsed (BT): %.4f ms" % end_bt)
