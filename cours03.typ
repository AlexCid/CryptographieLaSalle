#import "@preview/polylux:0.2.0": *
#import "@preview/tablex:0.0.4": tablex, gridx, hlinex, vlinex, colspanx, rowspanx
#import "@local/svg-emoji:0.1.0": setup-emoji, noto, github
#show: setup-emoji.with(font: noto)
#import themes.simple: *
#import "@preview/cetz:0.1.2"

#set text(font: "Inria Sans")

#show: simple-theme.with(
  footer: [Chiffrement symétrique],
)

#title-slide[
  = Cryptographie
  #v(2em)
  Chiffrement asymétrique
  #v(2em)

  Alexander Schaub #footnote[DGA-MI, Bruz] #h(1em)
  
  schaub.alexander\@free.fr

  

  13/09/2023
]

#slide[
    == Dans l'épisode précédent...

    - On a vu comment protéger *la confidentialité* d'un message...
    - ... si l'émetteur et le destinataire partagent la *même* clé
    
    Mais alors :

    #only(2)[
    - comment partager la clé si on ne s'est *jamais vu* ?
    - comment garantir que le message n'a pas été *modifié* ?
    - comment garantir *l'origine* du message ?
    ]


]

#slide[
  == Parlons un peu d'Alice et de Bob...


  #set align(center)
  #grid(
    rows: (auto, 20%, auto),
    columns: (20%, 60%, 20%),
    [#text(80pt)[#emoji.man] clé],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), mark: (end: ">", stroke:3pt), stroke: 3pt)
    })
    ],[clé #text(80pt)[#emoji.woman]],
    [],[Chiffré(clé, message)],[],
    [],[#text(80pt)[🕵🏼‍♀️]],[]
  )
]

#slide[
  == Et s'ils ne se sont jamais vus ?

    #set align(center)
  #grid(
    rows: (auto, 20%, auto),
    columns: (20%, 60%, 20%),
    [#text(80pt)[#emoji.man] clé],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), mark: (end: ">", stroke:3pt), stroke: 3pt)
    })
    ],[ #text(80pt)[🙍‍♀️]],
    [],[Chiffré(clé, message)],[],
    [],[#text(80pt)[🕵🏼‍♀️]],[]
  )
]

#slide[
  == Et s'ils ne se sont jamais vus ?

  #set align(center)
  #grid(
    rows: (auto, 20%, auto),
    columns: (20%, 60%, 20%),
    [#text(80pt)[#emoji.man] clé],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), mark: (end: ">", stroke:3pt), stroke: 3pt)
    })
    ],[ #text(80pt)[#emoji.woman]],
    [],[clé, Chiffré(clé, message)],[],
    [],[#text(80pt)[🕵🏼‍♀️] message],[]
  )
]

#focus-slide[

  Trois services de la cryptographie asymétrique :

  l'échange de clés,

  le chiffrement asymétrique,

  l'authenticité
]

#slide[
  = Service n°1 : échange de clé

#h(2pt)

 #set align(left)
 #only(1)[
  #grid(
    rows: (auto, 20%, auto),
    columns: (30%, 40%, 30%),
    [#align(left)[#text(80pt)[#emoji.man] $K_"priv"^"B"$]],[
    #align(center)[#cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), mark: (end: ">", stroke:3pt), stroke: 3pt)
    })
    ]],[#align(right)[$K_"priv"^"A"$ #text(80pt)[#emoji.woman]]],
    [],[#align(center)[$K_"pub"^B$]],[],
    [],[#align(center)[#text(80pt)[🕵🏼‍♀️]]],[]
  )
 ]
 #only(2)[
  #grid(
    rows: (auto, 20%, auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[#emoji.man] $K_"priv"^"B"$],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), mark: (start: ">", stroke:3pt), stroke: 3pt)
    })
    ],[#align(right)[$K_"priv"^"A"$, $K_"pub"^B$ #text(80pt)[#emoji.woman]]],
    [],[#align(center)[$K_"pub"^A$]],[],
    [],[#align(center)[#text(80pt)[🕵🏼‍♀️]]],[]
  )
 ]

 #only(3)[
  #grid(
    rows: (auto, 20%, auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[#emoji.man] $K_"priv"^"B"$, $K_"pub"^A$],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), stroke: 3pt)
    })
    ],[#align(right)[$K_"priv"^"A"$, $K_"pub"^B$ #text(80pt)[#emoji.woman]]],
    [],[],[],
    [$f(K_"priv"^"B", K_"pub"^A) = K$],[#align(center)[#text(80pt)[🕵🏼‍♀️]]],[$K = f(K_"priv"^"A", K_"pub"^B)$]
  )
 ]
]

#slide[
  == Echange de clés de Diffie-Hellman

  Comment trouver $f, K_"priv"$ et $K_"pub"$ pour que cela fonctionne ?

  1976: Schéma de Diffie-Hellman.

  - Données partagées : $p$ premier, $g in [1,p-1]$.
  - Clés privées : $a, b in [1, p-1]$
  - Clés publiques : $g^a [p], g^b [p]$
  - Secret partagé : $K = g^(a b) [p]$

  Pourquoi ça marche ? $(g^a)^b [p] = g^(a b) [p]= (g^b)^a [p]$

]

#slide[
  == Echangeons les clés avec Diffie-Hellman

  #h(2pt)

 #set align(center)
 #only(1)[
  #grid(
    rows: (auto, 20%, auto),
    columns: (30%, 40%, 30%),
    [#align(left)[#text(80pt)[#emoji.man] $b$]],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), mark: (end: ">", stroke:3pt), stroke: 3pt)
    })
    ],[#align(right)[$a$ #text(80pt)[#emoji.woman]]],
    [],[$B = g^B [p]$],[],
    [],[#text(80pt)[🕵🏼‍♀️]],[]
  )
 ]
 #only(2)[
  #grid(
    rows: (auto, 20%, auto),
    columns: (30%, 40%, 30%),
    [#align(left)[#text(80pt)[#emoji.man] $b$]],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), mark: (start: ">", stroke:3pt), stroke: 3pt)
    })
    ],[#align(right)[$a$, $B$ #text(80pt)[#emoji.woman]]],
    [],[$g^a [p] = A$],[],
    [],[#text(80pt)[🕵🏼‍♀️]],[]
  )
 ]

 #only(3)[
  #grid(
    rows: (auto, 20%, auto),
    columns: (30%, 40%, 30%),
    [#align(left)[#text(80pt)[#emoji.man] $b$, $A$]],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), mark: (start: ">", stroke:3pt), stroke: 3pt)
    })
    ],[#align(right)[$a$, $B$ #text(80pt)[#emoji.woman]]],
    [],[],[],
    [$A^b = K$],[#text(80pt)[🕵🏼‍♀️]],[$K = B^a$]
  )
 ]
]

#slide[
  == Et Eve dans tout ça ? 🕵🏼‍♀️

  Eve connaît :
  
  - $p, g$
  - $A = g^a [p], B = g^b [p]$
  - Doit calculer $g^(a b) [p]$

  Facile si elle pouvait calculer $a$ à partir de $g^a [p]$ #sym.arrow problème du *logarithme discret* supposé difficile.
]

#slide[
  == Diffie-Hellman en pratique

  - Dans le corps des entiers _modulo_ $p$ : $p approx $ 2048 bits #sym.arrow c'est beaucoup !

  - On peut faire du Diffie-Hellman dans d'autres corps : les *courbes elliptiques* (on parle de ECDH - _Elliptic Curve Diffie-Hellman_)
   - il faut bien choisir ses courbes, son implémentation, etc...
   - mais la taille du corps est plus petite : entre $256$ et $approx 500$ bits ! 
    - courbes elliptiques : solutions d'une équation de type $y^2 = x^3 + a x + b$ dans un corps fini...
]

#slide[
  = Service n°2 : le chiffrement asymétrique
  === Ou encapsulation de clé

  Problème de Diffie-Hellman : protocole *interactif*

    - Alice et Bob doivent *tous deux* échanger des messages avant d'établir la clé
    - Parfois, ce n'est pas possible, on aimerait pouvoir utiliser un protocole *plus simple*
]

#slide[
  == Le chiffrement asymétrique

#h(2pt)

 #set align(center)
 #only(1)[
  #grid(
    rows: (20%, 20%, auto),
    columns: (25%, 50%, 25%),
    [#text(80pt)[#emoji.man] $K_"priv"^"B"$],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), mark: (start: ">", stroke:3pt), stroke: 3pt)
    })
    ],[$K_"pub"^"B", K$ #text(80pt)[#emoji.woman]],
    [],[C = Chif($K_"pub"^"B"$, $K$)],[],
    [],[#text(80pt)[🕵🏼‍♀️] $K_"pub"^B$],[]
  )
 ]
 #only(2)[
  #grid(
      rows: (20%, 20%, auto),
      columns: (30%, 40%, 30%),
      [#text(80pt)[#emoji.man] $K_"priv"^"B"$],[
      #cetz.canvas({
        import cetz.draw: *
        line((0, 5), (10, 5),  stroke: 3pt)
      })
      ],[$K_"pub"^"B", K$ #text(80pt)[#emoji.woman]],
      [$K$ = Déchif($K_"priv"^B$, C)],[],[],
      [],[#text(80pt)[🕵🏼‍♀️] $K_"pub"^B$],[]
    )
 ]
]

#slide[
  == Chiffrement asymétrique : pour résumer

  Dans un système de chiffrement asymétrique :

  - la clé privée est *secrète*, la clé publique est *connue de tous*
  - on *chiffre* avec la *clé publiqué*, on *déchiffre* avec la clé *privée*
  - on peut facilement retrouver la clé *publique* à partir de la clé *privée* (mais l'inverse n'est pas possible !)
]

 #slide[
  == Chiffrement asymétrique : notation

 
Un système de chiffrement *asymétrique* se compose de:

- Quatre ensembles $E, F, K ("clés privées"), K' ("clés publiques")$
- D'une fonction *à sens unique* $h : K arrow.bar.r K'$
- De deux fonctions, $f : E times K arrow.bar.r F, g: F times K arrow.bar.r E$ telles que
  - $forall x in E, k in K, g(f(x, k), h(k)) = x$
  - On ne doit pas pouvoir retrouver $x$ à partir de $f(x, k)$ sans connaître $k$
]

#slide[
  == Le 1er algorithme de chiffrement asymétrique : RSA

  #figure(
            image("img/rsa.jpg", height:60%),
            caption: "Rivest, Shamir, Adleman",
            kind: "Image",
            supplement: [Image]
  )
]

#slide[
  == RSA : définitions
Publié en 1977.

- Clé publique : 
   - $n$ produit de deux grands nombre premiers $p$ et $q$
   - $e$, un nombre quelconque premier avec $(p-1)(q-1)$
- Clé privée :
   - $n$ comme précédemment
   - $d$ inverse de $e$ modulo $(p-1)(q-1)$
]

#slide[
  == RSA : chiffrons et déchiffrons !

  #grid(
    rows: (auto),
    columns: (20%, 40%, 40%),
    [#text(14pt)[
      Rappels:
      
      $n = p dot q$
      $phi(n)= (p-1)(q-1)$
      $"pgcd"(e, phi(n)) = 1$

      $e dot d equiv 1 [phi(n)]$
    ]
    ],[Pour chiffrer $m < n$ :
      - $C = m^e [n]$
      
      Pour déchiffrer :
      - $m = C^d [n]$

      Pourquoi ça marche ?

      $m ^ (e dot d) = m [n]$ ???
    
    ],
    [#only(2)[
      En fait, $forall m$, $m ^ phi(n)  = 1 [n]$

      Du coup, comme $e dot d = 1 + k dot phi(n)$,

      $
      m^(e dot d) [n] &= m^(1+k dot phi(n)) [n]\
      &= m dot m^(k dot phi(n)) [n]\
      &= m dot (m^phi(n))^k [n] = m [n]
      $
    ]]
  )
]

#slide[
  == Pourquoi c'est sûr ?

  Un attaquant doit pouvoir retrouver $(p-1)(q-1)$ à partir de $n$ #sym.arrow.r cela revient à trouver $p$ et $q$, donc de *factoriser* $n$.

  Il existe peut-être des méthodes plus efficaces mais elle ne sont pas connues.

  On considère que $n approx 2048 "bits"$ confère une bonne sécurité aujourd'hui, et $n approx 4096 "bits"$ confère suffisamment de sécurité pour toutes les applications usuelles.
]

#slide[
  == Envoyons des clés !

  $m$ : clé AES $=$ entre $128$ bits et $192$ bits\
  $e$ : historiquement la valeur $3$ était beaucoup utilisée et elle est valide


  Il suffit de générer $p,q$, calculer $n$ et envoyer $m^3 [n]$ !
  

  #only(2)[
  #text(fill:red, size:40pt)[NE FAITES JAMAIS ÇA]
  
  $m^3$ est plus petit que $n$, il suffit de prendre la racine troisième pour décrypter
  ]

]

#slide[
  == Quand est-ce que RSA est sûr ?

  La sécurité de RSA n'est effective *uniquement pour *$m$ *généré uniformément dans *$[1;n-1]$. Pour simuler cela :

  *Le retour des paddings* !

   - PKCS\#1 v1.5 : `PS` est une chaîne aléatoire (d'octets non nuls) de longueur suffisante, et on chiffre : 
      
      `0x00 || 0x02 || PS || 0x00 || m`
   - OAEP : mieux, plus moderne, plus sûr et plus compliqué

]

#slide[
  == Choix de $e$

  Choix historique $e=3$ déconseillé (certaines attaques sont plus faciles avec $e$ petit)

  Tout le monde ou presque utilise $e = 65537 = 2^16 + 1$
]

#slide[
  == Chiffrer avec Diffie-Hellman ?

  Cryptosystème de ElGamal (1985) :

  On choisit $p$ premier, $g in [1, p-1]$ comme paramètres plublics.

  La clé privée est $x in [1, p-1]$ choisie uniformément.\
  La clé publique est $h=g^x$.

  Le chiffré est $(c_1, c_2)=(g^y [p], m dot h^y [p]$) ($y$ choisi uniformémént)

  Pour déchiffrer : $s = c_1^x = h^y [p]$ puis $m = c_2 dot s^(-1) [p]$

  Algorithme général marche aussi sur des courbes elliptiques
]

#slide[
  == Service n°3 : l'authenticité
]
