// greedy implementation description + analysis

== Algoritm euristic Greedy --- Metoda Takahashi-Matsuyama.
Primul dintre algoritmii optimizați implementați urmează metoda Greedy, descrisă de Takahashi Hiromitsu și Matsuyama Akira în 1980.@apx_overview @apx_algo @tkmy_method Acesta caută subgraful optim prin alegerea celui mai scurt drum către terminale la fiecare pas.

Bucla principală Greedy rulează pentru fiecare terminal în afară de primul (acesta este considerat rădăcina arborelui soluție). La fiecare iterație, pentru fiecare terminal se verifică dacă s-a calculat deja distanța către celelalte noduri, și dacă nu, se aplică funcția _`dijkstra`_, care are complexitate $O((n+m)log n)$, unde $n=|V|$ numărul de noduri și $m=|E|$ numărul de muchii.

Apoi se verifică care este distanța minimă astfel încât orice terminal neadăugat în arbore să ajungă la orice nod din acesta. Acest pas are complexitate $O(k*n)$, deoarece practic se verifică distanța dintre fiecare terminal și fiecare alt nod, având $k=|T|$ numărul de terminale.

La prima iterație, complexitatea va include și pasul Dijkstra, însă după salvarea rezultatelor nu se vor mai face decât verificările de minim.

Din punctul de vedere al memoriei, graful este stocat ca mai sus, ca listă de 3-tupli (nod $u$, nod $v$, greutatea $u->v$) cu $O(m)$. În plus se stochează rezultatele Dijkstra cu mărime $O(k*n)$ și soluțiile de mărime $O(n+m)$ (setul de noduri incluse și setul de muchii ale arborelui).

Trebuie menționat că orice algoritm Greedy, pentru a fi corect, trebuie să respecte două proprietăți:
+ *Greedy Choice Property.* Alegerea făcută la orice pas este optimă și duce la o soluție finală optimă. Aceasta se demonstrează uzual prin presupunerea că opțiunea noastră este cel puțin la fel de bună (dacă nu chiar mai bună) decât orice alternativă, fiind astfel alegerea ideală.

+ *Substructura optimală.* Aceasta derivă din GCP și reprezintă soluția parțială la orice pas, care este soluția optimă pentru subproblema procesată până la acel punct. Cu alte cuvinte, dacă $S_1={s_1,s_2,...s_(k-1)}$ este soluție optimă la pasul curent, atunci și submulțimea $S_2={s_1,s_2,...s_k}$ este soluție optimă pentru pasul următor.

În cazul metodei Greedy pentru Steiner Tree, se poate observa că aceasta, de fapt, nu este corectă, deoarece nu respectă proprietatea fundamentală _GCP_. Motivul este că, deși putem găsi un drum optim la un pas, nu se poate garanta întotdeauna că acesta duce la arborele de cost minim.

În schimb, algoritmul Takahashi-Matsuyama oferă o _aproximare_ a rezultatului, având de partea sa viteza cu mult îmbunătățită față de un algoritm mai riguros. Datorită acestui avantaj, cuplat cu erorile în general mici produse de algoritm, această soluție poate fi considerată viabilă și chiar preferabilă în situații cu date de intrare mari.

*Complexitatea temporală totală:* $ O(k(n+m)log n+k*n+m)=O(k(n+m)log n) $
*Complexitatea de memorie:* $ O(k*n+m)​ $
Unde:
- $n$ este numărul de noduri
- $m$ este numărul de muchii
- $k$ este numărul de terminale.

#align(center, table(
  columns: (1fr, 1fr),
  rows: (2.5em, 4.5em),
  inset: 7pt,
  align: horizon,
  table.header(
    [*Avantaje*], [*Dezavantaje*]
  ),
  [
    - Viteză foarte bună (aproape $200 times$)
    - Consum de memorie scăzut
  ],
  [
    - Rezultatul nu este întotdeauna corect, dar este îndeajuns de apropiat în majoritatea situațiilor
  ]
))