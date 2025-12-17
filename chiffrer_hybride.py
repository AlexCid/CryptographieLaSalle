import sys
import secrets
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.asymmetric import padding

fichier_a_chiffrer = sys.argv[1]
fichier_a_creer = sys.argv[2]
cles_destinataires = sys.argv[3:]


cle_symmetrique = secrets.token_bytes(32)
chiffres_cle = []

for cle in cles_destinataires:
    with open(cle, "rb") as key_file:
        public_key = serialization.load_pem_public_key(
            key_file.read(),
        )
        ciphertext = public_key.encrypt(
            cle_symmetrique,
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA256()),
                algorithm=hashes.SHA256(),
                label=None,
            ),
        )
        chiffres_cle.append(ciphertext)

# TODO : chiffrer les données


resultat = {
    "iv":iv,
    "chiffre": chiffre,
    "chiffres_cle": chiffres_cle
}

import pickle
pickle.dump(resultat, open(fichier_a_creer, "wb"))