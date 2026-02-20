import sys
import getpass
import secrets
import cryptography
from cryptography.hazmat.primitives.kdf.argon2 import Argon2id
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

unpadder = padding.PKCS7(128).unpadder()


fichier_chiffre = sys.argv[1]
fichier_sortie = sys.argv[2]
mdp = getpass.getpass("Entrez le mot de passe: ")
with open(fichier_chiffre, mode="rb") as f:
    contenu = f.read()
    iv = contenu[:16]
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

    clair = cipher.decryptor().update(contenu[16:]) + cipher.decryptor().finalize()
    clair_unpadde = unpadder.update(clair) + unpadder.finalize()

    with open(fichier_sortie, mode="wb") as f_sortie:
        f_sortie.write(clair_unpadde)
