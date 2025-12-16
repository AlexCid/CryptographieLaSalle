#import "@preview/polylux:0.3.1": *
#import "@preview/tablex:0.0.9": colspanx, gridx, hlinex, rowspanx, tablex, vlinex
#import "@local/svg-emoji:0.1.0": github, noto, setup-emoji
#show: setup-emoji.with(font: noto)
#import themes.simple: *
#import "@preview/cetz:0.1.2"

#set text(font: "Inria Sans")

#show: simple-theme.with(
  footer: [Chiffrement asymétrique],
)

#title-slide[
  = Cryptographie
  #v(2em)
  Cryptographie asymétrique
  #v(2em)

  Alexander Schaub #footnote[DGA-MI, Bruz] #h(1em)

  schaub.alexander\@free.fr



  17/12/2025
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
    [#text(80pt)[#emoji.man] clé],
    [
      #cetz.canvas({
        import cetz.draw: *
        line((0, 5), (10, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
      })
    ],
    [clé #text(80pt)[#emoji.woman]],

    [], [Chiffré(clé, message)], [],
    [], [#text(80pt)[🕵🏼‍♀️]], [],
  )
]

#slide[
  == Et s'ils ne se sont jamais vus ?

  #set align(center)
  #grid(
    rows: (auto, 20%, auto),
    columns: (20%, 60%, 20%),
    [#text(80pt)[#emoji.man] clé],
    [
      #cetz.canvas({
        import cetz.draw: *
        line((0, 5), (10, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
      })
    ],
    [ #text(80pt)[🙍‍♀️]],

    [], [Chiffré(clé, message)], [],
    [], [#text(80pt)[🕵🏼‍♀️]], [],
  )
]

#slide[
  == Et s'ils ne se sont jamais vus ?

  #set align(center)
  #grid(
    rows: (auto, 20%, auto),
    columns: (20%, 60%, 20%),
    [#text(80pt)[#emoji.man] clé],
    [
      #cetz.canvas({
        import cetz.draw: *
        line((0, 5), (10, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
      })
    ],
    [ #text(80pt)[#emoji.woman]],

    [], [clé, Chiffré(clé, message)], [],
    [], [#text(80pt)[🕵🏼‍♀️] message], [],
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
      [#align(left)[#text(80pt)[#emoji.man] $K_"priv"^"B"$]],
      [
        #align(center)[#cetz.canvas({
            import cetz.draw: *
            line((0, 5), (10, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
          })
        ]],
      [#align(right)[$K_"priv"^"A"$ #text(80pt)[#emoji.woman  ]]],

      [], [#align(center)[$K_"pub"^B$]], [],
      [], [#align(center)[#text(80pt)[🕵🏼‍♀️] $K^B_"pub"$]], [],
    )
  ]
  #only(2)[
    #grid(
      rows: (auto, 20%, auto),
      columns: (30%, 40%, 30%),
      [#text(80pt)[#emoji.man] $K_"priv"^"B"$],
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 5), (10, 5), mark: (start: ">", stroke: 3pt), stroke: 3pt)
        })
      ],
      [#align(right)[$K_"priv"^"A"$, $K_"pub"^B$ #text(80pt)[#emoji.woman]]],

      [], [#align(center)[$K_"pub"^A$]], [],
      [], [#align(center)[#text(80pt)[🕵🏼‍♀️]$K^B_"pub"$, $K^A_"pub"$ ]], [],
    )
  ]

  #only(3)[
    #grid(
      rows: (auto, 20%, auto),
      columns: (30%, 40%, 30%),
      [#text(80pt)[#emoji.man] $K_"priv"^"B"$, $K_"pub"^A$],
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 5), (10, 5), stroke: 3pt)
        })
      ],
      [#align(right)[$K_"priv"^"A"$, $K_"pub"^B$ #text(80pt)[#emoji.woman]]],

      [], [], [],
      [$f(K_"priv"^"B", K_"pub"^A) = K$],
      [#align(center)[#text(80pt)[🕵🏼‍♀️] $K^B_"pub"$, $K^A_"pub"$ ]],
      [$K = f(K_"priv"^"A", K_"pub"^B)$],
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
      [#align(left)[#text(80pt)[#emoji.man] $b$]],
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 5), (10, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
        })
      ],
      [#align(right)[$a$ #text(80pt)[#emoji.woman]]],

      [], [$B = g^B [p]$], [],
      [], [#text(80pt)[🕵🏼‍♀️]$B$], [],
    )
  ]
  #only(2)[
    #grid(
      rows: (auto, 20%, auto),
      columns: (30%, 40%, 30%),
      [#align(left)[#text(80pt)[#emoji.man] $b$]],
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 5), (10, 5), mark: (start: ">", stroke: 3pt), stroke: 3pt)
        })
      ],
      [#align(right)[$a$, $B$ #text(80pt)[#emoji.woman]]],

      [], [$g^a [p] = A$], [],
      [], [#text(80pt)[🕵🏼‍♀️]$B,A$], [],
    )
  ]

  #only(3)[
    #grid(
      rows: (auto, 20%, auto),
      columns: (30%, 40%, 30%),
      [#align(left)[#text(80pt)[#emoji.man] $b$, $A$]],
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 5), (10, 5), mark: (start: ">", stroke: 3pt), stroke: 3pt)
        })
      ],
      [#align(right)[$a$, $B$ #text(80pt)[#emoji.woman]]],

      [], [], [],
      [$A^b = K$], [#text(80pt)[🕵🏼‍♀️]$B,A$], [$K = B^a$],
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

  - Dans le corps des entiers _modulo_ $p$ : $p approx$ 2048 bits #sym.arrow c'est beaucoup !

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
      [#text(80pt)[#emoji.man] $K_"priv"^"B"$],
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 5), (10, 5), mark: (start: ">", stroke: 3pt), stroke: 3pt)
        })
      ],
      [$K_"pub"^"B", K$ #text(80pt)[#emoji.woman]],

      [], [C = Chif($K_"pub"^"B"$, $K$)], [],
      [], [#text(80pt)[🕵🏼‍♀️] $K_"pub"^B$], [],
    )
  ]
  #only(2)[
    #grid(
      rows: (20%, 20%, auto),
      columns: (30%, 40%, 30%),
      [#text(80pt)[#emoji.man] $K_"priv"^"B"$],
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 5), (10, 5), stroke: 3pt)
        })
      ],
      [$K_"pub"^"B", K$ #text(80pt)[#emoji.woman]],

      [$K$ = Déchif($K_"priv"^B$, C)], [], [],
      [], [#text(80pt)[🕵🏼‍♀️] $K_"pub"^B$], [],
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
  - De deux fonctions, $f : E times K arrow.bar.r F, g: F times K' arrow.bar.r E$ telles que
    - $forall x in E, k in K, g(f(x, h(k)), k) = x$
    - On ne doit pas pouvoir retrouver $x$ à partir de $f(x, h(k))$ sans connaître $k$
]

#slide[
  == Le 1er algorithme de chiffrement asymétrique : RSA

  #figure(
    image("img/rsa.jpg", height: 60%),
    caption: "Rivest, Shamir, Adleman",
    kind: "Image",
    supplement: [Image],
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
    rows: auto,
    columns: (20%, 40%, 40%),
    [#text(14pt)[
        Rappels:

        $n = p dot q$ \
        $phi(n)= (p-1)(q-1)$
        $"pgcd"(e, phi(n)) = 1$

        $e dot d equiv 1 [phi(n)]$
      ]
    ],
    [Pour chiffrer $m < n$ :
      - $C = m^e [n]$

      Pour déchiffrer :
      - $m = C^d [n]$

      Pourquoi ça marche ?

      $m^(e dot d) = m [n]$ ???

    ],
    [#only(2)[
      En fait, $forall m$, $m^phi(n) = 1 [n]$

      Du coup, comme $e dot d = 1 + k dot phi(n)$,

      $
        m^(e dot d) [n] & = m^(1+k dot phi(n)) [n] \
                        & = m dot m^(k dot phi(n)) [n] \
                        & = m dot (m^phi(n))^k [n] = m [n]
      $
    ]],
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

  $m$ : clé AES $=$ entre $128$ bits et $256$ bits\
  $e$ : historiquement la valeur $3$ était beaucoup utilisée et elle est valide


  Il suffit de générer $p,q$, calculer $n$ et envoyer $m^3 [n]$ !


  #only(2)[
    #text(fill: red, size: 40pt)[NE FAITES JAMAIS ÇA]

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


#focus-slide[
  Interlude : le projet !

  #set align(left);

  - Groupes de 2 ou 3

  - Proposition de sujet d'ici la prochaine séance

  - Noté sur des présentations de 30 (?) min
]

#slide[
  = Service n°3 : l'authenticité
  #let cell = rect.with(
    inset: 8pt,
    fill: rgb("e4e5ea"),
    width: 100%,
    radius: 6pt,
  )

  #only(1)[
    #grid(
      rows: (25%, auto),
      columns: (20%, 15%, 30%, 15%, 20%),
      [#align(left)[#text(80pt)[#emoji.man] ]],
      [
        #align(center)[#cetz.canvas({
            import cetz.draw: *
            line((0, 5), (5, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
            content(((0, 5.5), .5, (5, 5.5)), [$K_"pub"^B$], anchor: "bottom")
          })
        ]],
      [#align(center)[#text(80pt)[🕵🏼‍♀️]]],
      [#cetz.canvas({
        import cetz.draw: *
        line((0, 5), (5, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
        content(((0, 5.5), .5, (5, 5.5)), [#text(fill: white)[.]], anchor: "bottom")
      })],
      [#align(right)[#text(80pt)[#emoji.woman]]],

      [$K_"priv"^"B"$, $K_"pub"^"B"$], [], [$K^E_"priv"$, $K_"pub"^E$, $K_"pub"^"B"$], [], [#align(right)[$K$]],
    )
  ]

  #only(2)[
    #grid(
      rows: (25%, auto),
      columns: (20%, 15%, 30%, 15%, 20%),
      [#align(left)[#text(80pt)[#emoji.man] ]],
      [
        #align(center)[#cetz.canvas({
            import cetz.draw: *
            line((0, 5), (5, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
            content(((0, 5.5), .5, (5, 5.5)), [#text(fill: white)[.]], anchor: "bottom")
          })
        ]],
      [#align(center)[#text(80pt)[🕵🏼‍♀️]]],
      [#cetz.canvas({
        import cetz.draw: *
        line((0, 5), (5, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
        content(((0, 5.5), .5, (5, 5.5)), [$K_"pub"^#text(fill: red)[E]$], anchor: "bottom")
      })],
      [#align(right)[#text(80pt)[#emoji.woman]]],

      [$K_"priv"^"B"$, $K_"pub"^"B"$], [], [$K^E_"priv"$, $K_"pub"^E$, $K_"pub"^"B"$], [], [#align(right)[$K$]],
    )
  ]
  #only(3)[
    #grid(
      rows: (25%, auto),
      columns: (20%, 15%, 30%, 15%, 20%),
      [#align(left)[#text(80pt)[#emoji.man] ]],
      [
        #align(center)[#cetz.canvas({
            import cetz.draw: *
            line((0, 5), (5, 5), mark: (end: ">", stroke: 3pt), stroke: 3pt)
            content(((0, 5.5), .5, (5, 5.5)), [#text(fill: white)[.]], anchor: "bottom")
          })
        ]],
      [#align(center)[#text(80pt)[🕵🏼‍♀️]]],
      [#cetz.canvas({
        import cetz.draw: *
        line((0, 5), (5, 5), mark: (start: ">", stroke: 3pt), stroke: 3pt)
        content(((0, 5.5), .5, (5, 5.5)), [C=Chif($K_"pub"^#text(fill: red)[E],K)$], anchor: "bottom")
      })],
      [#align(right)[#text(80pt)[#emoji.woman]]],

      [$K_"priv"^"B"$, $K_"pub"^"B"$],
      [],
      [$K^E_"priv"$, $K_"pub"^E$,$K_"pub"^"B"$],
      [],
      [#align(right)[$K$, $K_"pub"^#text(fill: red)[E]$]],
    )
  ]

  #only(4)[
    #grid(
      rows: (25%, auto),
      columns: (20%, 15%, 30%, 15%, 20%),
      [#align(left)[#text(80pt)[#emoji.man] ]],
      [
        #align(center)[#cetz.canvas({
            import cetz.draw: *
            line((0, 5), (5, 5), mark: (start: ">", stroke: 3pt), stroke: 3pt)
            content(((0, 5.5), .5, (5, 5.5)), [Chif($K_"pub"^#text(fill: black)[B],K)$], anchor: "bottom")
          })
        ]],
      [#align(center)[#text(80pt)[🕵🏼‍♀️]]],
      [#cetz.canvas({
        import cetz.draw: *
        line((0, 5), (5, 5), mark: (start: ">", stroke: 3pt), stroke: 3pt)
        content(((0, 5.5), .5, (5, 5.5)), [#text(fill: white)[.]], anchor: "bottom")
      })],
      [#align(right)[#text(80pt)[#emoji.woman]]],

      [$K_"priv"^"B"$, $K_"pub"^"B"$],
      [],
      [$K^E_"priv"$, $K_"pub"^E$,$K_"pub"^"B"$, $K=$ Déchif($K_"priv"^E$, C)],
      [],
      [#align(right)[$K$, $K_"pub"^#text(fill: red)[E]$]],
    )
  ]

]

#slide[
  == L'attaque de l'homme-du-milieu (_man-in-the-middle_)


  Comme on a pu le voir :

  - un attaquant *actif* peut intercepter *et modifier* des messages entre correspondants
  - en cas de réussite, les correspondants *ne se doutent de rien* mais la *confidentialité* de leurs échanges va être *compromise*

  - possible car rien ne garantit *l'origine* des messages reçus (ici, principalement $K_"pub"^B$)
]

#slide[
  == Les signatures électroniques

  Permet de garantir *l'origine* du message.

  Seul le détenteur de la *clé de génération de signature* peut authentifier des messages, tous les détenteurs de la *clé de vérification de signature* peuvent vérifier leur authenticité.

]
#slide[
  == Signature électronique : notation

  - Quatre ensembles $E$ (messages), $F$(signatures), $K$ (clés de génération), $K'$ (clés de vérification)
  - D'une fonction *à sens unique* $h : K arrow.bar.r K'$
  - De deux fonctions, $f : E times K arrow.bar.r F, g: F times E times K' arrow.bar.r {"true", "false"}$ telles que
    - $forall x in E, k in K, g(f(x, k),x, h(k)) = "true"$
    - Trouver $y in F$ tel que $g(y, x, h(k)) = "true"$ revient à connaître $k$
]

#slide[
  == Un exemple de signature électronique : RSA !

  - Clé de vérification :
    - $n$ produit de deux grands nombre premiers $p$ et $q$
    - $e$, un nombre quelconque premier avec $(p-1)(q-1)$
  - Clé de génération :
    - $n$ comme précédemment
    - $d$ inverse de $e$ modulo $(p-1)(q-1)$
]
#slide[
  == RSA : signons et vérifions !

  #grid(
    rows: auto,
    columns: (20%, 80%),
    [#text(14pt)[
        Rappels:

        $n = p dot q$\
        $phi(n)= (p-1)(q-1)$
        $"pgcd"(e, phi(n)) = 1$

        $e dot d equiv 1 [phi(n)]$
      ]
    ],
    [Pour signer $m < n$ :

      $S = m^d [n]$

      Pour vérifier :

      $S^e [n] = m$ #sym.arrow $"true"$ sinon $"false"$

      Pourquoi ça marche ?

      $m^(e dot d) = m [n]$ #sym.arrow ah oui on vient de le voir

    ],

    [],
  )
]

#slide[
  == Signons des clés !

  $m$ : clé AES $=$ entre $128$ bits et $256$ bits\
  On envoie $m^d [n]$, et c'est bon cette fois non ?


  #only(2)[
    #text(fill: red, size: 35pt)[NE FAITES JAMAIS ÇA]

    On peut trivialement générer des signatures pour tous les messages de type $r^e [n]$, $r$ quelconque par exemple.

    En plus : on aimerait pouvoir signer des messages plus long que $4096$ bits. Comment peut-on faire ?
  ]

]

#slide[
  == Aparté : les fonctions de hachage

  #one-by-one[
    On ne peut signer que des éléments relativement _courts_\ \
  ][
    Il faut donc *réduire* les messages avant de les signer\ \
  ][
    Mais attention ! pas n'importe comment ! \
    Il ne faut pas réduire *deux messages* de la *même façon*
  ]

]

#slide[
  == Fonctions de hachage : les attendus


  Une *fonction de hachage* est une fonction  $f : {0,1}^* arrow.bar {0,1}^n$ :

  - résistante aux collisions : on ne doit pas pouvoir trouver $m_1 eq.not m_2$ tels que
  $f(m_1) = f(m_2)$

  - résistante à l'inversion : étant donné $y in {0,1}^n$, on ne doit pas pouvoir trouver $m$ tel que
  $f(m) = y$
]

#slide[
  == Fonctions de hachage : les bonus

  En général, on peut aussi s'attendre aux propriétés suviantes :

  - Indistinguable de l'aléa : une fonction de hachage $f$ est idéalement *indistinguable* d'une fonction choisie au hasard

  - Propriété _d'avalanche_ : en changeant *1* bit de l'entrée, chaque bit de sortie a *une chance sur deux* d'être inversé
    - (c'est impliqué par la propriété précédente, voyez-vous pourquoi ?)
]

#slide[
  == Les fonctions de hachage modernes

  - #strike[MD4, MD5, SHA1] : on oublie, c'est cassé
  - SHA2 : existe en plusieurs versions, en fonction de la taille de sortie :
    - SHA256, SHA384, SHA512, SHA512-256, SHA512-384
  - SHA3 (_alias_ Keccak ) : une famille de fonctions
    - Existe en version à tailles standardisées (256, 384, 512 bits)
    - Existe aussi en version à taille arbitraire
]

#slide[
  == Signatures : le retour

  - On ne signe pas les clés, on signe *le haché* des clés
  - On ne les signe pas non plus *directement*, c'est le retour du *padding* :

    - PKCS\#1 v1.5 (Signature) : déterministe
    `0x00 || 0x01 || FFFFF...FFFF || 0x00 || Type de hash ||  m`

    - PSS : probabiliste et plus moderne
      - et également plus compliqué à décrire
]


#slide[
  = C'est tout pour aujourd'hui !

  La séance prochaine, nous verrons :

  - quelques services de plus : intégrité, dérivation de clés

  - comment assembler les services en des *protocoles* de la vraie vie : TLS, SSH

  - en bonus : un peu de temps pour le projet
]
