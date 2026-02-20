import sys
import getpass
import secrets
import cryptography
from cryptography.hazmat.primitives.kdf.argon2 import Argon2id
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

padder = padding.PKCS7(128).padder()


fichier_a_chiffrer = sys.argv[1]
fichier_sortie = sys.argv[2]
mdp = getpass.getpass("Entrez le mot de passe: ")
with open(fichier_a_chiffrer, mode="rb") as f:
    contenu = f.read()
    iv = secrets.token_bytes(16)
    kdf = Argon2id(
        salt=b"\x00" * 16,
        length=32,
        iterations=1,
        lanes=4,
        memory_cost=64 * 1024,
        ad=None,
        secret=None,
    )
    cle = kdf.derive(mdp.encode("utf-8"))
    cipher = Cipher(algorithms.AES(cle), modes.CBC(iv))

    padded_data = padder.update(contenu)
    padded_data += padder.finalize()
    encryptor = cipher.encryptor()
    contenu_chiffre = encryptor.update(padded_data) + encryptor.finalize()
    with open(fichier_sortie, mode="wb") as f_sortie:
        f_sortie.write(iv + contenu_chiffre)
