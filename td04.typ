#set page(
  paper: "a4",
  numbering: "1"
)

#set heading(numbering: (..nums) => nums
    .pos()
    .slice(1)
    .map(str)
    .join(".")
)
#align(center, text(25pt)[Cryptographie])
#align(center, text(17pt)[TD n°4 : Intégrité et protocoles])

= Exercice 0

Si vous ne l'avez pas encore fait, implémentez le *déchiffrement* de l'utilitaire de chiffrement du TD3

= Exercice 1

Ajouter de *l'intégrité* aux données chiffrées. Quels sont les deux principaux mécanismes cryptoraphiques permettant d'assurer l'intégrité de données chiffrées ? 

Choisissant-en un et ajoutez-ce mécanisme à l'utilitaire du TD 3 pour garantir l'intégrité des données chiffrées.

= Exercice 2

Ajouter de *l'authenticité* aux données chiffrées. Quel mécanisme permet de garantir cette propriété ? 


