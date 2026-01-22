// testing results

În urma realizării celor 3 programe, testele au fost formulate pe baza specificațiilor oferite pentru acest proiect. Ca atare, fișierele de intrare sunt de forma:
- $n$, $m$, $k$ (numărul de noduri, muchii, terminale pe prima linie)
- cele $k$ terminale pe a doua linie (numere între 0 și $n-1$)
- ultimele $m$ linii cu $u$, $v$, $w$ (muchiile $u arrow.long^w v$).

Pentru ajutor la alegerea datelor de intrare, au fost folosite 2 metode:
- generarea vizuală a grafurilor cu unelte online@graph_visual @st_visual
- generarea de grafuri aleatorii folosind programul _`generator.py`_, care primește $n$ și $k$ și generează graful și lista de terminale cu _`random.randint`_, asigurând însă conexitatea.

A fost adăugată în plus opțiunea de a citi datele de intrare și de la tastatură. Acest lucru poate fi folosit și pentru a trece output-ul lui _`generator`_ direct în algoritmul de rezolvare. Ieșirea se face în două metode:
- costul total obținut este scris într-un fișier specificat (deși această abordare este redundantă)
- costul, muchiile, și timpul de rezolvare sunt scrise la terminal (compilate în fișiere folosind redirectări).

Astfel, pentru verificare, după generarea testelor, a fost implementat un _shell script_ care rulează cele trei programe pentru fiecare input, cu mențiunea că pentru testele mai grele algoritmul de Backtracking nu mai poate fi aplicat (devine mult prea încet peste 30 de muchii, mai ales la probleme cu multe terminale).

Testele au fost rulate pe un sistem Linux cu procesor AMD Ryzen 7 7435HS cu 8 (16) nuclee la frecvență medie de 3.1 GHz (până la 4.5 GHz) și memorie RAM DDR5 cu capacitate 24 GB la 4800 MHz.\
Rezultatele sunt comparate în tabelele următoare.\
\

#figure(table(
  columns: (4em, 7em, 7em, 7em, 4em, 4em, 4em),
  inset: 7pt,
  align: horizon,
  table.header(
    [Nr.crt.], [Backtracking], [Dynamic Programming], [Greedy], [$n$], [$m$], [$k$]
  ),
  [1],   [30.29],     [1.58],   [0.23],   [10],  [15],  [4],
  [2],   [3.28],      [0.38],   [0.14],   [10],  [21],  [2],
  [3],   [1702.00],   [2.64],   [0.28],   [13],  [28],  [5],
  [4],   [646.98],    [5.41],   [0.58],   [15],  [31],  [5],
  [5],   [20.35],     [2.22],   [0.34],   [12],  [26],  [4],
  [6],   [60.66],     [4.24],   [0.47],   [12],  [26],  [5],
  [7],   [0.80],      [0.35],   [0.07],   [6],   [9],   [3],
  [8],   [0.97],      [0.79],   [0.16],   [6],   [10],  [4],
  [9],   [0.36],      [0.14],   [0.08],   [5],   [10],  [2],
  [10],  [0.96],      [0.40],   [0.13],   [7],   [11],  [2],
  [11],  [4.59],      [0.49],   [0.11],   [10],  [10],  [3],
  [12],  [228367.87], [2.69],   [0.29],   [21],  [24],  [5],
  [13],  [1.40],      [0.29],   [0.08],   [15],  [30],  [2],
  [14],  [448.93],    [1.23],   [0.28],   [15],  [28],  [4],
  [15],  [38.56],     [0.94],   [0.16],   [16],  [35],  [3],
  [16],  [10.89],     [0.28],   [0.09],   [13],  [32],  [2],
  [17],  [425.14],    [0.47],   [0.12],   [18],  [48],  [2],
  [18],  [15.43],     [0.99],   [0.15],   [12],  [25],  [4],
  [19],  [6.28],      [0.69],   [0.12],   [13],  [27],  [3],
  [20],  [2.34],      [0.17],   [0.07],   [10],  [22],  [2],
),
  alt: "Timp de execuție în milisecunde la teste ușoare",
  caption: [Comparația timpului de execuție (_ms_) după $n,m,k$ --- teste ușoare.]
)\

La testele ușoare nu se observă încă diferențe semnificative, decât acolo unde sunt mai mult de 20 de muchii (testele 3, 4, 14, 17), deși chiar și acest caz este nedeterminist --- testul 16, cu 32 de muchii (!), durează doar 10 ms. În schimb, testul 12 este un caz particular, rulând peste 3 minute.

Singura observație evidentă este ca implementarea Greedy durează mereu mai puțin de 1 ms, iar cea DP, în jur de câteva ms (între 0.14 și 5.41). Însă chiar și algoritmul BT poate rula la viteze mari (testul 9), chiar dacă are complexitatea mult mai mare.

== Rezultate teste mici.
- Medie BT:    11.0376 s (cu 12); 171.0805 ms (fără 12)

- Medie DP:     1.3195 ms

- Medie Greedy: 0.1975 ms\
\
\

#figure(table(
  columns: (4em, 7em, 7em, 7em, 4em, 4em, 4em),
  inset: 7pt,
  align: horizon,
  table.header(
    [Nr.crt.], [Backtracking], [Dynamic Programming], [Greedy], [$n$], [$m$], [$k$]
  ),
  [1],   [1357.55],   [0.69],   [0.13],   [20], [51], [2],
  [2],   [9240.15],   [10.65],  [0.25],   [20], [25], [7],
  [3],   [31.74],     [0.33],   [0.09],   [15], [34], [2],
  [4],   [131.56],    [1.52],   [0.43],   [15], [39], [4],
  [5],   [23000.88],  [6.89],   [0.46],   [20], [40], [6],
  [6],   [54570.43],  [4.19],   [0.45],   [25], [40], [5],
  [7],   [108177.38], [74.47],  [0.68],   [26], [30], [9],
  [8],   [299.74],    [6.43],   [0.41],   [21], [33], [6],
  [9],   [70290.46],  [4.06],   [0.39],   [23], [39], [5],
  [10],  [518.28],    [1.24],   [0.19],   [14], [31], [4],
  [11],  [41.44],     [1.15],   [0.29],   [13], [30], [4],
  [12],  [1194.00],   [1.36],   [0.23],   [20], [39], [3],
  [13],  [1565.48],   [1.36],   [0.23],   [15], [35], [4],
  [14],  [10733.72],  [2.24],   [0.33],   [20], [48], [4],
  [15],  [172.46],    [3.59],   [0.22],   [12], [25], [6],
),
  alt: "Timp de execuție în milisecunde la teste medii",
  caption: [Comparația timpului de execuție (_ms_) după $n,m,k$ --- teste medii.]
)\

La testele medii, implementarea BT deja începe să aibă greutăți, rulând consecvent la peste 30 ms (și mergând până la aproape 2 minute --- testele 7, 14).

Și algoritmul Fuchs încetinește puțin față de primul set de teste, testul semnificativ fiind 7: datorită dependenței complexității de numărul de terminale (aici se dau 9), acest algoritm rulează la aproape 0.1 s.

Algoritmul Takahashi-Matsuyama funcționează în continuare la sub 1 ms, deși înregistrează o creștere de~61.3671% față de testele mici.

== Rezultate teste medii.
- Medie BT:    18.7550 s

- Medie DP:     8.0113 ms

- Medie Greedy: 0.3187 ms

#figure(table(
  columns: (4em, 7em, 7em, 4em, 4em, 4em),
  inset: 7pt,
  align: horizon,
  table.header(
    [Nr.crt.], [Dynamic Programming], [Greedy], [$n$], [$m$], [$k$]
  ),
  [1],   [48.72],    [5.62],    [50],  [142], [5],
  [2],   [135.45],   [8.66],    [60],   [170],  [6],
  [3],   [2759.71],  [39.49],   [100],  [289],  [9],
  [4],   [319.85],   [17.40],   [100],  [286],  [6],
  [5],   [978.03],   [92.38],   [200],  [589],  [6],
  [6],   [2199.93],  [84.28],   [200],  [586],  [7],
  [7],   [246.76],   [35.48],   [200],  [593],  [4],
  [8],   [389.25],   [40.83],   [200],  [591],  [5],
  [9],   [141.52],   [26.57],   [250],  [740],  [3],
  [10],  [2002.65],  [80.04],   [250],  [744],  [7],
  [11],  [106.48],   [20.71],   [300],  [890],  [2],
  [12],  [1482.48],  [101.38],  [300],  [892],  [6],
  [13],  [5632.50],  [139.84],  [300],  [889],  [8],
  [14],  [6549.12],  [306.28],  [450],  [1345], [7],
  [15],  [2172.97],  [229.73],  [500],  [1487], [5],
  [16],  [1950.07],  [395.93],  [900],  [2688], [3],
  [17],  [8617.19],  [945.86],  [1000], [2995], [5],
  [18],  [75942.65], [1970.31], [1100], [3284], [8],
  [19],  [45649.73], [2050.23], [1200], [3582], [7],
  [20],  [39419.95], [2821.27], [1569], [4695], [6],
),
  alt: "Timp de execuție în milisecunde la teste grele",
  caption: [Comparația timpului de execuție (_ms_) după $n,m,k$ --- teste mari.\
  Aici nu s-a mai rulat algoritmul BT, deoarece era prea încet.]
)\

== Rezultate teste mari.
- Medie DP:     9.8373 s

- Medie Greedy: 0.3469 s

== Rezultate teste extreme.
Pentru a împinge algoritmul Greedy la limita sa, au fost formulate și câteva teste foarte mari, cu peste 5000 de noduri. Media timpului de rulare la acestea este de 202.1233 s, adică puțin peste 3 minute.

#figure(table(
  columns: (14em, 7em, 7em, 7em),
  inset: 7pt,
  align: horizon,
  table.header(
    [Timp ($s$)], [$n$], [$m$], [$k$]
  ),
  [110.71], [5000], [14991], [20],
  [190.62], [6700], [20088], [20],
  [305.04], [8400], [25189], [20],
),
  alt: "Timp de execuție în secunde la teste extreme",
  caption: [Timpul de execuție și dimensiunile testelor extreme pentru algoritmul Greedy.]
)\
