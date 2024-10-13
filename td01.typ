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

On a intercepté le texte suivant:

```
VLETDIBTLRVWISIDIZSFDJAAQHEKXVTWMXWQRMILMFJVEBWRVZJUZDLWWSELWZSSKMIEEAXFNAGYKQVNWJQWU
CABSRWVLITSGGZMRMDETWZTMWXDTDBZSKWYFUBWRLNVRMBEARVCMHEQXVTRSMEJPVQNVWURRKWUMJAYIAQWXI
AKARWXTEAHVGKFNLWWWYUETAGSYVSZSGASVSYMMSYKAKZIFYLNPGQEJRLILIJWVOCKSFYEEAWXETITAKIKFZE
CPUMNCABLEUMVNBSGWVLOVHIFXVEBSGWVLOVEEFLVACPYKFXEAUSERVACPRGZIRQLYJJJACPPGHLTQGRKQFCI
DIKFLXQFXGSRTQGRKIVSXSCKFESIMBGIVUZKHMXFLLWWNNCLIYIKJKDMDEAWCUQEIEJAAQEIEFDAQKSFTLJIA
KJFEDQVIEJJFMFILWVSRWZGNJLIKIASVQCAGGZCETWPGSXDMESFORRLARVJIRQWVWQRRWMXWUIEAIYWHYEHES
AQRGZSRVJVTTSVYJJEQFIIZZVIVIJTLEVSYZFMRMUSMAVRBWHWGRTMSYPVLIXSWKJET
```

Grâce à votre raiseau d'espions, vous savez qu'il s'agit d'un texte clair en français qui a été chiffré avec un système de Vigenère, réputé inviolable ! Cela ne va cependant pas vous arrêter, et vous vous attelez à la lourde tâche de déchiffrer ce message cryptique...

== Décryptage automatique du chiffre Caesar

Dans la partie précédente, vous avez probablement essayé les 25 chiffrements Caesar différents pour voir "à l'oeil" quel déchiffrement produit un texte français lisible. C'est une solution, mais on peut faire mieux : retrouver directement le chiffrement utilisé grâce à la méthode des fréquences.

En français, les fréquences des lettres sont les suivantes :

```python
frequences = {'A': 0.0815, 'N': 0.0712, 'B': 0.0097, 'O': 0.0528, 'C': 0.0315, 'P': 0.028, 'D': 0.0373, 'Q': 0.0121, 'E': 0.1739, 'R': 0.0664, 'F': 0.0112, 'S': 0.0814, 'G': 0.0097, 'T': 0.0722, 'H': 0.0085, 'U': 0.0638, 'I': 0.0731, 'V': 0.0164, 'J': 0.0045, 'W': 0.0003, 'K': 0.0002, 'X': 0.0041, 'L': 0.057, 'Y': 0.0028, 'M': 0.0287, 'Z': 0.0015}
```

Afin de retrouver automatiquement le bon texte clair pour un texte chiffré par un chiffrement Caesar, vous pouvez appliquer l'algorithme suivant :

- Appliquez un déchiffrement Caesar (B #sym.arrow A puis C #sym.arrow A etc)
- Calculez la fréquence des lettres du nouveau texte obtenu
- Effectuez un produit scalaire entre le vecteur des fréquences du texte et le vecteur de fréquence des lettres dans la langue française
- Le texte qui maximise ce produit scalaire a de fortes chances d'être le bon texte clair

Implémentez une telle fonction de déchiffrement automatique. Fonctionne-t-elle sur le texte chiffré de la partie I ? Pourquoi cela pourrait-il ne pas être le cas ?

/ Question bonus: Pourquoi cela fonctionne-t-il ?

== Détermination de la taille de la clé utilisée

Armé de cet algorithme, nous allons pouvoir déterminer la taille de la clé utilisée pour le chiffrement Vigenère. En effet, on peut remarquer que pour une clé de taille $L$, le texte obtenu en ne gardant qu'une lettre sur $L$ du chiffré est en fait le chiffrement, par un chiffre de type Caesar, du texte clair dans lequel on n'aurait gardé qu'une lettre sur $L$.

Ainsi, si on a correctement déterminé la longueur de la clé, alors l'algorithme de la question précédente devrait trouver un déchiffrement Caesar associé à un produit scalair important (pour le chiffré obtenu en gardant une lettre sur $L$), alors que pour une longueur de clé incorrecte, tous les produits scalaires devraient être relativement faibles.

Sachant que la clé est de longueur inférieure à 20, déterminez celle-ci. Vous pouvez sélectionner le sous-texte obtenu un gardant une lettre sur $L$ en Python en utilisant la syntaxe `texte[::L]`. Pour toutes les hypothèses de taille $L$ entre 1 et 20, calculer le produit scalaire le plus important en appliquant tous les déchiffrement Caesar possibles, et affichez ces valeurs. Que remarquez-vous ?

== Décryptage complet
Une fois la taille de la clé obtenue, il devrait être aisé de décrypter entièrement le texte en effectuant $L$ décryptage Caesar successifs. Quelle était la clé ?
