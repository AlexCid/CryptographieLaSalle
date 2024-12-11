import os, sys
from cryptography.hazmat.primitives.kdf.argon2 import Argon2id
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding

if len(sys.argv) > 3:
    exit()

fichier_clair = sys.argv[1]
fichier_chiffre = sys.argv[2]

import getpass
mdp = str(getpass.getpass("Insérez votre mdp : "))


# Etape 1 : dérivation clé AES à partir du MDP (argon2id)
kdf = Argon2id(
    salt=b"aaaaaaaa",
    length=32,
    iterations=1,
    lanes=4,
    memory_cost=64 * 1024,
    ad=None,
    secret=None,
)

key = kdf.derive(mdp.encode())

# Etape 2 : lire le contenu de fichier_clair
contenu_clair = open(fichier_clair, "rb").read()

# Etape 3 : chiffrer le contenur de fichier_clair avec la clé dérivée
padder = padding.PKCS7(128).padder()
contenu_clair = padder.update(contenu_clair)
contenu_clair += padder.finalize()
iv = os.urandom(16)
cipher = Cipher(algorithms.AES(key), modes.CBC(iv))
encryptor = cipher.encryptor()
ct = encryptor.update(contenu_clair) + encryptor.finalize()

# Etape 4 : stocker le chiffré dans fichier_chiffre
f = open(fichier_chiffre, "xb")
f.write(iv)
f.write(ct)
f.flush()

