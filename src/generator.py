import random
import sys

#=============== GENERARE GRAF RANDOM CONEX ===============
def generate(n):
    graph = list()
    added = list()

    def add_edge(u,v):
        if u > v: u, v = v, u
        if u != v and (u,v) not in added:
            graph.append((u, v, random.randint(1,10)))
            added.append((u,v))

    # Lant de baza (asigura conectivitate)
    for i in range(n-1):
        add_edge(i, i+1)
        
    # Muchii suplimentare random
    for _ in range(2*n):
        add_edge(random.randint(0, n-1), random.randint(0, n-1))

    return graph

#================== PRINTARE GRAF GENERAT =================
def write(n, t, graph):
    terms = set()

    # terminals
    for _ in range(t):
        terms.add(random.randint(0,n-1))

    print(n, len(graph), len(terms))
    print(' '.join(str(x) for x in terms))
    for u,v,w in graph:
        print(u,v,w)

#=============== CITIRE DATE, APELARE METODE ==============
try:
    n = int(sys.argv[1])
    t = int(sys.argv[2])
    write(n, t, generate(n))
except:
    print("\033[91m\n            Bad input.")
    print("\033[93mUsage: python3 generator.py <n> <t>")
    print("      n - Number of vertices")
    print("      t - Number of terminals\033[93m")
    exit(1)