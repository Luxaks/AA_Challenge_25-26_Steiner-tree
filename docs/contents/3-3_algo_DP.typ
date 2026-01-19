// dp implementation description + analysis

== Algoritm euristic Dynamic Programming --- Metoda Fuchs.
Abordarea de tip programare dinamică implementată este cea a lui *Fuchs*, optimizată față de formularea clasică a algoritmului *Dreyfus-Wagner*.@dw_method @fuchs @dp_code Această abordare urmărește construirea unui arbore Steiner optim prin combinarea unor soluții parțiale corespunzătoare submulțimilor de terminale. Complexitatea temporală a algoritmului este exponențială în numărul de terminale $k=|T|$, datorită faptului că pentru fiecare subset de terminale se calculează soluții parțiale, iar complexitatea de memorie este $O(n*2^k)$, unde $n=|V|$ este numărul total de noduri.

Algoritmul începe în cadrul funcției _`steiner_tree`_, unde, pentru fiecare nod terminal, se apelează funcția _`dijkstra`_ pentru a calcula distanțele minime de la acel terminal către toate celelalte noduri ale grafului. Această etapă are complexitate temporală $O(k*(n+m)*log n)$, unde $m=|E|$ este numărul de muchii ale grafului, iar complexitatea de memorie este $O(n*k)$, deoarece trebuie stocate distanțele minime de la fiecare terminal către toate nodurile. Fiecare terminal este tratat inițial ca un arbore Steiner trivial, format doar din drumul minim dintre terminal și un nod arbitrar din graf; aceste situații constituie cazurile de bază ale programării dinamice și se realizează în timp $O(n * k)$.

Pe baza acestor cazuri de bază, algoritmul construiește progresiv soluții mai complexe folosind un tabel DP indexat după submulțimi de terminale. Pentru fiecare submulțime de terminale, se determină costul minim al unui arbore Steiner care conectează exact acele terminale și se termină într-un anumit nod al grafului. Această etapă are complexitate temporală $O(n*4^k)$, deoarece pentru fiecare submulțime trebuie combinate toate perechile de submulțimi disjuncte, iar complexitatea de memorie rămâne $O(n*2^k)$.

Următorul pas al algoritmului îl reprezintă cazul de tip *MERGE*, în care o submulțime de terminale este împărțită în două submulțimi disjuncte. Arborii Steiner corespunzători acestor submulțimi sunt apoi uniți într-un nod comun. Complexitatea temporală pentru acest pas este $O(n*3^k)$, deoarece pentru fiecare submulțime trebuie examinate toate diviziunile posibile în două submulțimi, iar memoria necesară rămâne $O(n*2^k)$.

După combinarea submulțimilor, algoritmul aplică cazul de tip *MOVE*, care permite deplasarea punctului de întâlnire al arborelui Steiner de-a lungul muchiilor grafului. Acest lucru se realizează printr-o relaxare de tip Dijkstra, pornind de la nodurile pentru care există deja un cost calculat. Complexitatea temporală pentru această etapă este $O(n*m*2^k)$, deoarece pentru fiecare submulțime și pentru fiecare nod se aplică relaxarea, iar complexitatea de memorie rămâne $O(n*2^k)$.

Pe măsură ce toate submulțimile de terminale sunt procesate, algoritmul ajunge la submulțimea completă, care conține toate terminalele problemei. Dintre toate nodurile grafului, se selectează acel nod pentru care costul asociat este minim, acesta reprezentând punctul final al arborelui Steiner optim.

În etapa finală, soluția este reconstruită folosind funcția build, care urmărește deciziile salvate pe parcursul programării dinamice. În funcție de tipul fiecărei decizii, reconstrucția tratează distinct cazurile de bază, de unire a submulțimilor și de deplasare pe muchii, obținând astfel muchiile arborelui Steiner. Complexitatea temporală a reconstrucției este $O(n*2^k)$, deoarece pentru fiecare submulțime și nod se poate parcurge drumul salvat. Prin această reconstrucție recursivă se garantează că arborele rezultat conectează toate terminalele și are cost minim.

Având comparativ mult mai puține terminale decât noduri totale sau muchii, algoritmul Fuchs cu DP devine mai eficient decât abordarea cu BT.

*Complexitatea temporală totală:* $ O(3^k*n+2^k*m*log n)=O(3^k+2^k) $
*Complexitatea de memorie:* $ O(n*2^k)=O(2^k) $
Unde:
- $k$ este numărul de terminale 
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
    - Timpul de execuție este fezabil la intrări mici
    - Garantează obținerea soluției optime foarte des
  ],
  [
    - Consum ridicat de memorie
    - Implementare destul de dificilă
  ]
))