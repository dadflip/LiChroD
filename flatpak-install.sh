#!/bin/bash

# Mettre à jour la liste des paquets disponibles
sudo apt update -y

# Mettre à jour les paquets installés
sudo apt upgrade -y

# Installer flatpak
sudo apt --no-install-recommends install -y flatpak

# Ajouter le dépôt Flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Liste des applications avec leurs descriptions
app_list=(
    "com.spotify.Client" "Spotify" "Service de streaming musical"
    "org.freecadweb.FreeCAD" "FreeCAD" "Conception assistee par ordinateur (CAO)"
    "org.videolan.VLC" "VLC" "Lecteur multimedia polyvalent"
    "com.usebottles.bottles" "Bottles" "Assistant pour exécuter des applications Windows"
    "org.gimp.GIMP" "GIMP" "Editeur d'images"
    "org.inkscape.Inkscape" "Inkscape" "Editeur de graphiques vectoriels"
    "cc.arduino.IDE2" "Arduino IDE" "Environnement de développement pour Arduino"
    "org.blender.Blender" "Blender" "Suite de création 3D"
    "org.fritzing.Fritzing" "Fritzing" "Logiciel de conception de circuits électroniques"
    "nz.mega.MEGAsync" "MEGA" "Stockage en ligne sécurisé et collaboration"
    "org.signal.Signal" "Signal" "Messagerie privée sécurisée"
)

# Supprimer les accents et les apostrophes des descriptions
for ((i=0; i<${#app_list[@]}; i+=3)); do
    description="${app_list[i+2]}"
    # Supprimer les accents et les apostrophes
    clean_description=$(echo "$description" | iconv -t ASCII//TRANSLIT)
    app_list[i+2]="$clean_description"
done

# Boîte de dialogue pour choisir entre les options
choice=$(zenity --list --radiolist --title="Choisissez une option" --column="" --column="Option" TRUE "Installer autres paquets" FALSE "Installer les applications proposees")

# Variable pour suivre l'état de "Installer autres paquets"
install_other_packages=false

# Installer les applications sélectionnées
if [[ "$choice" == "Installer les applications proposees" ]]; then
    choices=$(zenity --list --checklist --title="Selectionnez les applications a installer" --column="Installer" --column="Application" --column="Description" "${app_list[@]}")
    for choice in $choices; do
        package=$(echo "$choice" | awk '{print $1}')
        package=$(echo "$package" | tr '|' ' ')
        if [[ "$package" != "Installer" ]]; then
            xterm -e "sudo flatpak install -y flathub '$package'"
        fi
    done
else
    # Si "Installer autres paquets" est coché, exécutez le script correspondant
    lichrod-flatpak-wizard.sh
fi
