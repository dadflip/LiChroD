#!/bin/bash

HOME_LICHROD="/home/$USER/.lichrod"

# Se rendre dans le répertoire contenant les logiciels
cd $HOME_LICHROD/libs

# Afficher une fenêtre de sélection avec Zenity
install_choice=$(zenity --list --title="Choix d'installation de Java" --text="Choisissez le type d'installation:" --column="Choix" "Automatique" "Manuelle" --height=200)

if [[ $install_choice == "Automatique" ]]; then
    # Installation automatique
    sudo apt install openjdk-11-jdk
else
    # Afficher le lien Oracle dans un champ copiable
    zenity --info --title="Installation manuelle" --text="Voici le lien Oracle : (copiez-le) :
https://www.oracle.com/java/technologies/downloads/#java8"
    
    jre_url=$(zenity --entry --title="Installation manuelle" --text="Veuillez entrer le lien du telechargement du fichier .deb de Java JRE (voir lien precedent) :")
    
    if [[ ! -z $jre_url ]]; then
        wget $jre_url
        jre_filename=$(basename $jre_url)
        xterm -e "sudo dpkg -i $jre_filename"
        xterm -e "sudo apt-get install -f"  # Réparer les dépendances au besoin
    else
        zenity --error --text="Lien de telechargement non saisi. L'installation manuelle est annulee."
    fi
fi

# Se rendre à la racine du système de fichiers
cd
