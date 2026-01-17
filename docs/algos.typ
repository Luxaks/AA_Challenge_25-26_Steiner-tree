// 
//    Descrierea modului în care funcționează algoritmii aleși. [5%]
//    Analiza complexitații soluțiilor. [10%]
//    Prezentarea principalelor avantaje și dezavantaje pentru soluțiile luate în considerare. [5%]

== Modul în care funcționează algoritmii aleși

=== Backtracking


=== Greedy - metoda Takahashi & Matsuyama


=== Programare dinamică - metoda Fuchs

Abordarea de tip programare dinamică implementată este cea a lui *Fuchs*, optimizată față de formularea clasică a algoritmului lui *Dreyfus-Wagner*, fiind adaptată pentru grafuri neorientate ponderate și un număr relativ mic de terminale. Această abordare urmărește construirea incrementală a unui arbore Steiner optim prin combinarea unor soluții parțiale corespunzătoare submulțimilor de terminale. Complexitatea temporală a algoritmului este exponențială în numărul de terminale k, datorită faptului că pentru fiecare subset de terminale se calculează soluții parțiale, iar complexitatea de memorie este proporțională cu $n * 2^k$, unde n este numărul total de noduri.

Algoritmul începe în cadrul funcției *steiner_tree*, unde, pentru fiecare nod terminal, se apelează funcția *dijkstra* pentru a calcula distanțele minime de la acel terminal către toate celelalte noduri ale grafului. Această etapă are complexitate temporală $O(k * (n + m) * log n)$, unde m este numărul de muchii, iar complexitatea de memorie este $O(n * k)$, deoarece trebuie stocate distanțele minime de la fiecare terminal către toate nodurile. Fiecare terminal este tratat inițial ca un arbore Steiner trivial, format doar din drumul minim dintre terminal și un nod arbitrar din graf; aceste situații constituie cazurile de bază ale programării dinamice și se realizează în timp $O(n * k)$.

Pe baza acestor cazuri de bază, algoritmul construiește progresiv soluții mai complexe folosind un tabel de programare dinamică indexat după submulțimi de terminale. Pentru fiecare submulțime de terminale, se determină costul minim al unui arbore Steiner care conectează exact acele terminale și se termină într-un anumit nod al grafului. Această etapă are complexitate temporală $O(n * 4^k)$, deoarece pentru fiecare submulțime trebuie combinate toate perechile de submulțimi disjuncte, iar complexitatea de memorie rămâne $O(n * 2^k)$.

Un pas esențial al algoritmului îl reprezintă cazul de tip *MERGE*, în care o submulțime de terminale este împărțită în două submulțimi disjuncte. Arborii Steiner corespunzători acestor submulțimi sunt apoi uniți într-un nod comun, obținându-se un arbore mai mare care conectează toate terminalele din submulțimea inițială. Complexitatea temporală pentru acest pas este $O(n * 3^k)$, deoarece pentru fiecare submulțime trebuie examinate toate diviziunile posibile în două submulțimi disjuncte, iar memoria necesară rămâne aceeași, $O(n * 2^k)$.

După combinarea submulțimilor, algoritmul aplică cazul de tip *MOVE*, care permite deplasarea punctului de întâlnire al arborelui Steiner de-a lungul muchiilor grafului. Acest lucru se realizează printr-o relaxare de tip Dijkstra, pornind de la nodurile pentru care există deja un cost calculat. Complexitatea temporală pentru această etapă este $O(n * m * 2^k)$, deoarece pentru fiecare submulțime și pentru fiecare nod se aplică relaxarea, iar complexitatea de memorie nu se modifică semnificativ, rămânând $O(n * 2^k)$.

Pe măsură ce toate submulțimile de terminale sunt procesate, algoritmul ajunge la submulțimea completă, care conține toate terminalele problemei. Dintre toate nodurile grafului, se selectează acel nod pentru care costul asociat este minim, acesta reprezentând punctul final al arborelui Steiner optim. Această etapă este liniară în n și nu afectează complexitatea totală, dar face parte din pasul final de selecție.

În etapa finală, soluția este reconstruită folosind funcția build, care urmărește deciziile salvate pe parcursul programării dinamice. În funcție de tipul fiecărei decizii, reconstrucția tratează distinct cazurile de bază, de unire a submulțimilor și de deplasare pe muchii, obținând astfel explicit muchiile arborelui Steiner. Complexitatea temporală a reconstrucției este $O(n * 2^k)$, deoarece pentru fiecare submulțime și nod se poate parcurge drumul salvat, iar complexitatea de memorie este deja inclusă în tabela de programare dinamică. Prin această reconstrucție recursivă se garantează că arborele rezultat conectează toate terminalele și are cost minim.


Complexitatea temporală totală:

$O(3^k * n + 2^k * m * log(n))$, unde:

k - nr de terminali, 
n - nr de noduri, 
m - nr de muchii



Complexitatea de memorie:

$O(2^k * n)$

Avantaje:
- timpul de execuție fezabil pentru o problema NP-Complete;
- arantează obținerea soluției optime.

Dezavantaje:
- consum ridicat de memorie;
- complexitatea de implementare.


credit:
- cod dp https://github.com/ShahjalalShohag/code-library/blob/main/Graph%20Theory/Steiner%20Tree%20Problem.cpp + ChatGPT;
- informatii implemetare: https://blogs.asarkar.com/assets/docs/algorithms/Dynamic%20Programming%20for%20Minimum%20Steiner%20Trees.pdf