import sys
import os
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding


if len(sys.argv) < 3:
    exit()

fichier_clair = sys.argv[1]
fichier_chiffre = sys.argv[2]

import getpass
mdp = str(getpass.getpass("Insérez votre mdp : "))

kdf = PBKDF2HMAC(
    algorithm=hashes.SHA256(),
    length=32,
    salt=bytes([0]*16),
    iterations=480000,
)

key = kdf.derive(mdp.encode())

clair = open(fichier_clair, mode="rb").read()

iv = os.urandom(16)

cipher = Cipher(algorithms.AES(key), modes.CBC(iv))

encryptor = cipher.encryptor()

f = open(fichier_chiffre, "wb")

padder = padding.PKCS7(128).padder()
clair_padde = padder.update(clair) + padder.finalize()

f.write(iv)
f.write(encryptor.update(clair_padde)+encryptor.finalize())
