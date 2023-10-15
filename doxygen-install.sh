#!/bin/bash

# Fonction pour afficher une fenêtre Zenity
display_zenity() {
    zenity --info --text="$1"
}

# Récupérer le chemin absolu du répertoire courant
CURRENT_DIR=$(pwd)

# Chemin du dossier LiChroD
LICHROD_DIR="LiChroD.v3.0"

# Chemin complet du dossier LiChroD en ajoutant le répertoire courant
MAIN_DIRECTORY="$CURRENT_DIR/$LICHROD_DIR"

# Chemin du dossier utilisateur LiChroD
HOME_LICHROD="/home/$USER/.lichrod"

# Afficher une fenêtre Zenity pour l'en-tête
display_zenity "Ce script effectuera l'installation de Doxygen."

# Installation des dépendances
display_zenity "Installation des dependances (flex, bison, make)..."
sudo apt --no-install-recommends install -y flex bison make

# Clonage de Doxygen et compilation
display_zenity "Telechargement et installation de Doxygen..."
mkdir -p "$HOME_LICHROD/libs"
cd "$HOME_LICHROD/libs"
git clone --depth 1 https://github.com/doxygen/doxygen.git

mkdir -p "$HOME_LICHROD/modules/doxygen/build"
cd "$HOME_LICHROD/modules/doxygen/build"
cmake -G "Unix Makefiles" ..
make
sudo make install

# Installation de l'interface graphique de Doxygen
sudo apt-get install -y doxygen-gui
echo "Pour utiliser l'interface graphique de Doxygen, entrez 'doxywizard' dans un terminal." | tee -a "/home/$USER/READ_ME_LICHROD/utiliser_doxygen"

# Déplacement de Doxygen vers /opt
sudo mv -T "$HOME_LICHROD/modules/doxygen/" /opt/doxygen/

# Afficher un message de fin
display_zenity "Installation de Doxygen terminee avec succes."

# Fonction pour afficher un message de statut
display_status() {
    echo -e "\n==> $1"
}
