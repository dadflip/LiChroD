#!/bin/bash

# Fonction pour afficher un message avec Zenity
display_message() {
    zenity --info --title="Message" --text="$1"
}

# Variables
DIRECTORIES=("/usr/bin" "/boot" "/dev" "/etc" "/home" "/lib" "/lib64" "/mnt" "/media" "/opt" "/proc" "/root" "/run" "/sbin" "/srv" "/sys" "/tmp" "/usr" "/var")
MYAPP="/opt/myapp"
MYAPP_MODULES="$MYAPP/modules"

# Afficher un message d'introduction
display_message "Installation de Hashcat" "Ce script va installer Hashcat et d'autres dependances necessaires."

# Installation de Hashcat et dépendances
( sudo apt install -y hashcat ) | zenity --text-info --title="Processus d'installation"
display_message "Installation terminee" "Hashcat et les dependances ont ete installés avec succes."

# Installation d'autres outils utiles
display_message "Installation d'autres outils" "En cours..."
sudo apt --no-install-recommends install -y setoolkit nmap


# Afficher un message de fin
display_message "Installation terminee" "L'installation de Hashcat et des dependances est terminee avec succes."
