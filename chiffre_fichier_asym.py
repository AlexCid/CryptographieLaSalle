import os, sys
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding

if len(sys.argv) < 4:
    exit()

fichier_clair = sys.argv[1]
fichier_chiffre = sys.argv[2]
destinataires = sys.argv[3:]

key = os.urandom(32)
clair = open(fichier_clair, mode="rb").read()
iv = os.urandom(16)

cipher = Cipher(algorithms.AES(key), modes.CBC(iv))
encryptor = cipher.encryptor()

padder = padding.PKCS7(128).padder()
clair_padde = padder.update(clair) + padder.finalize()

chiffre = encryptor.update(clair_padde)+encryptor.finalize()
import pickle

data = {
    "iv": iv,
    "chiffre": chiffre,
    "chiffrés_de_key" : []
}

pickle.dump(data, open(fichier_chiffre, mode="xb"))

