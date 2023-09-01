#import "@preview/polylux:0.2.0": *
#import "@preview/tablex:0.0.4": tablex, gridx, hlinex, vlinex, colspanx, rowspanx

#import themes.simple: *

#set text(font: "Inria Sans")

#show: simple-theme.with(
  footer: [Introduction & Histoire],
)

#title-slide[
  = Cryprographie
  #v(2em)
  Introduction & Histoire de la cryptographie
  #v(2em)

  Alexander Schaub #footnote[DGA-MI, Bruz] #h(1em)
  
  schaub.alexander\@free.fr

  

  11/09/2023
]


#focus-slide[
  _Crypto·graphie_

  Écriture cachée
]

#title-slide[
  == ATTAQUEZ A L AUBE
 

  #uncover((2,3))[
    #sym.arrow.r 
  ]
  

  #uncover(3)[
    #h(1em)
    == HDJQKLFO K M ALFY 
  ]
]


#slide[
= Chiffres historiques
#let cell = block.with(
  width: 100%,
)
#grid(
  columns: (auto, auto),
  rows: (auto),
  gutter: 3pt,
  cell(height: 80%)[
  *Chiffre de substitution*
  
  #only(1)[#image("img/CaesarDisk.jpg", width: 70%)]
  #only(2)[
  #pad(left:30pt,[
  A #sym.arrow.r N

  B #sym.arrow.r O

  C #sym.arrow.r P

  D #sym.arrow.r Q

  ...

  Z #sym.arrow.r M

  ])
]

  ],
  cell(height: 80%)[
  *Chiffre de transposition*

  #only(1)[#image("img/Skytale.png", width: 90%)]
  #only(3)[
  #pad(left:30pt,[

  ATTAQUEZALAUBE

  #pad(left:30%,[
    #sym.arrow.b
  ]) 
  #tablex(
  columns: 5,
  auto-lines: false,

  (), vlinex(), vlinex(),vlinex(),vlinex(), (),
  [A], [T],  [T], [A],[Q],
  [U], [E], [Z], [A],[L],
  [A], [U], [B], [E],()
)
  
  #pad(left:30%,[
    #sym.arrow.b
  ]) 

  AUATEUTZBAAEQL

  ])
  ]
],
)
]


#slide[
== Le texte c'est bien, mais à l'oral ?

#set align(center)
#image("img/navajo.jpg", width: 50%)

]

#slide[
== Et si je veux cacher l'existence du message ?

#set align(center)

#grid(
columns: (33%, 33%, 33%),
rows: (auto),
[
#image("img/pirate.png", width: 100%)
],
[
#sym.arrow.r
],
[
ATTAQUEZ A L AUBE
])
]

#focus-slide[
  _Stégano·graphie_

  Écriture hermétique (?)

]


#slide[
  == Un peu de vocabulaire

#h(1em)

/ Texte clair: Message à transmettre      
/ Texte chiffré: Transformation "incompréhensible" du message
/ Chiffrer: Transformer le texte clair en texte chiffré
/ Déchiffrer: Transformer le texte chiffré en texte clair


Remarque: 
- #strike[crypter]
]


#slide[
 == En images
#set align(center)
#image("img/chif-dechif.svg", width: 80%)

]

#slide[
== Un peu de notation (provisoire)

/ Alphabet: Ensemble de symboles, ici : $Sigma = {A, B, ..., Z}$
/ Message (ou texte, ou mot): Suite de symboles, i.e. élément de $Sigma^+$
(Note: $Sigma^+ = Sigma union Sigma^2 union Sigma^3 union... = union.big_(n=1)^infinity Sigma^n$)

/ Fonction de chiffrement: $f : Sigma^+ arrow.r.bar Sigma ^+$
/ Fonction de déchiffrement: $g : Sigma^+ arrow.r.bar Sigma ^+$ telle que
#h(2em)
#align(center)[
$forall x in Sigma^+, g(f(x)) = x$
]
]

#focus-slide[
Est-ce suffisant ?

#uncover(2)[_Pourquoi ?_]
]


#slide[
== Principe de Kirchhoff

_La sécurité d'un système de chiffrement ne doit reposer que sur le secret de la *clef*._

Il faut distinguer entre:


#let cell = block.with(
  width: 100%,
  height: 30%
)
#grid(
  columns: (auto, auto),
  rows: (auto),
  gutter: 3pt,
  cell()[
  *L'algorithme général*

  Ex: décaler chaque lettre dans l'alphabet

  Ex: Écrire le texte dans un rectangle et lire de haut en bas
  ],
  cell()[
  et *la composante secrète*

  Ex: de combien de lettres décaler

  #v(1em)
  Ex: la largeur du rectangle
  ]
)

]

#slide[
== Notation revisitée
Un système de chiffrement se compose de:

- Trois ensembles $E, F, K$
- De deux fonctions, $f : E times K arrow.bar.r F, g: F times K arrow.bar.r E$ telles que
  - $forall x in E, k in K, g(f(x, k), k) = x$
  - On ne doit pas pouvoir retrouver $x$ à partir de $f(x, k)$ sans connaître $k$
]


#slide[
== Exemple

Chiffre de substitution simple (dit _de Caesar_):

- $E = F = Sigma^+$
- $K = [1;25]$
- $f(x = (x_i)_i,k) = F(x_i, k)_i$ où $F(x_i, k) = x_i + k$
]

#slide[
== Exemple

Chiffre de transposition simple:

- $E = F = Sigma^+$
- $K = NN$
- $f(x = (x_i)_i,k) = (x_(floor(i/(n slash k)) + k*(i%n/k)))_i$ où $n$ est la longueur du message, en supposant que $n$ est un multiple de $k$ 
]

#focus-slide[
  Un peu de pratique
  
  #v(2em)

  _Partie I du TP n°1_
]


#slide[

== _O tempora o moris_

Le chiffrement de Caesar n'est pas vraiment sûr !

#uncover((2,3))[Il n'y a que 25 transformations (= 25 clés différentes)]

#only(3)[C'est facile de toutes les essayer]

]

#slide[

== Améliorations possibles


- Considérer _toutes_ les permutations possibles: 
  - $26! approx 4 times 10^(26) > 25$
  - Un attaquant ne peut pas toutes les essayer
  
  #h(1em)

- Changer régulièrement de système
  - Par exemple, alterner entre A #sym.arrow C et A #sym.arrow F
  - Deux systèmes ne suffisent pas, mais si on en utilise plus...
  - On obtient le chiffre de _Vigenère_

]


#slide[
== Chiffre de substitution généralisé


- $E = F = Sigma^+$
- $K = 𝔖(Sigma)$ l'ensemble des bijections dans $Sigma$
- $f(x = (x_i)_i,sigma) = (sigma(x_i))_i$
- $g(x = (x_i)_i,sigma) = (sigma^(-1)(x_i))_i$

]

#slide[
== Chiffre de Vigenère

- $E = F = Sigma^+$
- $K = [0;25]^m$
- $f(x = (x_i)_i,k=(k_j)_j) = F(x_i, k_(i%m))_i$ où $F(x_i, k) = x_i + k$

Exemple: clef = #text(fill:red)[M]#text(fill:teal)[O]#text(fill:green)[T]


#text(fill:red)[A]#text(fill:teal)[A]#text(fill:green)[A]#text(fill:red)[B]#text(fill:teal)[B]#text(fill:green)[B]#text(fill:red)[C]#text(fill:teal)[C]#text(fill:green)[C]#text(fill:red)[D]#text(fill:teal)[D]#text(fill:green)[D]...

#h(3em) #sym.arrow.b

#text(fill:red)[M]#text(fill:teal)[O]#text(fill:green)[T]#text(fill:red)[N]#text(fill:teal)[P]#text(fill:green)[U]#text(fill:red)[O]#text(fill:teal)[Q]#text(fill:green)[V]#text(fill:red)[P]#text(fill:teal)[R]#text(fill:green)[W]...

]

#slide[
== Un peu de cryptanalyse 


#set align(center)
#image("img/chif-dechif-decrypt.svg", width: 60%)

]

#slide[
== Une histoire de fréquences

Toutes les lettres n'apparaissent pas à fréquence égale en français :

- "e" est la letter la plus courante, puis "a", "i", "s", ...

Les bigrammes ont des fréquences différentes aussi !

 - l'enchaînement "nt" est beaucoup plus courant que "tn"


Une permutation unique appliquée à tout un texte *préserve les fréquences* (y compris des bigrammes)
]

#slide[
== Retrouver la permutation
Si on sait qu'un texte _français_ (suffisamment long!) a été chiffré en utilisant une _permutation_ unique :

 - La lettre la plus présente correspond _probablement_ au "e"
 - la deuxième la plus fréquente au "a", etc.
 - on peut s'aider des fréquences de bigrammes également

#v(2em)

Contre-ex : _La Disparition_ de Georges Perec
]

#slide[
== Décrypter Vigenère

- Si on connaît la _longueur_ de la clé utilisée dans un chiffre de Vigenère, alors il "suffit" de décrypter $m$ chiffres de Caesar
- On peut retrouver cette longueur grâce aux fréquences des lettres de la langue du texte clair... (mais d'autres méthodes existent aussi !)
]

#focus-slide[

Au boulot ! A l'attaque de Vigenère...

_ Partie II du TP n°1_
]


#slide[
= Chiffres pré-modernes

#v(1em)

- Vigenère publié au XVI siècle, cassé fin du XIX siècle.

#v(1em)

- Mais plusieurs améliorations sont possibles !
]


#slide[
== Chiffrements *polygraphiques*
#v(1em)

- Dans les cryptosystèmes de César et de Vigenère, *une* lettre est transformée en *une* autre lettre...
#v(1em)

#only((2,3))[- ... et ce indépendamment lettre par lettre]
#v(1em)

#only(3)[- Et si on considérait des *groupes* de lettres plutôt ?]

]


#slide[
== Chiffrement digraphique

- $E = F = Sigma^+$

- $K = 𝔖(Sigma^2)$ l'ensemble des bijections dans $Sigma^2$

- $f(x = (x_i)_i,sigma) = (sigma(x_(2i),x_(2i+1)))_i$

- $g(x = (x_i)_i,sigma) = (sigma^(-1)(x_(2i),x_(2i+1)))_i$

]

#slide[
== Chiffre de Hill

- Une substitution générique est coûteuse à représenter
- Chiffre de Hill : ~ César mais en digraphique
- César : $y = x + a$ où $y$ chiffré, $x$ clair, $a$ décalage
- Généralisation (Hill) : $ vec(y_1, y_2) = mat(a,b;c,d) vec(x_1,x_2) = vec(a x_1 + b x_2 [26], c x_1+d x_2 [26]) $
- Pour déchiffrer : il faut inverser la matrice $mat(a,b;c,d)$ (dans $ZZ #text[/] 26ZZ$)

]

#slide[
== Cryptanalyse du chiffre de Hill

- Les fréquences de digrammes différent !

- Le chiffre de Hill est donc vulnérable à l'analyse statistique

]


#slide[
#set list(spacing: 1.1em)

== Chiffre de Hill généralisé

- Le chiffre de Hill se généralise assez bien :

  - à des dimensions supérieures

  - à des corps plus grands ($FF_(256)$ i.e. des octets)

- Le chiffrement et déchiffrement sont très rapides

- En dimension assez grande, l'analyse statistique n'est plus efficace
#only(2)[

- Cependant, il n'est plus utilisé aujourd'hui. Pourquoi d'après vous ?]
]


#slide[
= Les chiffres de la Première Guerre Mondiale

- Avec l'avènement des méthodes de communication longue distance (télégrammes), protéger ses communications devient indispensable

- Les belligérants sont capables d'intercepter les communications des autres pays

- Si la sécurité n'est pas bonne: aïe aïe aïe...

]

#slide[
== Le chiffre Ubchi

- Chiffre utilisé par *toute* l'armée allemande en 1914 lorsqu'éclate la Première Guerre Mondiale
- La même clé est utilisée pour *tous* les échanges...
- L'algorithme est une double transposition : 


#grid(
columns: (20%, 5%,20%, 5%, 20%, 5%, 20%),
rows: (auto),
[
  #tablex(
  columns: 5,
  auto-lines: false,

  (), vlinex(), vlinex(),vlinex(),vlinex(), (),
  [#text(fill:red)[M]], [#text(fill:teal)[A]], [#text(fill:green)[C]], [#text(fill:blue)[L]],[#text(fill:black)[E]],
  hlinex(),
  [#text(fill:red)[5]], [#text(fill:teal)[1]], [#text(fill:green)[2]], [#text(fill:blue)[4]],[#text(fill:black)[3]],
  hlinex(),
  [#text(fill:red)[A]], [#text(fill:teal)[T]], [#text(fill:green)[T]], [#text(fill:blue)[A]],[#text(fill:black)[Q]],
  [#text(fill:red)[U]], [#text(fill:teal)[E]], [#text(fill:green)[Z]], [#text(fill:blue)[A]],[#text(fill:black)[L]],
  [#text(fill:red)[A]], [#text(fill:teal)[U]], [#text(fill:green)[B]], [#text(fill:blue)[E]],()
)

],
[
#v(2.5em)
#sym.arrow.r],
[
#tablex(
  columns: 5,
  auto-lines: false,
  (), vlinex(), vlinex(),vlinex(),vlinex(), (),
  [#text(fill:red)[M]], [#text(fill:teal)[A]], [#text(fill:green)[C]], [#text(fill:blue)[L]],[#text(fill:black)[E]],
  hlinex(),
  [#text(fill:red)[5]], [#text(fill:teal)[1]], [#text(fill:green)[2]], [#text(fill:blue)[4]],[#text(fill:black)[3]],
  hlinex(),
  [#text(fill:teal)[T]], [#text(fill:teal)[E]], [#text(fill:teal)[U]],[#text(fill:green)[T]],[#text(fill:green)[Z]], 
  [#text(fill:green)[B]], [#text(fill:black)[Q]], [#text(fill:black)[L]],[#text(fill:blue)[A]], [#text(fill:blue)[A]],
  [#text(fill:blue)[E]], [#text(fill:red)[A]],[#text(fill:red)[U]],[#text(fill:red)[A]], [#text(fill:black)[X]], 

)],
[
#v(2.5em)
#sym.arrow.r],
[

#tablex(
  columns: 5,
  auto-lines: false,
  (), vlinex(), vlinex(),vlinex(),vlinex(), (),
  [#text(fill:red)[M]], [#text(fill:teal)[A]], [#text(fill:green)[C]], [#text(fill:blue)[L]],[#text(fill:black)[E]],
  hlinex(),
  [#text(fill:red)[5]], [#text(fill:teal)[1]], [#text(fill:green)[2]], [#text(fill:blue)[4]],[#text(fill:black)[3]],
  hlinex(),
  [E], [Q], [A], [U], [L],
  [U], [Z], [A], [X],  [T],
  [A], [A], [T], [B], [E]
)],

[#v(2.5em)
#sym.arrow.r],
[EQAUL UAAXT AATBE],
)

]

#slide[
== Comment les français ont-il cassé Ubchi ?

Un opérateur a oublié la deuxième transposition...
#align(center)[
#image("img/laboulette.jpg", width:50%)
]
]


#slide[
== Ubchi a été décrypté !

- Tout le monde utilisait la même clef #sym.arrow.r oups !

- Maintenant, les français peuvent déchiffrer les conversations #sym.arrow.r #emoji.hand.peace

- Comment les Français vont-il utiliser cette information ?


]
#slide[
== La réaction française

#grid(
columns: (35%,65%),
rows: (75%),
[
#image("img/lematin.jpg", width:60%)
],
[
#image("img/laboulette.jpg", width:90%)
],)

]



#slide[
== Le chiffre ABC

- La mèche est vendue, les allemands sont au courant du décryptage !

- Et du coup, la clef est changée #emoji.face.sad

- Mais les Français finissent par trouver un mode direct de décryptage ! #emoji.face.happy

- Et du coup les allemands sont obligés de changer de cryptosystème : ils utilisent le chiffre dit "ABC"

]

#slide[

== Le chiffre ABC (suite)

- Bonne nouvelle pour les Français : ce chiffre est encore moins sûr !

- Il s'agit simplement d'un chiffre Vigenère *avec une clé immuable égale à ABC*,

- suivie d'une *simple* transposition (la moitié d'Ubchi)
  - pour leur défense, la clé de la transposition changeait régulièrement 

- cet algorithme ne résiste pas longtemps aux spécialistes français...

]

#focus-slide[
== Puis vint Enigma !

]

#slide[
== Enigma

#let cell = block.with(
  width: 100%,
)
#grid(
  columns: (auto, auto),
  rows: (auto),
  gutter: 3pt,
  cell(height: 75%)[
    #image("img/enigma.jpg", height:90%)
  ],
  cell(height: 75%)[
    #image("img/Enigma-action.svg", height:90%)
  ]
)
]
