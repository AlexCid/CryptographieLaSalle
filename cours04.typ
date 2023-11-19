#import "@preview/polylux:0.2.0": *
#import "@preview/tablex:0.0.6": tablex, gridx, hlinex, vlinex, colspanx, rowspanx
#import "@local/svg-emoji:0.1.0": setup-emoji, noto, github
#show: setup-emoji.with(font: noto)
#import themes.simple: *
#import "@preview/cetz:0.1.2"

#set text(font: "Inria Sans")

#show: simple-theme.with(
  footer: [Protocoles cryptographiques],
)

#title-slide[
  = Cryptographie
  #v(2em)
  Protocoles cryptographiques
  #v(2em)

  Alexander Schaub #footnote[DGA-MI, Bruz] #h(1em)
  
  schaub.alexander\@free.fr

  

  20/11/2023
]

#slide[
    == Dans l'épisode précédent...

    - On a vu comment *partager* des clés entre deux participants
    - On a vu comment *garantir l'authenticité* de données reçues
        - ... à condition d'avoir confiance en la *clé publique* de l'expéditeur !

    Aujourd'hui, nous allons compléter ces services afin de construire des protocoles de la vraie vie :
    #only(2)[
    - SSH v2.0 (RFC4253)
    - TLS v1.3 (RFC8446)
    ]


]

#slide[
    == Authentification symétrique

Mais avant cela, petit interlude !

- Lors de la dernière séance, nous avons vu l'authentification *asymétrique* grâce aux *signatures électroniques*
- L'authentification symétrique existe en deux variantes :
    - le MAC
    - le chiffrement authentifié (ou AEAD)
]

#slide[
    = MAC (Message Authentication Code)

- Rien à voir avec les Mac(intosh) de la marque à la #emoji.apple
- Rien à voir avec les adresses MAC (Media Access Control) Ethernet

- Comme une signature, mais avec la *même clé* de signature et de vérification

]

#slide[
    == MAC : notation

- Trois ensembles $E$ (messages), $F$ (_tags_ #sym.approx signatures), $K$ (clés MAC)
- De deux fonctions, $f : E times K arrow.bar.r F, g: F times E times K arrow.bar.r {"true", "false"}$ telles que
  - $forall x in E, k in K, g(f(x, k),x, k) = "true"$
  - Trouver $y in F$ tel que $g(y, x, k) = "true"$ revient à connaître $k$

]

#slide[
    == MAC : construction HMAC (1)
    - Les fonctions hachage semblent obtenir des bonnes propriétés pour construire un MAC
    - Comment combiner message et clé ?
        - Première tentative : $f(x,k)  = "HASH"(k || x)$
            - N'est pas sûr ! MD5, SHA1 et SHA2 sont susceptibles à des attaques *par extension de longueur*.
            Étant donné $"HASH"(m)$ et la longueur de $m$, on peut calculer $"HASH"(m||m')$ pour $m'$ arbitraire 

            #text(size:20pt)[(L'état interne de ces fonctions de hash à la fin du message est connaissable à partir du haché produit)]
]

#slide[
    == MAC : construction HMAC (2)

    - Deuxième tentative : $f(x,k) = "HASH"(x || k)$
        - Mieux mais à cause de l'attaque par extension de longueur, une collision de $"HASH"$ sur $x$ produirait une collision sur $f(x,k)$. 

    - Bonne solution : $f(x,k) = "HASH"(k || "HASH"(k || x))$
        - Encore mieux si on n'utilise pas la même clé les deux fois :
        
        $f(x,k) = "HASH"(k xor "opad" || "HASH"(k xor "ipad" || x))$
         avec IPAD, OPAD deux constantes (RFC2104)
]

#slide[
    == MAC : à quoi ça sert ?

Imaginons que vous envoyez ce message à votre banquier :

    `Envoyez 10000 euros sur le compte FR76123456789. Mot de passe convenu : bqs87DQ9sdfl98qsf`

Ce message est chiffré avec un *chiffrement par flot* (rappel : consiste à générer une séquence pseudo-aléatoire et à XORer avec le message).

Eve intercepte le message, elle connait l'ordre et sa formulation mais pas le mot de passe. Elle veut détourner l'argent sur son compte. Comment s'y prend-elle ? Comment modifie-t-elle le message ?

]

#slide[
    = Chiffrement authentifié

    - On veut souvent protéger la confidentialité *et* l'intégrité des données
    - Combiner les deux services = chiffrement authentifié (ou AEAD)
        #text(size: 20pt)[L'AEAD permet aussi d'authentifier des données claires en plus mais c'est du bonus]
    - En général, consiste à combiner un *mode de chiffrement* avec un algorithme de *MAC*
    - Algorithmes les plus utilisés :
        - *AES-GCM* : AES-CTR + GHASH
        - *ChaCha20Poly1305* : ChaCha20 + Poly1305
    - Constructions plus anciennes : chiffrement + HMAC avec deux clés *distinctes*
]

#slide[
    == AES-GCM
    - Utilisé avec de clés de 128-bits (AES-128) et IV de *96 bits*
        - Valeur potentiellemnt problématique : l'espace d'IV est petit si généré aléatoirement
        - L'IV ne doit *jamais* être réutilisé (fuite de la clé d'authentification)
    
    #figure(
            image("img/ctr.svg", height:40%),
            caption: "(Dé-)Chiffrement CTR",
            kind: "Image",
            supplement: [Image]
  )
]

#slide[
    == GHASH

    Évaluation de polynôme : si $S_i in (0,1)^(128), i=1..m+n+1 $ sont les données à protéger en intégrité ($m$ blocs de données additionnelles, $n$ blocs de chiffré paddés avec des $0$ + les tailles), alors 

    $"tag" = "Chiff"_k"(IV" || 0^(32)")" + sum_(i=1)^(m+n+1) S_i dot H^(2+m+n-i)   "        [dans GF("2^(128)")]"$

    où $H = "Chiff"_k (0^(128))$

]


#slide[
    == Chacha20Poly1305

    - Clé de 256 bits, IV de 96 bits
        - XChacha20Poly1305 avec IV de 192 existe et serait mieux, mais pas standardisé #emoji.face.sad
    - Poly1305 : évaluation de polynôme. Soit $S$ identique que précédemment,

    $"tag" = (s + sum_(i=1)^(m+n+1) (S_i+2^(128)) dot r^(2+m+n-i) mod (2^(130)-5)) mod (2^(128))$


    où $"Chacha20"_k ("IV"||0^(32)) = r||s||0^(256)$ et $|r| = |s| = 128 "bits"$

    (pas tout à fait exact pour le dernier $S_i$ mais passons)


]


#slide[
    = Stockage de mot de passe 
 #tablex(
  columns: (auto, auto),
  auto-hlines: true,
  auto-lines: false,

  
  [*Email*],  [*Mot de passe*], 

  [xxkevindu36xx\@hotmail.fr],[roxxor],
  [jean.charles\@gmail.com], [pupuce1993],
  [john.doe\@fr.fr],[lkqj098qlkjdq78!09dq],
  [xxxamandinedu39xxx\@skyblog.fr], [roxxor]
)

 #text(fill:red, weight:"bold")[#sym.arrow Il ne faut jamais stocker les mots de passe en clair ]
 
 Risque de fuite de données, mise en danger des utilisateurs si réutilisation du mot de passe, etc.
]


#slide[
    == Stockage des mots de passe :  fonction de hachage
 #tablex(
  columns: (auto, auto),
  auto-hlines: true,
  auto-lines: false,

  
  [*Email*],  [*Mot de passe*], 

  [xxkevindu36xx\@hotmail.fr],[342887f489f...],
  [jean.charles\@gmail.com], [94363ba85ef0f...],
  [john.doe\@fr.fr],[ced2f800c497ba2...],
  [xxxamandinedu39xxx\@skyblog.fr], [342887f489f...]
)
 #text(fill:red, weight:"bold")[Deux problèmes :]

 - Mots de passe identiques = hachés identiques
 - Haché fonction du mot de passe uniquement : possibilité d'attaque par dictionnaire inversé

]

#slide[
    == Stockage des mots de passe : fonction de hachage + sel
 #tablex(
  columns: (auto, auto, auto),
  auto-hlines: true,
  auto-lines: false,

  
  [*Email*], [*sel*], [*Mot de passe*], 

  [xxkevindu36xx\@hotmail.fr],[su8qlsdu], [34e3808164a...],
  [jean.charles\@gmail.com],[od9us67s], [7c27b2a16d27429...],
  [john.doe\@fr.fr],[nsk9jd24],[34a37ab14b39dafd...],
  [xxxamandinedu39xxx\@skyblog.fr],[nmqh75s0], [c8d6c66cebe42...]
)
 #text(fill:red, weight:"bold")[Un problème :]

 - Mots de passe identiques = hachés différents , mais
 - Fonction de hachage facile à calculer : inversion d'un mot de passe faible possible

]

#slide[
    == Stockage de mots de passe : dérivation de clé

Utilisation similaire à fonction de hachage avec sel mais :
- optimisé pour être difficile à inverser par GPU / puce dédiée (ASIC)
- Malheureusement, possèdent souvent plein de paramètres à choisir (prendre ceux par défaut de la bibliothèque cryptographique choisie !)
#grid(
    columns: (40%, auto),
    [ Algorithmes conseillés : 
- argon2id
- balloon
- scrypt], [Algorithmes historiques :
- PBKDF1 (à éviter !)
- PBKDF2 (HMAC itéré)
- bcrypt]
)
]

#slide[
    = Protocoles cryptographiques

- On a vu tous les "blocs de base" de la cryptographie "courante"
- Il faut ensuite les associer pour obtenir des services possédant les bonnes propriété :
 - confidentialité des échanges
 - intégrité des données échangées
 - garanties quant à l'identité des participants
 - ...

Nous en verrons deux plus en détail: SSHv2 et TLS v1.3.

]

#slide[
    == SSH : présentation

   Permet de se connecter *de façon sécurisée* à un serveur distant et d'agir comme si on y était connecté physiquement (entre autres; permet aussi le transfert de fichier, le _tunneling_ d'autres flux réseau, etc.)

   Protocole assez ancien : première version en 1995, pour remplacer `telnet`. v2 améliorant grandement la sécurité en 2006.

    
]

#slide[
    == SSH : Négotiation d'algorithmes

    #grid(
    rows: (15%, 30%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻]],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), stroke: 3pt, mark: (end: ">", stroke:3pt))
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[Liste d'algorithmes acceptés],[],

  )
  #v(-2.5em)
      Algorithmes pour :
      - échange de clés
      - capacité des clés serveur (signature ou chiffrement)
      - chiffrement de données client #sym.arrow serveur et serveur #sym.arrow client
      - MAC client #sym.arrow serveur et serveur #sym.arrow client
]

#slide[
    == SSH : Négotiation d'algorithmes

    #grid(
    rows: (15%, 30%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻]],[
    #cetz.canvas({
      import cetz.draw: *
      line((0, 5), (10, 5), stroke: 3pt, mark: (start: ">", stroke:3pt))
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[Liste d'algorithmes acceptés],[],

  )
  #v(-2.5em)
      Algorithmes pour :
      - échange de clés
      - capacité des clés serveur (signature ou chiffrement)
      - chiffrement de données client #sym.arrow serveur et serveur #sym.arrow client
      - MAC client #sym.arrow serveur et serveur #sym.arrow client
]

#slide[
    == SSH : Échange de clés (Diffie-Hellman)
        #grid(
    rows: (15%, 30%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻] $x$],[
    #cetz.canvas({
      import cetz.draw: *
      let (a, b) = ((0, 5), (10, 5))
      line(a, b, stroke: 3pt, mark: (start: ">", stroke:3pt))
      content((a, 0.5, b), angle: b, [$e = g^x "mod" p$], anchor: "top", padding: 10pt)
    
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[],[],
    )

Note: le groupe (défini par $g$ et $p$) est public et partagé suite à la négotiation d'algorithmes
]

#slide[
    == SSH : Échange de clés (Diffie-Hellman) (II)
        #grid(
    rows: (20%, 25%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻] $x$],[
    #cetz.canvas({
      import cetz.draw: *
      let (a, b) = ((0, 5), (10, 5))
      line(a, b, stroke: 3pt, mark: (start: ">", stroke:3pt))
      content((a, 0.5, b), angle: b, [$K_"verif", g^y "mod" p, "Sign"_K_"sig" (H)$], anchor: "top", padding: 10pt)
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[],[$K_"sign"$,$K= e^y "mod" p,$ $H = "Hash"(K || e || f || ..)$],
    )
#v(-1em)
Deux manières de vérifier l'authenticité de $K_"verif"$:
- Un certificat (plus d'infos dans la prochaine partie !)
- TOFU (_Trust On First Use_) : on accepte la première clé publique reçue du serveur et on la stocke pour une vérification ultériure
]

#slide[
    == SSH : Échange de clés (Diffie-Hellman) (II)

    
        #grid(
    rows: (20%, 25%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻] $x, K = f^x "mod" p,$ $H = "Hash"(...) $],[
    #cetz.canvas({
      import cetz.draw: *
      let (a, b) = ((0, 5), (10, 5))
      line(a, b, stroke: 3pt)
      content((a, 0.5, b), angle: b, [], anchor: "top", padding: 10pt)
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[],[$K_"sign"$,$K= e^y "mod" p,$ $H = "Hash"(K || e || f || ..)$],
    )
#v(-2.5em)
Le client vérifie la signature. Si elle convient, le serveur et le client se sont mis d'accord sur $H$ et $K$, puis dérivent :
- l'IV de chiffrement initial (client #sym.arrow serveur et serveur #sym.arrow client )
- la clé de chiffrement client #sym.arrow serveur et serveur #sym.arrow client
- la clé de MAC client #sym.arrow serveur et serveur #sym.arrow client
]

#slide[
    == SSH : Tunnel non-sécurisé
Un paquet SSH échangé contient les données suivantes :

- taille du paquet (sur 4 octets)
- taille du padding (sur 1 octet)
- données utiles (taille du paquet - taille du padding - 1)
- padding aléatoire (taille nécessaire)
- MAC (taille en fonction de l'algo MAC choisi)

Padding : au moins 4 octets, la taille des quatre premières données doit être multiple de 8 ou de la taille du bloc de l'algorithme de chiffrement.
]

#slide[
    == SSH : Tunnel sécurisé
Après échangé des clés :
- les quatre premières données sont chiffrées (taille du paquet, taille du padding, données utiles, padding aléatoire)
- le MAC est calculé sur ces quatre champs en clair concaténé à un numéro de séquence (pour éviter le rejeu)


Le tunnel sécurisé n'est pas particulièrement élégant - pouvez-vous me dire pourquoi ?
]

#slide[
    == SSH : authentification

    Une fois le tunnel établi, le client peut se connecter :
    - soit via clé publique : le serveur connaît la clé publique, et le client signe (entre autres) la valeur $H$
    - soit via mot de passe, en le transmettant dans le tunnel sécurisé
]


#slide[
    == TLS 1.3 : Le HTTPS _moderne_
#set text(size:24pt)

#v(-1.0em)
Un petit récapitulatif :
 - SSL 1.0 initialement développé par Taher ElGamal (#text(size:18pt)[le même qui a inventé le chiffrement ElGamal]) chez Netscape (l'ancêtre de Mozilla)
 - SSL 1.0 est tout cassé, Netscape développe SSL 2.0 qui est rendu public en 1995
 - SSL 2.0 est *également* tout cassé, ce qui donne SSL 3.0 en 1996
 - L'IETF se réveille en 1999 et standardise TLS1.0, une variante de SSL 3.0
 - TLS 1.1 et 1.2 modernisent _un peu_ le protocole
- TLS 1.3, sorti en 2018, fait le grand ménage, enlève les options obsolètes et corrige plusieurs failles
]

#slide[
    == TLS : Objectif

Il s'agit d'établit *un tunnel sécurisé* entre votre *navigateur* et un *serveur web* (proposant un service HTTP).

Doit être compatible HTTP : le protocole fonctionne au-dessus d'une connection *TCP* uniquement.

Doit être résistant aux attaques par homme-du-milieu : plus question de _TOFU_, mais de *certificats*.
]

#slide[
    == TLS : Certificats
#v(-1em)
#align(center)[
    #image("img/chain_of_trust.png", width:65%)
]
#text(size: 22pt)[source: #link("https://www.exoscale.com")]
]

#slide[
    == Aparté : Que contient un certificat ?

    - Dates de validité (pas avant / pas après)
    - Nom(s) de domaine
     - avec potentiellement des _wildcard_, i.e. tous les sous-domaines
      - par contre, \*.com est interdit. Et \*.co.uk aussi...
    - Une clé publique (pour la signature, ou le chiffrement asymétrique, ou l'échange de clés)
    - Les usages possibles (authorité racine, intermédiaire, certificat final)
    - Une signature d'une authorité supérieure
    - L'identifiant de cette authorité
   
]
#slide[
    == TLS1.3 : Négotiation d'algorithmes

    #grid(
    rows: (15%, 30%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻]],[
    #cetz.canvas({
      import cetz.draw: *
      let (a, b) = ((0, 5), (10, 5))
      line(a, b, stroke: 3pt,mark: (end: ">", stroke:3pt))
      
      content((a, 0.5, b), angle: b, [Liste d'algorithmes acceptés], anchor: "top", padding: 10pt)
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[],[],

  )
  #v(-2.5em)
      Algorithmes pour :
      - chiffrement authentifié/dérivation de clé HKDF
      - groupes (EC)DHE supportés + clés publiques associéés
      - algorithmes de signature (pour TLS / optionnellement pour certificats)
      - _optionnellement : clé pré-partagée (issue d'une connexion précédente)_
]

#slide[
    == TLS1.3 : Choix d'algorithmes

    #grid(
    rows: (15%, 30%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻]],[
    #cetz.canvas({
      import cetz.draw: *
      let (a, b) = ((0, 5), (10, 5))
      line(a, b, stroke: 3pt,mark: (start: ">", stroke:3pt))
      
      content((a, 0.5, b), angle: b, [Choix d'algorithme], anchor: "top", padding: 10pt)
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[],[],

  )
  #v(-2.5em)
      - Choix d'algorithme de chiffrement
      - Choix de groupe (EC)DHE + clé publique éphémère associée
      
]

#slide[
    == TLS1.3 : Certificat serveur

    #grid(
    rows: (15%, 30%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻]],[
    #cetz.canvas({
      import cetz.draw: *
      let (a, b) = ((0, 5), (10, 5))
      line(a, b, stroke: 3pt,mark: (start: ">", stroke:3pt))
      
      content((a, 0.5, b), angle: b, [Certificat + Signature], anchor: "top", padding: 10pt)
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[],[],
  )
  - certificat (contenant une clé de vérification) + chaîne de certificats
  - signature du message client + message serveur + certificat (avec la clé correspondante au certificat)
]

#slide[
    == Aparté : Diffie-Hellman éphémère

Pour faire un échange de clés authentifié :
- Soit le certicat contient la clé publique DH du serveur,
- Soit :  
    - le certificat contient une clé de vérification de signature, 
    - le serveur génère un nouveau bi-clé pour chaque échange de clés
    - le serveur signe la clé publique de cette bi-clé

Deuxième solution appelée "échange de clé éphémère" (la première est dite _statique_)
]

#slide[
    == Aparté : Diffie-Hellman éphémère et _PFS_

PFS : _Perfect Forward Secrecy_

Même si la clé *privée* du certificat serveur est diffusée, les échages *antérieurs à cette diffusion* ne peuvent pas être compromis.

Diffie-Hellman éphémère possède la propriété PFS. Ce n'est *pas le cas* pour un Diffie-Hellman statique.
]



#slide[
    == TLS1.3 : Fin de la négociation serveur

    #grid(
    rows: (15%, 30%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻]],[
    #cetz.canvas({
      import cetz.draw: *
      let (a, b) = ((0, 5), (10, 5))
      line(a, b, stroke: 3pt,mark: (start: ">", stroke:3pt))
      
      content((a, 0.5, b), angle: b, [HMAC(...)], anchor: "top", padding: 10pt)
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[],[],
  )
  Le serveur envoie un HMAC des messages précédents. La clé est dérivée du secret partagé par (EC)DHE.
]

#slide[
    == TLS1.3 : Fin de la négociation client

    #grid(
    rows: (15%, 30%,auto),
    columns: (30%, 40%, 30%),
    [#text(80pt)[💻]],[
    #cetz.canvas({
      import cetz.draw: *
      let (a, b) = ((0, 5), (10, 5))
      line(a, b, stroke: 3pt,mark: (end: ">", stroke:3pt))
      
      content((a, 0.5, b), angle: b, [HMAC(...)], anchor: "top", padding: 10pt)
    })
    ],[#align(right)[ #text(80pt)[🌐]]],
    [],[],[],
  )
  Le *client* envoie un HMAC des messages précédents. La clé est dérivée du secret partagé par (EC)DHE. Cela assure que les deux parties ont bien *dérivé la même clé*.
]

#slide[
    == TLS1.3 : Tunnel sécurisé

    Après établissement d'un clé de session :

    - Les données sont envoyées chiffrés en utilisant du *chiffrement authentique*
    - L'en-tête clair contient la taille des données
    - Les applications utilisant TLS peuvent utiliser un *padding optionnel* (qui sera chiffré) pour tenter de *cacher la taille des données*
]



#focus-slide[
    La semaine prochaine : un petit bonus et *présentation des projets*

    Bon courage !
]