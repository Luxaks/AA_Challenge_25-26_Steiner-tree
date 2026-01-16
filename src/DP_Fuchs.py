import heapq
import random
import time
from collections import defaultdict

INF = 10**18


# ================== DIJKSTRA ==================
def dijkstra(n, graph, src):
    dist = [INF] * n
    parent = [-1] * n
    dist[src] = 0
    pq = [(0, src)]

    while pq:
        d, u = heapq.heappop(pq)
        if d != dist[u]:
            continue
        for v, w in graph[u]:
            nd = d + w
            if nd < dist[v]:
                dist[v] = nd
                parent[v] = u
                heapq.heappush(pq, (nd, v))

    return dist, parent


# ================== STEINER TREE ==================
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
            for v, w in graph[u]:
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
                edges.add(tuple(sorted((p, cur))))
                cur = p
        elif t[0] == 'merge':
            build(t[1], v)
            build(mask ^ t[1], v)
        elif t[0] == 'move':
            u = t[1]
            edges.add(tuple(sorted((u, v))))
            build(mask, u)

    build(full, end)
    return cost, edges


# ================== GENERARE GRAF RANDOM CONEX ==================
def generate_random_connected_graph(n):
    graph = defaultdict(list)

    def add_edge(u, v):
        w = random.randint(1, 8)
        graph[u].append((v, w))
        graph[v].append((u, w))

    # Lant de baza (asigura conectivitate)
    for i in range(n - 1):
        add_edge(i, i + 1)

    # Muchii suplimentare random
    extra_edges = n * 2
    for _ in range(extra_edges):
        u = random.randint(0, n - 1)
        v = random.randint(0, n - 1)
        if u != v:
            add_edge(u, v)

    return graph


# ================== INPUT + MAIN ==================
def read_input():
    n, k = map(int, input().split())
    terminals = list(map(int, input().split()))
    return n, terminals


if __name__ == "__main__":
    n, terminals = read_input()
    graph = generate_random_connected_graph(n)

    start = time.perf_counter()

    cost, edges = steiner_tree(n, graph, terminals)

    end = time.perf_counter()

    print("Timp executie (fara IO):", end - start, "secunde")

    print("Numar noduri:", n)
    print("Terminale:", terminals)
    print("Cost minim Steiner:", cost)
    print("Numar muchii arbore:", len(edges))
