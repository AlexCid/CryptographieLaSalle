texte = "VLETDIBTLRVWISIDIZSFDJAAQHEKXVTWMXWQRMILMFJVEBWRVZJUZDLWWSELWZSSKMIEEAXFNAGYKQVNWJQWUCABSRWVLITSGGZMRMDETWZTMWXDTDBZSKWYFUBWRLNVRMBEARVCMHEQXVTRSMEJPVQNVWURRKWUMJAYIAQWXIAKARWXTEAHVGKFNLWWWYUETAGSYVSZSGASVSYMMSYKAKZIFYLNPGQEJRLILIJWVOCKSFYEEAWXETITAKIKFZECPUMNCABLEUMVNBSGWVLOVHIFXVEBSGWVLOVEEFLVACPYKFXEAUSERVACPRGZIRQLYJJJACPPGHLTQGRKQFCIDIKFLXQFXGSRTQGRKIVSXSCKFESIMBGIVUZKHMXFLLWWNNCLIYIKJKDMDEAWCUQEIEJAAQEIEFDAQKSFTLJIAKJFEDQVIEJJFMFILWVSRWZGNJLIKIASVQCAGGZCETWPGSXDMESFORRLARVJIRQWVWQRRWMXWUIEAIYWHYEHESAQRGZSRVJVTTSVYJJEQFIIZZVIVIJTLEVSYZFMRMUSMAVRBWHWGRTMSYPVLIXSWKJET"
frequences_FR = {'A': 0.0815, 'N': 0.0712, 'B': 0.0097, 'O': 0.0528, 'C': 0.0315, 'P': 0.028, 'D': 0.0373, 'Q': 0.0121, 'E': 0.1739, 'R': 0.0664, 'F': 0.0112, 'S': 0.0814, 'G': 0.0097, 'T': 0.0722, 'H': 0.0085, 'U': 0.0638, 'I': 0.0731, 'V': 0.0164, 'J': 0.0045, 'W': 0.0003, 'K': 0.0002, 'X': 0.0041, 'L': 0.057, 'Y': 0.0028, 'M': 0.0287, 'Z': 0.0015}

def frequences(s: str):
    occurences = {}
    for c in s:
        occurences.setdefault(c, 0)
        occurences[c] += 1

    #return {lettre: occ / len(s) for lettre, occ in occurences.items()}
    frequences = {}
    for lettre, occ in occurences.items():
        frequences[lettre] = occ / len(s)
    return frequences

def produit_scalaire(freq1, freq2):
    resultat = 0.0
    for lettre in freq1.keys():
        resultat += freq1[lettre]*freq2[lettre]
    return resultat

def caesar_encrypt(texte, i):
    res = ""
    for c in texte:
        res += chr((((ord(c)+i)-ord("A"))%26)+ord("A"))
    return res

def caesar_decrypt(texte, i):
    res = ""
    for c in texte:
        res += chr((((ord(c)-i)-ord("A"))%26)+ord("A"))
    return res
    
def tous_ps(texte):
    res = []
    for i in range(26):
        enc = caesar_decrypt(texte, i)
        res.append(
            produit_scalaire(
                frequences(enc),frequences_FR
            )
        )
    return res


# Détermination de la taille de la clé
for i in range(2,11):
    t = texte[::i]
    print(i, max(tous_ps(t)))
# Le maximum est atteint pour i = 7 -> la taille de clé semble égale à 7

# Détermination de la clé
cle = ""
for i in range(7):
    s = texte[i::7]
    ps = tous_ps(s)
    cle += chr(ps.index(max(ps))+65)
print(cle)

# Déchiffrement du texte
clair = ""
for (i,c) in enumerate(texte):
    k = ord(cle[i%7])-65
    dechiffre = chr((((ord(c)-k)-ord("A"))%26)+ord("A"))
    clair += dechiffre
print(clair)






