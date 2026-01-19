// bt implementation description + analysis

== Algoritmul de bază --- Backtracking.
Algoritmul inițial se bazează pe tehnica Backtracking pentru verificarea riguroasă a tuturor soluțiilor posibile. Ca atare, deși se asigură faptul că se va obține mereu soluția cea mai bună, rularea programului devine înceată pentru seturi mari de date de intrare.

Algoritmul se bazează pe explorarea tuturor submulțimilor de muchii ale grafului, verificând la fiecare pas dacă soluția curentă este validă (conține toate terminalele) și dacă este de cost minim temporar. În acest fel, trecând prin toate combinările posibile de muchii, pornind de la mulțimea întreagă și eliminând pe rând muchiile, complexitatea crește către $2^m$ combinații, unde $m=|E|$ este numărul de muchii ale grafului inițial.

Pentru verificarea fiecărei submulțimi se execută funcţia auxiliară _`connected`_, care construiește o listă de adiacență din muchiile curente și rulează o căutare în lățime (BFS) pe $n=|V|$, numărul total de noduri. La final, funcția determină astfel dacă terminalele sunt conținute în subgraful ales. Datorită folosirii metodei optimizate _`set.issubset`_ (dacă setul de terminale este conținut printre nodurile subgrafului), numărul de terminale nu afectează semnificativ complexitatea acestei verificări.

În cel mai rău caz timpul este $O(2^m*(n+m))$, dominat de creșterea exponențială după numărul de muchii ale grafului. Verificarea greutății la fiecare pas poate reduce numărul de ramuri (dacă subgraful curent are deja cost mai mare decât minimul temporar, nu se mai continuă cu adăugarea muchiilor pe acesta), însă ordinul exponențial rămâne la analiza asimptotică pentru cel mai rău caz.

Această implementare asigură deci corectitudinea în următorul mod:
+ Orice soluție găsită are cost minim.\
 Soluțiile sunt admise doar dacă au cost mai mic decât toate soluțiile examinate până în acel punct. La încheierea execuției, se vor fi examinat toate soluțiile posibile, deci răspunsul final (dacă există) este punctul de minim global.
 
+ Orice soluție conține terminalele.\
 Întrucât se aplică verificarea pe toate variantele considerate, numai subgrafurile care satisfac această condiție vor fi admise ca soluții posibile.
 
+ Orice soluție este arbore (subgraf conex aciclic).\
 _Conexitatea_ este garantată prin *condiția 2*, deoarece toate terminalele trebuie să aparțină aceluiași subgraf.\
 _Aciclicitatea_ este asigurată de *condiția 1*, pentru că orice muchie care aduce cost în plus va fi eliminată, deci ciclii sunt reduși la legături liniare între terminale și celelalte noduri.

Graful inițial, fiind neorientat, este construit ca o listă de muchii distincte. Analog, la fiecare pas recursiv, lista de muchii alese conține cel mult $m$ dintre acestea, deci complexitatea de memorie este $O(m)$ în orice moment. În cadrul funcției _`connected`_, se formează un dicționar pentru verificarea adiacenței nodurilor, de mărime $O(n+m)$. În plus, stiva de apeluri recursive are adâncime maximă tot $m$.

*Complexitatea temporală totală:* $ O(2^m*(n+m))=O(2^m) $
*Complexitatea de memorie:* $ O(n+m) $
Unde:
- $n$ este numărul de noduri
- $m$ este numărul de muchii.

#align(center, table(
  columns: (1fr, 1fr),
  rows: (2.5em, 4.5em),
  inset: 7pt,
  align: horizon,
  table.header(
    [*Avantaje*], [*Dezavantaje*]
  ),
  [
    - Soluția este corectă întotdeauna
    - Consumul memoriei este liniar
  ],
  [
    - Complexitatea de timp este foarte mare, crescând exponențial după numărul de muchii
  ]
))