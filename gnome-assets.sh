#!/bin/bash

echo "======================================================================"
echo "             DEBUT INSTALLATION PACKAGES ADDITIONNELS GNOME           "
echo "======================================================================"

sudo apt update
sudo apt upgrade

# Utilisation de boites a cocher avec Zenity pour la selection des paquets
choices=$(zenity --list --checklist --title="Selectionnez les paquets a installer" --column="Installer" --column="Paquet" --column="Description" \
    FALSE "alacarte" "Editeur de menus graphique pour GNOME" \
    FALSE "desktopfolder" "Creer des icones de dossiers sur le bureau" \
    FALSE "supertuxkart" "Jeu de course de karts 3D")

# Installer les paquets sélectionnés
for choice in $choices; do
    package=$(echo "$choice" | awk '{print $1}')
    package=$(echo "$package" | tr '|' ' ')
    sudo apt install -y $package
done

echo "======================================================================"
echo "                              TERMINE                                 "
echo "======================================================================"

zenity --info --title="Operation effectuee" --text="Les paquets ont ete installes avec succes"
