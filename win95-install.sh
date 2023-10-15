#!/bin/bash

# Vérifier si Zenity est installé
if ! [ -x "$(command -v zenity)" ]; then
  echo "Erreur : Zenity n'est pas installe. Veuillez l'installer pour utiliser ce script."
  exit 1
fi

# Afficher une boîte de dialogue informative
zenity --info --title="Installation" --text="Ce script va installer Windows 95 dans votre systeme. Assurez-vous d'avoir les droits d'administration."

# Créer un dossier Downloads s'il n'existe pas
mkdir -p ~/Downloads

# Installer les dépendances
sudo apt install -y libgconf2-4 gconf-gsettings-backend

# Télécharger le package Windows 95
wget https://github.com/felixrieseberg/windows95/releases/download/v1.2.0/windows95-linux_1.2.0_amd64.deb -P ~/Downloads

# Installer le package Windows 95
sudo dpkg -i ~/Downloads/windows95-linux_1.2.0_amd64.deb

# Vérifier si l'installation a réussi
if [ $? -eq 0 ]; then
  zenity --info --title="Succes" --text="L'installation de Windows 95 a ete effectuee avec succes."
else
  zenity --error --title="Erreur" --text="Une erreur s'est produite lors de l'installation de Windows 95."
fi
