// Steiner tree NP-hard demonstration

Se demonstrează că problema Steiner Tree este NP-hard prin reducerea polinomială a problemei Exact Cover la aceasta. Demonstrația se bazează pe descrierea celor 21 de probleme _NP-complete_ a cercetătorului în teorie algoritmică și computațională Richard~Karp.@karp

== Definiții.
- *Exact Cover* este o problemă de satisfacere care propune găsirea unui set $C$ de submulțimi $S_i in S$ ale unei mulțimi date $U$. Varianta _3-Set Exact Cover_ (X3C) limitează submulțimile la exact 3 elemente.\
 Scopul problemei este ca setul de submulțimi găsite să formeze o acoperire a mulțimii inițiale, adică $ U= union.big_(S_i in C) S_i $$  forall S_i,S_j in C, space S_i inter S_j = emptyset. $

*Propoziție 1.*
În varianta X3C, întrucât submulțimile $S_i$ conțin câte 3 elemente, atunci $|C|=1/3|U|$.

- *Clasele de complexitate* sunt grupări ale problemelor de decizie, în funcție de modul de rezolvare al acestora. Clasa _*NP-hard*_ conține problemele care pot rezolva probleme _NP_ (nedeterminist polinomiale) printr-o transformare în timp polinomial. Dacă ele însele aparțin și clasei _NP_ , atunci se numesc probleme~_NP-complete_.\
 O consecință este că, dacă se cunoaște o problemă _NP-hard_ sau _NP-completă_ și se demonstrează rezolvarea acesteia printr-o altă problemă, atunci și a doua este cel puțin _NP-hard_ prin tranzitivitate.

*Propoziție 2.*
Se consideră o problemă $A$ care rezolvă o problemă $B$ _NP-hard_.\
Întrucât $B$ rezolvă orice problemă _NP_, atunci și $A$ rezolvă orice problemă _NP_ prin $B$, deci este _NP-hard_.

- *Reducerea polinomială* (numită și reducere Karp) este transformarea intrării unei probleme $B$ în intrarea pentru o problemă $A$ în timp polinomial (funcție de transfer), indiferent de complexitatea algoritmilor care rezolvă cele 2 probleme. Aceasta se notează $B <=#sub[p] A$. În urma demonstrării posibilității reducerii unei probleme la alta, se poate afirma că problema $A$ o rezolvă pe $B$.

*Ipoteză.*
Se cunoaște faptul că X3C este NP-hard.\
Dacă X3C se poate reduce la Steiner Tree, conform *propoziției 2*, atunci și ST este NP-hard.

== Funcția de transfer.
+ *Noduri.*
 - Pentru fiecare element $u in U$ se creează un nod $v_u$​.
 - Pentru fiecare submulțime $S_i​ in S$ se creează un nod $s_i$​.
 - Se mai creează nodul rădăcină $r$.

 Astfel, nodurile grafului-input pentru ST vor fi $ G(V)={v_u​ | u in U} union {s_i | S_i​ in S} union {r}. $

+ *Muchii.*
 - Pentru fiecare $s_i$​ și $u in S_i$​ se adaugă muchia $(s_i​,v_u​)$ cu greutatea 1.
 - Pentru fiecare $s_i$​ se adaugă muchia $(r,s_i​)$ cu greutatea 2.

 Deci muchiile grafului construit vor fi $ G(E)={(s_i,v_u,1) | u in S_i} union {(r,s_i,2) | S_i in S}. $

+ *Terminale.*\
 Setul de terminale este $T={v_u​ ∣ u in U} union {r}$.\
 Dintre nodurile neterminale $s_i$​ se vor alege punctele Steiner (de legătură).  

+ *Limita costului.*\
 Se setează în plus un cost maxim $k'=5k$, unde $k=1/3|U|$.

== *$bullet.tri "X3C" arrow.r.double "ST"$*
Presupunem că există $C subset.eq S$ o acoperire. Conform *propoziției 1*, $|C|=k in NN$.\
Se construiește arborele Steiner folosind $s_i$ ca puncte de legătură. Întrucât $forall S_i$ avem 3 elemente distincte (nu se mai găsesc în altă submulțime), fiecare $s_i$ duce la nodurile $v_u$ corespunzătoare fără repetări, acoperindu-se astfel toate $v_u$.

Reamintim că muchiile $(r,s_i)$ au greutate $w_s=2$, iar muchiile $(s_i,v_u)$ au $w_u=1$.\
Costul total al acestui arbore este $ k''=|C|*w_s + |U|*w_u=k*2 + 3k*1 $ deci $k''=k'=5k.$
Deoarece costul obținut este egal cu costul maxim admis, arborele este optim.

== *$bullet.tri "X3C" arrow.l.double "ST"$*
Presupunem că există un arbore Steiner $R$ cu cost $<= k'$. Pentru a conecta $r$ la orice $v_u$, este nevoie să trecem prin $s_i$. În plus, $forall s_i$ dacă $d_i > 0$ (numărul de muchii de forma $(s_i,v_u)$) înseamnă că este inclusă și muchia $(r,s_i)$, și vice-versa ($s_i$ sunt noduri intermediare, dacă nu sunt legate de niciun $v_u$ atunci sunt înlăturate din soluția $R$). Ca atare, costul total devine $ sum_(s_i in R)(w_s + d_i) $
deoarece $w_u=1$ (deci costul între $s_i$ și toate $v_u$ conectate este $1*d_i$).\
Fie $q$ numărul de noduri $s_i$ folosite. Prin formula anterioară, costul este $ 2q + sum_(s_i in R) d_i $
Însă toate $v_u$ trebuie conectate, deci $ sum_(s_i in R)d_i=|U|=3k $
Deci costul final este $ 2q+3k<=k'=5k space arrow.r.double space 2q<=2k space arrow.r.double space q<=k. $
Dar nu este posibil să avem $q<k$ deoarece nu ar exista destule muchii pentru a include toate $v_u$. Astfel se obține chiar $q=k$ și toate nodurile intermediare $s_i$ folosite formează $C subset.eq S$ partiția lui $U$.
