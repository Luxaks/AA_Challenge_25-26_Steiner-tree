# Greedy approximation of Steiner tree, replacing BT with
# a Dijkstra-based algorithm via the Takahashi-Matsuyama method (1980). 

from collections import defaultdict, deque
import heapq
import sys
import time


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

# Dijkstra's shortest path algorithm
def dijkstra(G, n, start):
    # PREPARE: distance to every node is infinite, predecessor is null
    dist = [float('inf') for v in range(n)]
    prev = [None for v in range(n)]
    dist[start] = 0

    # go through nodes
    q = [(0, start)]
    visited = set()
    q.sort()
    while q:
        d, u = heapq.heappop(q)
        if u in visited:
            continue
        visited.add(u)
        # for unvisited nodes, if distance to neighbours
        # is shorter than current path, assign as predecessor
        for P in G:
            if u in (P[0], P[1]):
                v = P[1] if P[0] == u else P[0]
                w = P[2]
                alt = d + w
                if alt < dist[v]:
                    dist[v] = alt
                    prev[v] = u
                    heapq.heappush(q, (alt, v))
    
    return dist, prev

def greedy():
    global best_weight, sol_nodes, sol_edges, G, N, T

    # PREPARE: solution contains arbitrary terminal and no edges
    start = next(iter(T))
    sol_nodes.add(start)
    remain = set(T) - sol_nodes
    djk = {}

    # go through remaining terminals
    while remain:
        best_T = None
        best_V = None
        best_dist = float('inf')

        # using Dijkstra, get shortest path between any remaining terminal and the solution tree
        # this means that all terminals are eligible and they are connected to any node that is already added
        for t in remain:
            if t not in djk:
                djk[t] = dijkstra(G, N, t)
            dist, _ = djk[t]

            for u in sol_nodes:
                if dist[u] < best_dist:
                    best_dist = dist[u]
                    best_T = t
                    best_V = u
        
        # then, add the path according to Dijkstra:
        # from whichever node is closest in the current solution,
        # go backwards until reaching the selected terminal
        cur = best_V
        _, pred = djk[best_T]
        while cur != best_T:
            prev = pred[cur]
            sol_nodes.add(cur)
            sol_nodes.add(prev)

            # and add the weight of the chosen edge to the total
            for P in G:
                if prev in (P[0], P[1]):
                    v = P[1] if P[0] == prev else P[0]
                    w = P[2]
                    if v == cur:
                        break
            best_weight += w
            edge = (prev, cur, w) if prev < cur else (cur, prev, w)
            sol_edges.add(edge)

            cur = prev
        
        # lastly, add the terminal and remove it from the list of remaining
        sol_nodes.add(best_T)
        remain.remove(best_T)

# ==================================================

# ENTRY: check args
if len(sys.argv) != 3:
    print("\033[93mUsage:\n\tpython3 greedy.py [-t | <input_filename>] <output_filename>")
    print("\nFlag:\n\t-t\tRead data from terminal\033[0m")
    exit(1)
ifname = sys.argv[1]
ofname = sys.argv[2]
if ifname == "-t":
    ifname = sys.stdin.fileno()

# PREPARE: set null solution (zero weight, empty tree)
best_weight = 0
sol_nodes = set()
sol_edges = set()

# BEGIN: read data
try:
    N, G, T = read_graph(open(ifname, "r"))
except FileNotFoundError:
    print(f"\033[91m'{ifname}' is not a valid file!\033[0m")
    exit(2)

# SOLVE: find Steiner tree and calculate time taken in milliseconds
start = time.perf_counter_ns()
greedy()
end = (time.perf_counter_ns() - start) / 1e6

# RESULT: print data to console and write total weight to file
print("GREEDY")
if sol_nodes is None:
    print("No Steiner tree found.")
else:
    try:
        open(ofname, "w").write(f"{best_weight}")
    except FileNotFoundError:
        print(f"\033[91m'{ofname}' is not a valid file!\033[0m")
    print(f"Minimum weight: {best_weight}")
    for u, v, w in sol_edges:
        print(f"  {u} - {v} (weight {w})")
print("Time elapsed (Greedy): %.4f ms\n" % end)
