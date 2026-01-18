# DP approximation of Steiner tree, replacing BT with a Dijkstra-based
# algorithm via the Fuchs improved Dreyer-Wagner method (1971, 2006).

import heapq
import random
import time
import sys
from collections import defaultdict

INF = float('inf')

#==================== DIJKSTRA ====================
def dijkstra(n, graph, src):
    dist = [INF] * n
    parent = [-1] * n
    dist[src] = 0
    pq = [(0, src)]

    while pq:
        d, u = heapq.heappop(pq)
        if d != dist[u]:
            continue
        for P in graph:
            if u in (P[0], P[1]):
                v = P[1] if P[0] == u else P[0]
                w = P[2]
                nd = d + w
                if nd < dist[v]:
                    dist[v] = nd
                    parent[v] = u
                    heapq.heappush(pq, (nd, v))

    return dist, parent

#================== STEINER TREE ==================
def steiner_tree(n, graph, terminals):
    k = len(terminals)
    FULL = 1 << k

    dist_term = []
    parent_term = []
    for t in terminals:
        d, p = dijkstra(n, graph, t)
        dist_term.append(d)
        parent_term.append(p)

    dp = [[INF] * n for _ in range(FULL)]
    trace = {}

    for i in range(k):
        mask = 1 << i
        for v in range(n):
            dp[mask][v] = dist_term[i][v]
            trace[(mask, v)] = ('base', i)

    for mask in range(1, FULL):
        if mask & (mask - 1):
            lb = mask & -mask
            sub = (mask - 1) & mask
            while sub:
                if sub & lb:
                    other = mask ^ sub
                    for v in range(n):
                        val = dp[sub][v] + dp[other][v]
                        if val < dp[mask][v]:
                            dp[mask][v] = val
                            trace[(mask, v)] = ('merge', sub)
                sub = (sub - 1) & mask

        dist = dp[mask][:]
        pq = [(dist[v], v) for v in range(n) if dist[v] < INF]
        heapq.heapify(pq)

        while pq:
            d, u = heapq.heappop(pq)
            if d != dist[u]:
                continue
            for P in graph:
                if u in (P[0], P[1]):
                    v = P[1] if P[0] == u else P[0]
                    w = P[2]
                    nd = d + w
                    if nd < dist[v]:
                        dist[v] = nd
                        trace[(mask, v)] = ('move', u)
                        heapq.heappush(pq, (nd, v))

        dp[mask] = dist

    full = FULL - 1
    end = min(range(n), key=lambda v: dp[full][v])
    cost = dp[full][end]

    edges = set()
    visited = set()

    def build(mask, v):
        if (mask, v) in visited:
            return
        visited.add((mask, v))

        t = trace[(mask, v)]
        if t[0] == 'base':
            i = t[1]
            cur = v
            while parent_term[i][cur] != -1:
                p = parent_term[i][cur]
                if p > cur:
                    edges.add((cur, p))
                else:
                    edges.add((p, cur))
                cur = p
        elif t[0] == 'merge':
            build(t[1], v)
            build(mask ^ t[1], v)
        elif t[0] == 'move':
            u = t[1]
            if u > v:
                edges.add((v, u))
            else:
                edges.add((u, v))
            build(mask, u)

    build(full, end)
    return cost, edges

#====================== INPUT =====================
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

#====================== MAIN ======================

# ENTRY: check args
if len(sys.argv) != 3:
    print("\033[93mUsage:\n\tpython3 fuchs.py [-t | <input_filename>] <output_filename>")
    print("\nFlag:\n\t-t\tRead data from terminal\033[0m")
    exit(1)
ifname = sys.argv[1]
ofname = sys.argv[2]
if ifname == "-t":
    ifname = sys.stdin.fileno()

# PREPARE: ?

# BEGIN: read data
try:
    N, G, T = read_graph(open(ifname, "r"))
except FileNotFoundError:
    print(f"\033[91m'{ifname}' is not a valid file!\033[0m")
    exit(2)

# SOLVE: find Steiner tree and calculate time taken in milliseconds
start = time.perf_counter_ns()
cost, edges = steiner_tree(N, G, T)
end = (time.perf_counter_ns() - start) / 1e6

# RESULT: print data to console and write total weight to file
print("DYNAMIC")
if cost is None:
    print("No Steiner tree found.")
else:
    try:
        open(ofname, "w").write(f"{cost}")
    except FileNotFoundError:
        print(f"\033[91m'{ofname}' is not a valid file!\033[0m")
    print(f"Minimum weight: {cost}")
    for u, v in edges:
        for tri in G:
            if u == tri[0] and v == tri[1]: w = tri[2]
        print(f"  {u} - {v} (weight {w})")
print("Time elapsed (DP): %.4f ms\n" % end)
