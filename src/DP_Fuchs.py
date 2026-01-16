import heapq
from collections import defaultdict

# Valoare mare folosita ca infinit
INF = 10**18


# ======================================================
# ALGORITM DIJKSTRA
# Calculeaza distantele minime de la un nod sursa
# catre toate celelalte noduri din graf
# ======================================================
def dijkstra(n, graph, src):
    dist = [INF] * n          # distanta minima pana la fiecare nod
    parent = [-1] * n         # parinte pentru reconstructia drumului
    dist[src] = 0

    pq = [(0, src)]           # coada de prioritati (distanta, nod)

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


# ======================================================
# STEINER TREE PROBLEM - PROGRAMARE DINAMICA
# Implementare tip Dreyfus-Wagner / Fuchs
# dp[mask][v] = cost minim pentru a conecta
# terminalele din mask si a ajunge in nodul v
# ======================================================
def steiner_tree(n, graph, terminals):
    k = len(terminals)
    FULL = 1 << k

    # Precalculam distantele minime de la fiecare terminal
    dist_term = []
    parent_term = []
    for t in terminals:
        d, p = dijkstra(n, graph, t)
        dist_term.append(d)
        parent_term.append(p)

    # Tabelul de programare dinamica
    dp = [[INF] * n for _ in range(FULL)]

    # Structura pentru reconstructia arborelui
    trace = {}

    # Cazuri de baza: un singur terminal
    for i in range(k):
        mask = 1 << i
        for v in range(n):
            dp[mask][v] = dist_term[i][v]
            trace[(mask, v)] = ('base', i)

    # Parcurgem toate submultimile de terminale
    for mask in range(1, FULL):

        # Combinam doua submultimi mai mici
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

        # Dijkstra multi-sursa pentru a propaga solutiile
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

    # Alegem nodul final cu cost minim
    full = FULL - 1
    end = min(range(n), key=lambda v: dp[full][v])
    cost = dp[full][end]

    edges = set()
    visited = set()

    # Reconstructia arborelui Steiner
    def build(mask, v):
        if (mask, v) in visited:
            return
        visited.add((mask, v))

        t = trace[(mask, v)]

        if t[0] == 'base':
            # Reconstructie drum de la terminal
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


# ======================================================
# FUNCTIE DE CITIRE A INPUTULUI
# Format:
# n m k
# t1 t2 ... tk
# u v w  (m linii)
# ======================================================
def read_input():
    n, m, k = map(int, input().split())
    terminals = list(map(int, input().split()))

    graph = defaultdict(list)
    for _ in range(m):
        u, v, w = map(int, input().split())
        graph[u].append((v, w))
        graph[v].append((u, w))

    return n, graph, terminals


# ======================================================
# MAIN
# Citeste datele, ruleaza algoritmul si afiseaza rezultatul
# ======================================================
if __name__ == "__main__":
    n, graph, terminals = read_input()
    cost, edges = steiner_tree(n, graph, terminals)

    print("Cost minim Steiner:", cost)
    #print("Muchii arbore Steiner:")
    #for e in sorted(edges):
        #print(e)
