#!/bin/bash

# Vérifier si Zenity est installé
if ! [ -x "$(command -v zenity)" ]; then
  echo "Erreur : Zenity n'est pas installé. Veuillez l'installer pour utiliser ce script."
  exit 1
fi

# Installer Firefox ESR
sudo apt install firefox-esr

# Obtenir l'adresse IP du serveur
ip_address=$(ip a | awk '/inet / {print $2}')

# Afficher l'adresse IP dans Zenity
zenity --info --title="Adresse IP du serveur" --text="L'adresse IP de votre serveur est : $ip_address"

# Demander à l'utilisateur l'adresse IP du serveur via Zenity
user_input=$(zenity --entry --title="Adresse IP du serveur" --text="Entrez l'adresse IP de votre serveur (voir ci-dessus) :")

# Ouvrir PHPMyAdmin dans Firefox en utilisant l'adresse IP fournie
firefox "http://$user_input/pma" &> /dev/null

# Vérifier si Firefox a été lancé avec succès
if [ $? -eq 0 ]; then
  zenity --info --title="Succès" --text="PHPMyAdmin a été ouvert dans Firefox."
else
  zenity --error --title="Erreur" --text="Erreur : impossible d'ouvrir PHPMyAdmin dans Firefox."
fi

