import os, sys
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.primitives.asymmetric import padding as padding_asym
from cryptography.hazmat.primitives.serialization import load_pem_public_key


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

chiffrés_de_key = []
# Solution de PIerre-Louis
for destinataire in destinataires:
    key_pub = load_pem_public_key(open(destinataire, mode="rb").read())
    clef_chiffre = key_pub.encrypt(
        key,
        padding_asym.OAEP(
            mgf=padding_asym.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )

    chiffrés_de_key.append(clef_chiffre)




data = {
    "iv": iv,
    "chiffre": chiffre,
    "chiffrés_de_key" : chiffrés_de_key
}

import pickle
pickle.dump(data, open(fichier_chiffre, mode="xb"))

