// Base for AA Challenge documentation
// This document respects the LNCS format guidelines.

#set text(10pt)

// Main Title
#pad(bottom: 1em, align(center, text(14pt)[
    *AA Challenge 2025--2026* \
    *Steiner Tree*
]))

// Authors
#align(center, text[
    Ciucă Lucas#super[1], Tănasă Cosmin-Andrei#super[1] \
    \
    #super[1] Facultatea de Automatică și Calculatoare \
    Universitatea Politehnica din București, România \
    Grupa 324, Seria CC
])

// Header
#set page(header: context {
    let pg = counter(page).get().first()
    let even = calc.rem(pg, 2)
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

= Buna cf.
intro aici

= Demonstrație NP-hard.
#include "nph.typ"

= Bibliografie.
#include "credits.typ"