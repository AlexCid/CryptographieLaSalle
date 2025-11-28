# Exercice 0
def dechiffre_cesar(texte, dec):
    resultat = ""
    for char in texte:
        code = ord(char) - dec
        if code < ord('A'):
            code += 26
        resultat += chr(code)
    return resultat

def chiffre_cesar(texte, dec):
    resultat = ""
    for char in texte:
        code = ord(char) + dec
        if code > ord('Z'):
            code -= 26
        resultat += chr(code)
    return resultat


def chiffre_vigenere(texte, cle):
    resultat = ""
    for (i,char) in enumerate(texte):
        resultat += chiffre_cesar(char, ord(cle[i%len(cle)]) - ord("A"))
    return resultat
    
def dechiffre_vigenere(texte, cle):
    resultat = ""
    for (i,char) in enumerate(texte):
        resultat += dechiffre_cesar(char, ord(cle[i%len(cle)]) - ord("A"))
    return resultat

mots = open("FR7.txt").read().split("\n")[:-1]
mots_sets = set(mots)
c1 = "WIBXBCY"
c2 = "PIBKMAJ"

solution = []
for m in mots:
    k_pe = dechiffre_vigenere(c1, m)
    m2_pe = dechiffre_vigenere(c2, k_pe)
    if m2_pe in mots_sets:
        solution.append((m, m2_pe))
print(solution)
