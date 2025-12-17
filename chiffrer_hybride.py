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



from cryptography.hazmat.primitives import padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
iv = secrets.token_bytes(16)
padder = padding.PKCS7(128).padder()

cipher = Cipher(algorithms.AES(cle_symmetrique), modes.CBC(iv))

with open(fichier_a_chiffrer, mode="rb") as f:
    contenu = f.read()

padded_data = padder.update(contenu)
padded_data += padder.finalize()
encryptor = cipher.encryptor()
contenu_chiffre = encryptor.update(padded_data) + encryptor.finalize()

resultat = {
    "iv":iv,
    "chiffre": contenu_chiffre,
    "chiffres_cle": chiffres_cle
}
print(resultat)
import pickle
pickle.dump(resultat, open(fichier_a_creer, "wb"))