# Implementare in Python a unei metode dinamice pentru problema Steiner (varianta Dreyfus-Wagner / stil Fuchs).
# Comentarii in romana. Functia `steiner_tree` returneaza costul minim si multimea de muchii ale arborelui Steiner.
# Algoritmul foloseste DP pe submultimi (bitmask) + Dijkstra pentru propagarea distantelor.
# Reconstructia arborelui este inclusa (urmarind parintii din combinatii si din Dijkstra).
# Aceasta implementare reflecta abordarea "programare dinamica" folosita in lucrari precum Dreyfus-Wagner
# si este compatibila cu ideile imbunatatitoare din Fuchs (optimizari pe submultimi), in practica.

import heapq
from collections import defaultdict

INF = 10**18

def dijkstra(n, graph, src):
    # graph: dict u -> list of (v, w)
    dist = [INF]*n
    parent = [-1]*n
    dist[src] = 0
    pq = [(0, src)]
    while pq:
        d,u = heapq.heappop(pq)
        if d!=dist[u]: continue
        for v,w in graph[u]:
            nd = d + w
            if nd < dist[v]:
                dist[v] = nd
                parent[v] = u
                heapq.heappush(pq, (nd, v))
    return dist, parent

def steiner_tree(n, graph, terminals):
    """
    n: numar de noduri (0..n-1)
    graph: dict: u -> list of (v, w) (nedirecționat - fiecare muchie trebuie adăugată pentru ambele sensuri)
    terminals: list of vertex indices that must be connected
    Return: (min_cost, set_of_edges_as_tuples)
    """
    k = len(terminals)
    if k == 0:
        return 0, set()
    # Precompute Dijkstra from each terminal (singleton base states)
    dist_from_term = []
    parent_from_term = []
    for t in terminals:
        dist, parent = dijkstra(n, graph, t)
        dist_from_term.append(dist)
        parent_from_term.append(parent)
    
    FULL = (1<<k)
    # dp[mask][v] = best cost to connect terminals in mask and end at vertex v
    # We'll store dp as list of lists (masks x vertices)
    dp = [[INF]*n for _ in range(FULL)]
    # trace to reconstruct: trace[(mask, v)] = tuple describing how dp[mask][v] was obtained
    # types:
    # ('base', term_index) -> came from shortest path from terminal term_index to v (use parent_from_term)
    # ('merge', submask) -> dp[mask][v] = dp[submask][v] + dp[mask^submask][v]
    # ('move', prev_v) -> dp[mask][v] = dp[mask][prev_v] + weight(prev_v, v)
    trace = dict()
    
    # Initialize singletons
    for i in range(k):
        bit = 1<<i
        for v in range(n):
            d = dist_from_term[i][v]
            if d < INF:
                dp[bit][v] = d
                trace[(bit, v)] = ('base', i)
    
    # Iterate masks in increasing number of bits
    # For masks > singleton: try merging two submasks and then run Dijkstra to propagate along edges
    for mask in range(1, FULL):
        # skip singletons (already initialized), but still need Dijkstra propagation (if not done)
        # To avoid redundant work for singletons, we'll still run Dijkstra for each mask so that dp[mask] is shortest over graph.
        # Before running Dijkstra, try merging partitions to improve dp[mask][v].
        if (mask & (mask - 1)) != 0:  # more than one bit
            # iterate proper non-empty submasks with canonical ordering to avoid symmetric duplicates
            lb = mask & -mask  # lowest bit set
            sub = (mask-1) & mask
            while sub:
                if sub & lb:  # ensure we only consider one side of partition (avoids duplicates)
                    other = mask ^ sub
                    # combine at every vertex v
                    for v in range(n):
                        val = dp[sub][v] + dp[other][v]
                        if val < dp[mask][v]:
                            dp[mask][v] = val
                            trace[(mask, v)] = ('merge', sub)
                sub = (sub-1) & mask
        
        # Now run multi-source Dijkstra for this mask to propagate along edges
        dist = dp[mask][:]  # initial distances
        pq = [(dist[v], v) for v in range(n) if dist[v] < INF]
        heapq.heapify(pq)
        while pq:
            d,u = heapq.heappop(pq)
            if d != dist[u]: continue
            for v,w in graph[u]:
                nd = d + w
                if nd < dist[v]:
                    dist[v] = nd
                    trace[(mask, v)] = ('move', u)
                    heapq.heappush(pq, (nd, v))
        dp[mask] = dist
    
    full_mask = FULL - 1
    # find best endpoint
    best_v = min(range(n), key=lambda x: dp[full_mask][x])
    best_cost = dp[full_mask][best_v]
    if best_cost >= INF:
        return None, None  # no Steiner tree (disconnected)
    
    # Reconstruct edges: recursive
    edges = set()
    visited_states = set()
    
    # helper to reconstruct base path from terminal i to vertex v (use parent_from_term[i])
    def reconstruct_base_path(term_idx, v):
        path = []
        cur = v
        parent = parent_from_term[term_idx]
        tvertex = terminals[term_idx]
        while cur != -1 and cur != tvertex:
            p = parent[cur]
            if p == -1:
                # Already at terminal? or disconnected (shouldn't happen)
                break
            # add edge (p, cur)
            edges.add(tuple(sorted((p, cur))))
            cur = p
        # no return, edges updated
    
    def build(mask, v):
        if (mask, v) in visited_states:
            return
        visited_states.add((mask, v))
        info = trace.get((mask, v))
        if info is None:
            return
        typ = info[0]
        if typ == 'base':
            term_idx = info[1]
            reconstruct_base_path(term_idx, v)
            return
        elif typ == 'merge':
            sub = info[1]
            other = mask ^ sub
            # both parts meet at v
            build(sub, v)
            build(other, v)
            return
        elif typ == 'move':
            prev = info[1]
            # edge prev -- v used
            edges.add(tuple(sorted((prev, v))))
            build(mask, prev)
            return
        else:
            return
    
    build(full_mask, best_v)
    return best_cost, edges

from collections import defaultdict
import random

# Presupunem ca functia steiner_tree este deja definita in sesiune

def main_1000_nodes():
    n = 1000
    graph = defaultdict(list)

    def add_edge(u, v, w):
        graph[u].append((v, w))
        graph[v].append((u, w))

    # === STRUCTURA GRAFULUI ===
    # Vom crea:
    # - un cluster mic cu 2 terminale apropiate
    # - 5 terminale indepartate
    # - restul noduri Steiner conectate in lanturi + legaturi alternative

    # ---- Cluster apropiat (terminalele 0 si 1) ----
    add_edge(0, 1, 1)
    for i in range(2, 20):
        add_edge(i - 1, i, 1)

    # ---- Conectare spre "coloana vertebrala" ----
    add_edge(19, 20, 5)

    # ---- Coloana principala (noduri Steiner) ----
    # Lant lung care conecteaza aproape tot graful
    for i in range(20, 999):
        add_edge(i, i + 1, 3)

    # ---- Legaturi alternative (shortcut-uri Steiner) ----
    for i in range(20, 900, 50):
        add_edge(i, i + 25, 6)

    # ---- Terminale departate ----
    terminals = [
        0,      # apropiat
        1,      # apropiat
        200,
        400,
        600,
        800,
        999,
        111,
        10,
    ]
    ''' CAUTION! MIGHT BE FATAL! :)
    962,
    777,
    481,
    222,
    309,
    641,
    30,
    555,
    888,
    823,
    811,
    511,
    591,
    611,
    422,
    499,
    817,
    717,
    676,
    680,
    191,
    814,
    314,
    181'''
    

    cost, edges = steiner_tree(n, graph, terminals)

    print("Numar noduri:", n)
    print("Numar terminale:", len(terminals))
    print("Terminale:", terminals)
    print("Cost minim Steiner:", cost)
    print("Numar muchii in arbore:", len(edges))

    # Afisam doar primele 20 muchii (pentru lizibilitate)
    print("Primele muchii din arborele Steiner:")
    for e in list(sorted(edges))[:20]:
        print(e)


if __name__ == "__main__":
    main_1000_nodes()