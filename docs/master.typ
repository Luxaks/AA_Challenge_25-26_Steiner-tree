// Base for AA Challenge documentation
// This document respects the Springer LNCS format guidelines.

// Config
#set text(size: 10pt)

#set heading(bookmarked: true, outlined: true)
#show heading.where(level: 1): set text(size: 12pt)
#show heading.where(level: 2): set text(size: 10pt)

#set figure(supplement: [Figura])
#show figure.where(kind: table): set figure(supplement: [Tabelul])
#show figure.where(kind: table): set figure.caption(position: top)

#set cite(style: "springer-lecture-notes-in-computer-science")

// Header
#set page(header: context {
    let pg = counter(page).get().first()
    let even = calc.rem(pg,2)
    if pg > 1 {
        if even == 0 [
            #pg #h(1cm)
            Ciucă L. et al.
        ] else [
            #h(1fr)
            AA Challenge --- Steiner Tree
            #h(1cm) #pg
        ]
    }
})

// Contents
#block([
  
// Main Title
#align(center, text(14pt)[
    *AA Challenge 2025--2026*\
    *Steiner Tree*@repo
])

// Authors
#align(center, text[
    \
    Ciucă Lucas#super[1], Tănasă Cosmin-Andrei#super[1]\
    \
    #super[1] Facultatea de Automatică și Calculatoare\
    Universitatea Națională de Știință și Tehnologie\ POLITEHNICA din București, România\
    Grupa 324, Seria CC\
    \
])

// Body
  = Abstract.
Documentul de față propune studiul problemei Steiner Tree prin demonstrarea proprietății de _NP-hard_ și analiza comparativă a trei algoritmi pentru rezolvarea acestei probleme într-un mod optimizat, unul folosind tehnica Backtracking și doi folosind metode euristice cunoscute, luând în considerare impactul asupra memoriei și a timpului de procesare pentru fiecare.

= Introducere.
#include "contents/1_intro.typ"

= Demonstrație NP-hard.
#include "contents/2_nph.typ"

= Prezentarea Algoritmilor.
Pentru rezolvarea problemei se propun trei algoritmi: Backtracking, Greedy, și Dynamic Programming.@overview @exact_algorithms

#include "contents/3-1_algo_BT.typ"

== Metode euristice.
Complexitatea ridicată a metodei BT duce la necesitatea implementării unor algoritmi mai eficienți, cu prețul exactității rezultatului. Pentru problema Steiner Tree se pot folosi câteva metode euristice,@heuristics dintre care au fost alese două, ambele bazate pe algoritmul Dijkstra.@dijkstra @djk_code Acestea operează mult mai rapid decât algoritmul cu BT, inclusiv pe seturi mari și foarte mari de date ($>500$ noduri, $>1000$ muchii). 

#include "contents/3-2_algo_GY.typ"
#include "contents/3-3_algo_DP.typ"

= Rezultate și Evaluare.
#include "contents/4_results.typ"

= Concluzii.
#include "contents/5_conclusion.typ"

= Declarație de Transparență.
Am folosit unelte AI (ChatGPT, DeepSeek) pentru agregarea și organizarea informațiilor relevante, precum și pentru a ajuta la dezvoltarea algoritmilor implementați. Codul final și textul documentației au fost realizate manual, luându-se în consdierare aceste rezultate.

#bibliography(
  "resources/credits.yml",
  title: "Bibliografie.",
  style: "springer-lecture-notes-in-computer-science",
  full: true,
)

])