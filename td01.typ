#set page(
  paper: "a4",
)

#set heading(numbering: (..nums) => nums
    .pos()
    .slice(1)
    .map(str)
    .join(".")
)
#align(center, text(25pt)[Cryptographie])
#align(center, text(17pt)[TD n°1 : Introduction & Histoire de la cryptographie])


= Partie I


== Chiffrement Caesar

En utilisant la substitution A #sym.arrow E, B #sym.arrow F, ..., chiffrez le texte suivant:


`ATTAQUEZ AU CREPUSCULE`


== Avé Caesar !

Le texte suivant a été chiffré suivant un chiffrement de substitution de type Caesar. Saurez-vous retrouver le message originel ?

`WR AR CRAFR CNF DH VY L NVG QR OBAAR BH QR ZNHINVFR FVGHNGVBA`

Remarque: vous pouvez écrire un programme en Python pour vous aider



= Partie II


