// introduction and general descriptions

Problema Steiner Tree este o problemă combinatorică de decizie și de optimizare, care dorește găsirea unui subgraf aciclic conex (subarbore) de cost minim, ce conectează anumite noduri (numite _terminale_) ale grafului inițial, care este neorientat și ponderat.@overview @st_general_method @st_info Aceste legături se fac prin intermediul celorlalte puncte, numite și puncte intermediare, însă prezența sau absența lor nu afectează în niciun fel soluția --- terminalele pot fi conectate direct, dacă formează căi mai scurte; sau se pot adăuga oricâte noduri/muchii, în cazul în care costul total este cel mai mic posibil.\
\

#figure(
  image("../resources/st_definition.png", width: 70%),
  caption:[
    Ilustrarea soluției pentru problema arborelui Steiner.@def_image\
    (Terminalele sunt mai mari decât nodurile de legătură.)
  ],
  alt: "Prezentare arbori Steiner",
)\

Deși principiile acestei probleme se pot aplica pe seturi diverse de obiecte cu funcții de legătură specifice, variantele cu grafuri (așa cum este cea prezentată în acest proiect) sunt cele mai bine cunoscute și cercetate. Și aici există mai multe categorii, în funcție de construcția setului de noduri și formularea costurilor dintre acestea:
+ *ST Euclidian (Geometric).* Terminalele sunt amplasate într-un spațiu euclidian (un plan),  în care punctele de legătură sunt orice puncte din interiorul poligonului format de terminale, astfel încât suma segmentelor dintre aceste puncte intermediare și terminale (vârfurile poligonului) să fie minimă.\
  Se poate demonstra că toate punctele de legătură trebuie să aibă gradul 3, iar unghiurile dintre muchii vor avea întotdeauna $120 degree$ (segmentele formează o _rețea stea_, fiind egal depărtate rotațional).\
  Această variantă este strict _NP-hard_, însă există o schemă de aproximare în timp polinomial.

+ *ST Rectiliniu.* Variantă a lui ST Euclidian, în care considerăm în schimb distanța rectilinie (_Manhattan_) dintre puncte. Această problemă poate fi aplicată în design-ul circuitelor electrice, întrucât firele/traseele trebuie să fie construite în segmente de linii drepte, conectate mai mult sau mai puțin ortogonal.

+ *ST Metric.* Un caz special, aflat între formularea clasică pe grafuri și varianta euclidiană. Graful de input este complet (toate nodurile sunt legate direct, două câte două), iar nodurilor li se asociază puncte în spațiu și muchiilor li se asociază distanțele dintre nodurile în care sunt incidente. Altfel spus, acest graf satisface inegalitatea triunghiului $ forall v_i, v_j, v_k in G(V), space chevron.l v_i, v_j chevron.r + chevron.l v_j, v_k chevron.r > chevron.l v_i, v_k chevron.r $ unde $chevron.l u,v chevron.r$ reprezintă distanța dintre puncte, notată ca produs scalar între vectorii aferenți.

+ *ST cu $k$ Muchii.* O constrângere a problemei originale, în care se caută să fie incluse cât mai puține muchii (sub o limită $k$). Acesta poate fi văzut și ca un graf ponderat în care toate costurile sunt egale cu 1.

+ *ST cu $k$ Noduri.* Asemenea exemplului anterior, se aplică o constrângere față de problema de bază; aici se doresc cât mai puține noduri intermediare.\
\

#figure(
  image("../resources/poly_examples.png", height: 30%),
  caption:[
    Exemple de arbori Steiner euclidieni pe bază de grafuri poligonale.@poly_image
  ],
  alt: "Exemple arbori Steiner poligonali",
)\

Problema arborelui Steiner poate fi văzută ca o îmbinare și generalizare a altor două probleme: găsirea celei mai scurte căi (implementată deseori cu algoritmii Dijkstra, Bellman-Ford, Floyd-Warshall, etc.) și găsirea arborelui de acoperire minim.\
În cazul în care se caută arborele între 2 terminale, acesta este echivalent cu calea minimă dintre ele. În caz contrar, dacă toate nodurile sunt terminale, problema devine reducerea numărului de muchii, deci formarea arborelui de acoperire.

Dificultatea apare prin generalitatea problemei Steiner față de acestea două: deși ambele cazuri speciale sunt rezolvabile în timp polinomial (aparțin clasei _NP_, mai exact sunt _NP-complete_), problema Steiner obișnuită este de regulă considerată _NP-hard_, deci nu poate fi rezolvată ușor în timp polinomial.\
În plus, deși au fost descoperite strategii de aproximare optime, ele nu sunt la fel de eficiente sau precise pentru un arbore Steiner generic față de arborele euclidian.


Această problemă își găsește aplicabilitatea în domeniul rețelisticii. Rețelele de telecomunicații sunt proiectate sub forma unui arbore Steiner cu terminalele fiind reprezentate de consumatori si sediul central al furnizorului. De asemenea, în momentul în care se trimite pe o rețea locală un mesaj de tip multicast terminalele devin sursa mesajului și destinatarii.