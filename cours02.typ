#import "@preview/polylux:0.3.1": *
#import "@preview/tablex:0.0.9": colspanx, gridx, hlinex, rowspanx, tablex, vlinex
//#import "@local/svg-emoji:0.1.0": setup-emoji, noto, github
//#show: setup-emoji.with(font: noto)
#import themes.simple: *

#set text(font: "Inria Sans")

#show: simple-theme.with(
  footer: [Chiffrement symétrique],
)

#title-slide[
  = Cryptographie
  #v(2em)
  Chiffrement symétrique
  #v(2em)

  Alexander Schaub #footnote[DGA-MI, Bruz] #h(1em)

  schaub.alexander\@free.fr



  28/11/2025
]

#slide[
  == Principe
  #align(center)[
    #image("img/symmetrique.jpg", height: 55%)
  ]
  - Fonction cryptographique *bijective*
  - La *même* clé utilisée pour le chiffrement et le déchiffrement
]

#slide[
  == Chiffrement incassable

  Le Graal : un adversaire interceptant un message chiffé *ne peut pas retrouver la moindre information* concernant le message clair

  #sym.arrow.r Tous les messages clairs sont équiprobables

  #sym.arrow.r La sécurité est *inconditionnelle* (ne dépend pas de la puissance de calcul de l'attaquant)
]

#slide[
  == Le chiffre de Vernam

  Un chiffre de Vigenère avec une clé :

  - *aussi longue* que le texte à chiffrer
  - *parfaitement aléatoire*
  - utilisée pour chiffrer *un seul message* (et jamais réutilisée ensuite)

  *Preuve*
]

#slide[
  == Preuve

  Notons le chiffre de Vigenère $c = m plus.circle k$ où $k$ est la clé, $c$ le chiffré, $m$ le clair. $plus.circle$ représente l'addition modulo 26 lettre par lettre (après avoir converti chaque lettre de $k$ en nombre entre $0$ et $25$). Le déchiffrement est noté $m = c minus.circle k$.

  Si je connais $c$ mais pas $k$, quelle est la probabilité que le message est un certain message $m_0$ donné ? C'est celle que $k$ soit égale à $k_0 = c minus.circle m_0$. Or, toutes les clés sont équiprobables, donc c'est aussi le cas de tous les messages.

]

#slide[
  == Mauvaise utilisation

  Deux mots de 7 lettres de la langue française ont été chiffrés avec la même clef. Les chiffrés sont *WIBXBCY* et *PIBKMAJ*. Quels couples de mots sont possibles ?


]

#slide[
  == Chiffrement symétriques en pratique

  Deux grandes familles :

  - Chiffrement *par flot*
    - Chiffre de Vernam (XOR au lieu de Vigenère en général) avec clé générée par un générateur aléatoire particulier

  - Chiffrement par *bloc*
    - Messagé découpé en blocs de taille égale, chaque bloc traité un par un, avec un mode opératoire particulier
]

#slide[
  = Chiffrement par bloc

  Différents modes opératoires :
  #grid(
    columns: (auto, auto),
    rows: 65%,
    [ *ECB* (Electronic CodeBook) :
      #image("img/ECB.png", width: 90%)],
    [*CBC* (CypherBlock Chaining) :
      #image("img/cbc.png", width: 90%)],
  )

]

#slide[
  == Pourquoi il faut oublier ECB tout de suite

  #grid(
    columns: (auto, auto, auto),
    rows: 65%,
    [
      #figure(
        image("img/tux.png", width: auto),
        caption: "Tux",
      )
    ],
    [
      #figure(
        image("img/tux_ecb.png", width: auto),
        caption: "Tux chiffré en ECB",
      )
    ],
    [
      #figure(
        image("img/laboulette.jpg", width: auto),
        caption: "Toi après avoir chiffré en ECB",
      )
    ],
  )
]

#slide[
  == Chiffrement symétrique et bourrage (_padding_)

  Que faire si la longueur du texte clair n'est pas multiple de la taille de bloc ?

  + On rajoute des zéros
  + On rajoute de l'aléa
  + On peut pas chiffrer :(
  + Autre chose ?
]
#slide[
  == Chiffrement symétrique et bourrage (_padding_) - en vrai

  Différents modes existent, on rajoute soit :

  - une valeur particulière d'octet (`0x80`) puis que des octets à $0$ (ISO/IEC 7816-4)

  - $n-1$ octets aléatoires puis un octet valant $n$ (ISO 10126)

  - $n$ octets égaux à $n$ (avec $n$ entre $1$ et la longueur de bloc + 1) (PKCS\#7)
]

#slide[
  == Pourquoi c'est aussi compliqué ?

  #grid(
    columns: (auto, auto),
    rows: auto,
    [
      #image("img/padding_oracle.png", width: 100%)
    ],
    [Il faut faire *très* attention au moment du déchiffrement !],
  )

]

#slide[
  = Chiffrement par flot

  Rappel : il s'agit de

  + Générer une séquence d'octets aléatoires

  + Effectuer un XOR entre la séquence aléatoire et le texte clair

  Et voilà !
]



#slide[
  == De la différence entre le bon et le mauvais aléa

  Tous les générateurs d'aléa ne se valent pas
  #only(1)[
    - Générateurs d'aléa "vrai" : en général basés sur un ou plusieurs phénomène physiques
      - *Avantages* : on ne peut jamais générer deux fois le même aléa, peut être complètement imprédictible
      - *Incovénients* : on ne peut jamais générer deux fois le même aléa, lent
      - *Exemple* : `/dev/random` sous linux, `https://www.random.org/`, des lancers de pièces, de dés
  ]
  #only(2)[
    - Générateurs d'aléa "basique" : génère de l'"aléa" en utilisant une graine (ou *seed*)

      - *Avantage* : on peut générer plusieurs fois le même aléa (reproductibilité !), rapide en général
      - *Inconvénient* : pas réellement aléatoire (il en a juste l'air)
      - *Exemple* : `rand` (initialié par `srand`) en C, `random.random()` en Python
  ]
  #only(3)[
    - Générateurs d'aléa "cryptographique" : génère de l'"aléa" en utilisant une graine (ou *seed*), mais en mieux...

      - *Avantage* : on peut générer plusieurs fois le même aléa (reproductibilité !), rapide en général, peut être utilisé en crypto
      - *Inconvénient* : plus lent qu'un générateur basique
      - *Exemple* : `/dev/random` sour Linux, RC4, Chacha20, ...
  ]
]

#slide[
  == Mais au fond quelle différence y a-t-il entre le bon et le mauvais générateur d'aléa ?

  #tablex(
    columns: (auto, auto, auto),
    align: center + horizon,
    auto-vlines: false,
    header-rows: 1,
    inset: 10pt,


    [*Aléa vrai*],
    [*Aléa basique*],
    [*Aléa cryptographique*],
    [TRNG],
    [PRNG],
    [CSPRNG],
    [Complètement imprédictible],
    [Rapide et uniforme],
    [Imprédictible en pratique],
    [Génération de clé, IV, ...],
    [Simulation (pas en crypto !!)],
    [Chiffrement par flot],
  )
]

#slide[
  == Un exemple de CSPRNG : Salsa20

  #grid(
    columns: (auto, auto),
    rows: auto,
    [#image("img/salsa-round-function.svg", height: 78%)],
    [```
    b ^= (a + d) <<< 7;
    c ^= (b + a) <<< 9;
    d ^= (c + b) <<< 13;
    a ^= (d + c) <<< 18;```],
  )

]

#slide[
  == Salsa20 en pratique

  Pour l'utiliser, il faut :
  - un *nonce* (ou IV) : valeur *unique*, potentiellement publique (128 bits)
  - une *clé* (256 bits)

  Et on obtient une séquence pseudo-aléatoire imprédictible en pratique

  Ne *jamais* chiffrer deux messages avec la *même clé* et le *même nonce* !
]

#slide[
  == Variantes

  Il existe aussi
  - Salsa20/8 et Salsa20/12 (plus rapides, moins sûres ?)
  - XSalsa20 (nonce plus grand)
  - Chacha20 et XChacha20 (variantes)

  Le tout par l'éternel *Daniel J. Bernstein*
]

#slide[
  == Transformer un chiffrement par bloc en chiffrement par flot

  #image("img/ctr.svg", height: 60%)

]

#slide[
  = Exemples de chiffrements par bloc

  #grid(
    columns: (auto, auto),
    rows: auto,
    gutter: 15pt,
    [#figure(
      image("img/feistel.png", height: 70%),
      caption: "Schéma de Feistel",
    )],

    [
      === Chiffrement
      - $L_i = R_(i-1)$
      - $R_i = L_(i-1) + F(R_(i-1))$

      === Déchiffrement
      - $R_i = L_(i+1)$
      - $L_i = R_(i+1) + F(L_(i+1))$

      *Note* : $F$ n'a *pas* besoin d'être inversible !
    ],
  )
]

#slide[
  == *Data Encryption Standard* (DES)
  #grid(
    columns: (auto, auto),
    rows: auto,
    gutter: 15pt,
    [#image("img/des_f.png", height: 70%)],
    [
      $E$ : extension de 32 bits vers 48 bits (en dupliquant des bits)

      $S_i$ : Boîte de substituion non-linéaire de 6 vers 4 bits

      $P$ : permutation des bits pour une meilleure *diffusion*
    ],
  )
]

#slide[
  == DES : les problèmes

  - Longueur des blocs : $64$ bits #emoji.thumb.down

  - Longueur des clés : $64$ bits #emoji.thumb.down dont $56$ utiles #emoji.thumb.down #emoji.thumb.down

  - Valeurs des S-Box : paraissent arbitraires (mais en fait : la NSA a bien fait les choses ! #text(font: "Noto Color Emoji", emoji.thumb.up)pour une fois...)

  - Se retrouve parfois utilisé en mode Triple DES (triple chiffrement avec plusieurs clés différentes) pour une sécurité de 112 bits

]

#slide[
  == Le chiffrement par blocs moderne : AES

  #grid(
    columns: (25%, auto),
    rows: auto,
    [    #image("img/aes.png", width: 78%) ],
    [
      - Etat interne : matrice de 4 $times$ 4 octets
      - BYTE_SUB : substitution simple octet par octet (SBOX)
      - SHIFT_ROW : permutation simple, on décale la $i$-ème ligne de $i-1$ positions vers la droite
      - MIX_COL : opération linéaire colonne par colonne qui améliore la diffusion
    ],
  )

]

#slide[
  == Principales caractéristiques d'AES

  - Taille de clés : 128 bits, 192 bits ou 256 bits selon variante
  - Taille de blocs : 128 bits
  - SBOX : choisie avec soin...

  #sym.arrow LE chiffrement par blocs le plus utilisé aujourd'hui
]

#slide[
  = Pour conclure

  On a vu comment *cacher le contenu* des messages  mais...

  - Comment peut-on *échanger les clés* entre participants légitimes ?
  - Comment garantir *l'origine* des messages ?
  - Comment garantir que les messages n'ont pas été *modifiés* par un attaquant ?

  Les réponses dans la suite du module !
]
