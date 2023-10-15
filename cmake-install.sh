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
display_zenity "Ce script effectuera l'installation de CMake."

# Installation des dépendances
display_zenity "Installation des dependances (build-essential, gcc, libssl-dev)..."
sudo apt install -y build-essential gcc libssl-dev

# Demande à l'utilisateur d'entrer la version de CMake à installer
vers=$(zenity --entry --title="Installation de CMake" --text="Entrez la version la plus recente de CMake (format : X.X.X) :")

# Vérifier si la version entrée est valide
if [[ $vers =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # Télécharger CMake
    wget "https://github.com/Kitware/CMake/releases/download/v$vers/cmake-$vers.tar.gz"
    tar xvf "cmake-$vers.tar.gz"
    
    # Compiler et installer CMake
    cd "$CURRENT_DIR/cmake-$vers"
    ./bootstrap
    make
    sudo make install
    cmake --version
    
    # Déplacer les fichiers de CMake vers /opt
    sudo mv "$CURRENT_DIR/cmake-$vers" "/opt/CMake/"
    
    # Afficher un message de réussite
    display_zenity "Installation de CMake version $vers terminee avec succes."
else
    # Afficher un message d'erreur si la version entrée est invalide
    display_zenity "Version de CMake non valide. Veuillez entrer une version valide (format : X.X.X)"
fi

# Fonction pour afficher un message de statut
display_status() {
    echo -e "\n==> $1"
}
