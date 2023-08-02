#import "@preview/polylux:0.2.0": *
#import "@preview/tablex:0.0.4": tablex, gridx, hlinex, vlinex, colspanx, rowspanx

#import themes.simple: *

#set text(font: "Inria Sans")

#show: simple-theme.with(
  footer: [Simple slides],
)

#title-slide[
  = Cryprographie
  #v(2em)
  Introduction & Histoire de la cryptographie
  #v(2em)

  Alexander Schaub #footnote[DGA-MI, Bruz] #h(1em)
  
  schaub.alexander\@free.fr

  #h(1em)
  

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
#let cell = block.with(
  width: 100%,
)
#grid(
  columns: (auto, auto),
  rows: (auto),
  gutter: 3pt,
  cell(height: 100%)[
  *Chiffre de substitution*
  
  #only(1)[#image("img/CaesarDisk.jpg", width: 90%)]
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
  cell(height: 100%)[
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

  // skip a column here         vv
  (), vlinex(), vlinex(),vlinex(),vlinex(), (),
  [A], [T],  [T], [A],[Q],
  [U], [E], [Z], [A],[L],
  [A], [U], [B], [E],()
  //   ^^ '()' after the first cell are 100% ignored
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


