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

from itertools import combinations
from collections import defaultdict, deque
import sys

graph = {
    'A': {'B': 2, 'C': 3, 'D': 6},
    'B': {'A': 2, 'C': 1, 'E': 4},
    'C': {'A': 3, 'B': 1, 'D': 5, 'F': 2},
    'D': {'A': 6, 'C': 5, 'G': 3},
    'E': {'B': 4, 'F': 7, 'H': 2},
    'F': {'C': 2, 'E': 7, 'I': 4},
    'G': {'D': 3, 'I': 1, 'J': 5},
    'H': {'E': 2, 'I': 6},
    'I': {'F': 4, 'G': 1, 'H': 6, 'J': 3},
    'J': {'G': 5, 'I': 3},
}

terminals = {'A', 'E', 'G', 'J'}

def all_edges(g):
    """Return a list of edges (u, v, w) with u < v to avoid duplicates."""
    seen = set()
    edges = []
    for u, pairs in g.items():
        for v, w in pairs.items():
            if (v,u) not in seen:
                edges.append((u,v,w))
                seen.add((u,v))
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

    return required.issubset(visited)

def backtrack(idx, chosen, cur_weight):
    """Recursive backtracking over the edge list."""
    global best_weight, best_solution, edges

    if cur_weight >= best_weight:
        return

    if idx == len(edges):
        if connected(chosen, terminals):
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

edges = all_edges(graph)

backtrack(0, [], 0)

if best_solution is None:
    print("No Steiner tree found.")
else:
    print(f"Minimum weight: {best_weight}")
    print("Edges in the Steiner tree:")
    for u, v, w in best_solution:
        print(f"  {u} - {v} (weight {w})")
