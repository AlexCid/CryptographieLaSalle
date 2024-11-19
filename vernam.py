def vigenere_chiffre(message: str, clef: str) -> str:
    s = ""
    for (m, c) in zip(message, clef):
        decalage = ord(c) - ord("A")
        nouvelle_lettre = ord(m) + decalage
        if nouvelle_lettre > ord("Z"):
            nouvelle_lettre -= 26
        s += chr(nouvelle_lettre)
    
    return s

def vigenere_dechiffre(message: str, clef: str) -> str:
    s = ""
    for (m, c) in zip(message, clef):
        decalage = ord(c) - ord("A")
        nouvelle_lettre = ord(m) - decalage
        if nouvelle_lettre < ord("A"):
            nouvelle_lettre += 26
        s += chr(nouvelle_lettre)
    
    return s


print(vigenere_chiffre("ABCD", "EFGH"))
c1 = "WIBXBCY"
c2 = "PIBKMAJ"

diff = vigenere_dechiffre(c1, c2)
print(diff)
mots_fr = open("FR7.txt").read().split()

for m1 in mots_fr:
    for m2 in mots_fr:
        if vigenere_dechiffre(m1, m2) == diff:
            print("%s / %s" % (m1, m2))