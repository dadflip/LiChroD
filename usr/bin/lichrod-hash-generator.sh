#!/bin/bash

# Variables
MYAPP="/opt/myapp"
HASH_ALGORITHMS=("md5sum" "sha1sum" "sha256sum" "sha512sum")

# Afficher un message d'introduction avec Zenity
zenity --info --title="Generation de hachage de mot de passe" --text="Ce script va generer un hachage de mot de passe en utilisant differents algorithmes et l'enregistrer dans un fichier."

# Afficher un selecteur pour choisir l'algorithme de hachage
selected_algorithm=$(zenity --list --title="Choisir un algorithme de hachage" --text="Choisissez un algorithme de hachage:" --column="Algorithme" "${HASH_ALGORITHMS[@]}")

# Verifier si l'utilisateur a annule la selection
if [ $? -ne 0 ]; then
    zenity --info --title="Operation annulee" --text="L'operation a ete annulee par l'utilisateur."
    exit 1
fi

# Demander le mot de passe a l'utilisateur
passwd=$(zenity --password --title="Entrez le mot de passe" --text="Entrez le mot de passe a hasher:")

# Verifier si l'utilisateur a annule la saisie du mot de passe
if [ $? -ne 0 ]; then
    zenity --info --title="Operation annulee" --text="L'operation a ete annulee par l'utilisateur."
    exit 1
fi

# Calculer le hachage du mot de passe
hash=$(echo -n "$passwd" | $selected_algorithm | awk '{print $1}')

# Enregistrer le hachage dans un fichier avec Zenity
mkdir -p $MYAPP/MyApp/extensions/Hashcat/HashedFile
touch $MYAPP/MyApp/extensions/Hashcat/HashedFile/ghashfile.txt
echo "$hash" > "$MYAPP/MyApp/extensions/Hashcat/HashedFile/ghashfile.txt"
zenity --info --title="Hachage enregistre" --text="Le hachage du mot de passe a ete enregistre dans le fichier '$MYAPP/MyApp/extensions/Hashcat/HashedFile/ghashfile.txt'."

# Fin du script
zenity --info --title="Script termine" --text="Le script de generation de hachage de mot de passe est termine."

