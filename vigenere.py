def dechiffre_cesar(texte, dec):
    resultat = ""
    for char in texte:
        if char.isalpha():
            decalage = dec % 26
            code = ord(char) - decalage
            if char.islower():
                if code < ord('a'):
                    code += 26
            elif char.isupper():
                if code < ord('A'):
                    code += 26
            resultat += chr(code)
        else:
            resultat += char
    return resultat


def score(texte):
    frequences = {'A': 0.0815, 'N': 0.0712, 'B': 0.0097, 'O': 0.0528, 'C': 0.0315, 'P': 0.028, 'D': 0.0373, 'Q': 0.0121, 'E': 0.1739, 'R': 0.0664, 'F': 0.0112, 'S': 0.0814, 'G': 0.0097, 'T': 0.0722, 'H': 0.0085, 'U': 0.0638, 'I': 0.0731, 'V': 0.0164, 'J': 0.0045, 'W': 0.0003, 'K': 0.0002, 'X': 0.0041, 'L': 0.057, 'Y': 0.0028, 'M': 0.0287, 'Z': 0.0015}

    freq = {}
    for c in texte:
        freq[c] = freq.get(c,0) + 1/len(texte)

    res = 0
    for c in freq:
        res += freq[c]*frequences[c]

    return res

chiffre = "VLETDIBTLRVWISIDIZSFDJAAQHEKXVTWMXWQRMILMFJVEBWRVZJUZDLWWSELWZSSKMIEEAXFNAGYKQVNWJQWUCABSRWVLITSGGZMRMDETWZTMWXDTDBZSKWYFUBWRLNVRMBEARVCMHEQXVTRSMEJPVQNVWURRKWUMJAYIAQWXIAKARWXTEAHVGKFNLWWWYUETAGSYVSZSGASVSYMMSYKAKZIFYLNPGQEJRLILIJWVOCKSFYEEAWXETITAKIKFZECPUMNCABLEUMVNBSGWVLOVHIFXVEBSGWVLOVEEFLVACPYKFXEAUSERVACPRGZIRQLYJJJACPPGHLTQGRKQFCIDIKFLXQFXGSRTQGRKIVSXSCKFESIMBGIVUZKHMXFLLWWNNCLIYIKJKDMDEAWCUQEIEJAAQEIEFDAQKSFTLJIAKJFEDQVIEJJFMFILWVSRWZGNJLIKIASVQCAGGZCETWPGSXDMESFORRLARVJIRQWVWQRRWMXWUIEAIYWHYEHESAQRGZSRVJVTTSVYJJEQFIIZZVIVIJTLEVSYZFMRMUSMAVRBWHWGRTMSYPVLIXSWKJET"

def determiner_taille_cle():
    scores = [0]
    for L in range(1,21):
        texte = chiffre[::L]

        meilleur_score = 0
        for dec in range(26):
            s = score(dechiffre_cesar(texte, dec))
            if s > meilleur_score:
                meilleur_score = s
        scores += [meilleur_score]
    return scores

print(determiner_taille_cle())

def determiner_cle():
    cle = ""
    for L in range(7):
        texte = chiffre[L::7]

        meilleur_score = 0
        meilleur_dec = 0
        for dec in range(26):
            s = score(dechiffre_cesar(texte, dec))
            if s > meilleur_score:
                meilleur_score = s
                meilleur_dec = dec
        cle += chr(ord('A')+meilleur_dec)
    return cle

print(determiner_cle())
        
            