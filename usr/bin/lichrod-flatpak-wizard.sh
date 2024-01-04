#!/bin/bash


# Vérifier si Zenity est installé
if ! [ -x "$(command -v zenity)" ]; then
  echo "Erreur : Zenity n'est pas installé. Veuillez l'installer pour utiliser ce script."
  exit 1
fi

# Vérifier si Flatpak est installé, sinon l'installer
if ! [ -x "$(command -v flatpak)" ]; then
  zenity --info --title="Installation de Flatpak" --text="Flatpak n'est pas installé. Le script va l'installer pour vous."
  sudo apt install flatpak
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Afficher une boîte de dialogue informative
zenity --info --title="Assistant d'installation de logiciels flatpak" --text="Cet assistant vous permet d'installer, désinstaller ou mettre à jour des applications Flatpak."

# Demander à l'utilisateur le nom de l'application(s) Flatpak
applications=$(zenity --entry --title="Applications Flatpak" --text="Entrez le nom de l'application(s) Flatpak (s'il y en a plusieurs, séparez-les par un espace) :")

# Afficher les options dans une boîte de dialogue de sélection
choice=$(zenity --list --title="Options" --column="Option" "Installer" "Désinstaller" "Mettre à jour" "Quitter")

case "$choice" in
"Installer")
  xterm -e "sudo flatpak install flathub $applications"
  ;;
"Désinstaller")
  xterm -e "sudo flatpak uninstall $applications"
  ;;
"Mettre à jour")
  app_list=$(sudo flatpak list --app --columns=application,version)
  app_id=$(zenity --list --title="Sélectionner une application" --text="Sélectionnez l'application à mettre à jour :" --column="Application" --column="Version" $app_list)
  xterm -e "sudo flatpak update $app_id"
  ;;
*)
  exit
  ;;
esac

# Afficher les options pour continuer ou quitter
chx=$(zenity --list --title="Options" --column="Option" "Installer d'autres applications" "Quitter")

if [ "$chx" = "Installer d'autres applications" ]; then
  lichrod-flatpak-wizard.sh
else
  exit
fi
