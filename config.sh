#!/bin/bash

# Variables
BINARIES_DIRECTORY="/usr/bin"
OPT_DIRECTORY="/opt"
TMP_DIRECTORY="/tmp"

# Fonction pour afficher une fenêtre Zenity
display_zenity() {
    zenity --info --text="$1"
}

# Fonction pour afficher un message de statut
display_status() {
    echo -e "\n==> $1"
}

# Chemin complet du dossier des binaires
CURRENT_DIR=$(pwd)

# Chemin complet du dossier utilisateur
HOME_LICHROD="/home/$USER/.lichrod"

# Exécuter les commandes Git à l'intérieur d'un terminal xterm
xterm -e "cd $HOME_LICHROD/libs && git clone --depth 1 git@github.com:shevabam/htmlify-csv.git" &
xterm -e "cd $HOME_LICHROD/libs && git clone --depth 1 https://github.com/tensorflow/tensorflow.git" &

# Attendre que les fenêtres xterm se ferment
wait

# Afficher un message de fin avec la fonction display_zenity
display_zenity "Opérations terminées avec succès."

# Modifier les propriétaires des fichiers et dossiers
#sudo chown $USER:$USER "$MAIN_DIRECTORY/ZAP"
#sudo chown $USER:$USER "/home/$USER/*"
#sudo chown $USER:$USER "/home/$USER/composer-setup.php"

# Installation des dépendances (par exemple, npm)
# Commenté car l'exemple ne contient pas les détails complets
# sudo apt --no-install-recommends install npm

# Afficher un message de statut
display_status "Script terminé."
